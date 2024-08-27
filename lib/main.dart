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
                var urlMercari = Uri.https(
                  'www.mercari.com', // 호스트 이름
                  '/search/', // 경로
                  {'keyword': keywordController.text},
                ); // 쿼리 파라미터
                retrieveSellList(urlMercari);

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
                retrieveSellList(urlYahooAuction);
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
            Text(
              "Search List (To be updated)",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }

  void retrieveSellList(Uri url) async {
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      dom.Document document = parser.parse(response.body);

      List<dom.Element> temp = document.getElementsByClassName("BodyContainer-sc-15b083c9-0 SearchBodyContainer-sc-d3f42f57-0 kwsxFw NonJg");
      // div id="m83641857846" 요소를 찾음
      dom.Element? divElement = document?.getElementById('m37515470387');
      dom.Element? divElement2 = document.body?.querySelector('m37515470387');

      if (divElement != null) {
        print('Found div: ${divElement.outerHtml}');
      } else {
        print('Div with id "m83641857846" not found.');
      }
    } else {
      print('Failed to load the webpage.');
    }
  }
}
