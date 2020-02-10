import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'AutoFront',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return createListView(context, snapshot);
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home Page"),
      ),
      body: futureBuilder,
    );
  }

  Future<List> _getData() async {
    var values = new List();
    String apiUrl =
        'https://protected-ridge-35353.herokuapp.com/api/pages/page_test';
    http.Response response = await http.get(apiUrl);
    final items = json.decode(response.body);
    for (var item in items['data']['body']['render']) {
      values.add(item);
    }
    return values;
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List values = snapshot.data;
    List<Widget> childrenArray = [];

    for (final value in values) {
       childrenArray
            .add(InputWidgetState(autoInput: new AutoInputInferface('value')));
    }

    return new ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return new Column(
          children: childrenArray,
        );
      },
    );
  }
}

class TextWidget extends StatelessWidget {
  final AutoTextWidgetInferface autoInput;

  TextWidget({Key key, @required this.autoInput}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(this.autoInput.label));
  }
}

class AutoTextWidgetInferface {
  final String label;

  AutoTextWidgetInferface(this.label);
}

class InputWidgetState extends StatelessWidget {
  final AutoInputInferface autoInput;

  // In the constructor, require a Person
  InputWidgetState({Key key, @required this.autoInput}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: autoInput.label,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}

class AutoInputInferface {
  final String label;

  AutoInputInferface(this.label);
}
