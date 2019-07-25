import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String radioValue;
  void _radioButton(String value) {
    setState(() {
      radioValue = value;
    });
  }

  final _questionController = TextEditingController();
  final _titleController = TextEditingController();
  List<TextEditingController> _optionController = [
    TextEditingController()
  ];
  final List<bool> checkBoxValue = [false];
  final _urlAPI =
      "http://us-central1-learntech-d9387.cloudfunctions.net/widgets/quizzes/";

  void _submit(){
    List<String> listAns = [];
    for (int countX = 0; countX < checkBoxValue.length; countX++) //adds to list of and based on index of checkbox
      {
        if (checkBoxValue[countX] == true)
        listAns.add(_optionController[countX].text);
      }
    List<String> listOpt =[];
    for (int x=0; x < _optionController.length; x++)
      {
        listOpt.add(_optionController[x].text);
      }
    var data = jsonEncode({
      'title': '${_titleController.text}',
      'type': '$radioValue',
      'question': '${_questionController.text}',
      'correctAnswer': listAns,
      'options': listOpt,
      'numberOfOptions': _optionController.length
    });
    apiRequest(data);
  }


  void _clearLines() {
    _questionController.clear();
    _titleController.clear();
    setState(() {
      _optionController = [TextEditingController()];
    });
  }

  Future<String> apiRequest(String jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(_urlAPI));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonMap));
    HttpClientResponse response = await request.close();
    String reply = await utf8.decoder.bind(response).join();
    httpClient.close();
    return reply;
  }

  @override
  void initState() {
    _optionController[0] = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Creation"),
      ),
      body: ListView(
        children: <Widget>[
          Text(
            "This application allows you to add quizzes to the Learn Tech application.\n",
            style: TextStyle(fontSize: 32.0),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0, left: 13.0, right: 13.0, bottom: 10.0),
            child: Text(
              "Please fill in the following",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Theme(
              data: ThemeData(primaryColor: Color(0XFF009688)),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                controller: _questionController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                style: TextStyle(fontSize: 20),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: "Question",
                  border: OutlineInputBorder(
                    gapPadding: 2,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: RadioListTile(
                    title: Text(
                      "radio",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    groupValue: radioValue,
                    value: "radio",
                    onChanged: _radioButton),
              ),
              Flexible(
                child: RadioListTile(
                    title: Text(
                      "checkbox",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    groupValue: radioValue,
                    value: "checkbox",
                    onChanged: _radioButton),
              ),
            ],
          ),
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Theme(
                data: ThemeData(primaryColor: Color(0XFF009688)),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _titleController,
                  style: TextStyle(fontSize: 20),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      labelText: "Title of Question",
                      border: OutlineInputBorder(
                          gapPadding: 2,
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0)))),
                ),
              )),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _optionController.length,
            itemBuilder: (context, index) => TextCheckBox(optionController: _optionController, checkController: checkBoxValue, index: index)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                child: RaisedButton(
                    child: Text(
                      "Add More Options",
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    onPressed: () {
                      setState(() {
                        _optionController.add(new TextEditingController());
                        checkBoxValue.add(false);
                      });
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
              ),
              ButtonTheme(
                buttonColor: Colors.red,
                child: RaisedButton(
                    child: Text(
                      "Delete Latest Option",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    onPressed: () {
                      setState(() {
                        _optionController.removeLast();
                        checkBoxValue.removeLast();
                      });
                    }),
              ),
            ],
          ),
          ButtonTheme(
            minWidth: 200.0,
            height: 100.0,
            buttonColor: Colors.lightGreen,
            child: RaisedButton(
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                onPressed: () {
                  _submit();
                  _clearLines();
                }),
          ),
        ],
      ),
    );
  }
}

class TextCheckBox extends StatefulWidget {

  TextCheckBox(
      {Key key,
        @required this.optionController,
        @required this.checkController,
        @required this.index})
      : super(key: key);

  final List<TextEditingController> optionController;
  final List<bool> checkController;
  final int index;

  @override
  _TextCheckBoxState createState() => _TextCheckBoxState();
}

class _TextCheckBoxState extends State<TextCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Theme(
        data: ThemeData(primaryColor: Color(0XFF009688)),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                textInputAction: TextInputAction.done,
                controller: widget.optionController[widget.index],
                style: TextStyle(fontSize: 20),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    labelText: "Option ${widget.index}",
                    border: OutlineInputBorder(
                        gapPadding: 2,
                        borderRadius:
                        BorderRadius.all(Radius.circular(5.0)))),
              ),
            ),
            Flexible(
              child: CheckboxListTile(
                title: Text("Is this the answer?"),
                value: widget.checkController[widget.index] ?? false,
                onChanged: (value) =>
                    setState(() => widget.checkController[widget.index] = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
