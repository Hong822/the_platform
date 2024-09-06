import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart' as parser;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController keywordController = TextEditingController();
  String? imageUrl;

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextFormField(
              controller: keywordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "검색 키워드 입력",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var urlYahooAuction = Uri.https(
                  'auctions.yahoo.co.jp', // 호스트 이름
                  '/search/search', // 경로
                  {
                    'auccat': '',
                    'tab_ex': 'commerce',
                    'ei': 'utf-8',
                    'aq': '-1',
                    'oq': '',
                    'sc_i': '',
                    'exflg': '1',
                    'p': keywordController.text, // 검색어 파라미터
                    'x': '0',
                    'y': '0',
                  }, // 쿼리 파라미터 맵
                );
                imageUrl = await retrieveSellList(urlYahooAuction);
                print(imageUrl);
                if (imageUrl != null) {
                  setState(() {});
                }
                // var urlMercari = Uri.https(
                //   'www.mercari.com', // 호스트 이름
                //   '/search/', // 경로
                //   {'keyword': "seiko"},
                //   //{'keyword': keywordController.text},
                // ); // 쿼리 파라미터
                // await retrieveSellList(urlMercari);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("검색"),
                  Icon(
                    Icons.search,
                  ),
                ],
              ),
            ),
            ImageUpdate(imageUrl),
          ],
        ),
      ),
    );
  }

  Future<String?> retrieveSellList(Uri url) async {
    String? imageUrl;
    print(url);
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);
      List<dom.Element> temp = document
          .getElementsByClassName("Product__CDNImageWrapper-sc-8ff3bf4d-1");
      List<dom.Element> temp2 =
          document.getElementsByClassName("T3-sc-7hzl3c-a");
      List<dom.Element> temp3 =
          document.getElementsByClassName("Link__StyledAnchor-sc-c7cc0c35-0");
      List<dom.Element> temp4 = document
          .getElementsByClassName("Link__StyledPlainLink-sc-c7cc0c35-3");
      List<dom.Element> temp5 = document.getElementsByClassName("hRpGAg");
      List<dom.Element> temp6 = document.getElementsByClassName("djQHPU");
      List<dom.Element> YahooAuction =
          document.getElementsByClassName("Product");
      dom.Element? firstElem = YahooAuction[0].querySelector('img');
      imageUrl = firstElem?.attributes['src'];

      dom.Element? divElement = document?.getElementById('m68230965782');
      dom.Element? divElement2 = document.body?.querySelector('m37515470387');

      return imageUrl;
    } else {
      print('Failed to load the webpage.');
    }
  }

  Widget ImageUpdate(String? imageUrl) {
    print(imageUrl);
    if (imageUrl == null) {
      return Text(
        "Search List (To be updated)",
        style: Theme.of(context).textTheme.headlineMedium,
      );
    } else {
      return Image.network(imageUrl!);
    }
  }
}
