import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:developer';

import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
  //fetch();
}

Future<Ticker> fetch(coin) async {
  var url = "https://www.mercadobitcoin.net/api/" + coin + "/ticker/";
  final response = await http.get(Uri.parse(url));

  var bb = convert.jsonDecode(response.body);
  var lol = bb['ticker'];

  return Ticker(buy: lol['buy']);
}

class Ticker {
  final String buy;

  const Ticker({
    required this.buy,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de cripto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cripto stuff main page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String coin = "ETH";

  void _incrementCounter() {
    setState(() {
      _counter = _counter + 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            child: Column(children: [
          Text("Preço do(a): " + coin),
          Card(
              child: FutureBuilder<Ticker>(
                  future: fetch(coin),
                  builder: ((context, snapshot) {
                    if (snapshot.data == null) {
                      //print(snapshot.data);
                      return Container(
                          child: Center(
                              child:
                                  CircularProgressIndicator()) //Text("Loading")),
                          );
                    } else {
                      return ListTile(title: Text(snapshot.data?.buy ?? ''));
                    }
                  }))),
          TextField(
            onChanged: (value) => {coin = value, setState(() {})},
            onSubmitted: (value) => {coin = value, setState(() {})},
            decoration: InputDecoration(
                labelText: "Pesquise por uma criptomoeda",
                hintText: "Ex: BTC, ETH, DOGE, SHIB, WLUNA ..."),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            ),
            onPressed: () {},
            child: Text(
                'Botão não faz nada, só botei pq tu pediu, ele busca no onChange'),
          )
        ])));
  }
}
