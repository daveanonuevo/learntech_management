import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Creation"),
      ),
      body: ListView(
        children: <Widget>[
          Text("This application allows you to add quizzes to the Learn Tech application."),

        ],
      ),
    );
  }
}
