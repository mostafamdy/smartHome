import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot1/roomName.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  String _id;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeId(String id ) async {
    final file = await _localFile;
    return file.writeAsString('$id');
  }



  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Hello"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            "please enter the id , you can found it in the box ",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87, fontSize: 20),
          ),
        ),
        Padding(
          child: TextField(
            cursorColor: Colors.purple,
            textAlign: TextAlign.center,
            cursorWidth: 3,
            keyboardType: TextInputType.number,
            maxLength: 9,
            onChanged: (value) {
              _id = value;
            },
            decoration: InputDecoration(
              //hint
              hintText: "855-255-201",
              hintStyle: TextStyle(fontSize: 15),
              //error
//                  errorStyle: TextStyle(fontSize: 20),
//                  errorText: "max lines",
              // label
              labelText: "ID :",
              labelStyle: textStyle,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          padding: EdgeInsets.only(top: 100, right: 50, left: 50),
        ),
        Container(
          margin: EdgeInsets.only(top: 30, right: 30),
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Container(
              //margin: ,
              child: Icon(
                Icons.send,
                color: Colors.purpleAccent,
              ),
            ),
            elevation: 20,
            onPressed: () {
              writeId(_id);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoomName()),
              );
            },
            backgroundColor: Colors.white,
            splashColor: Colors.black54,
          ),
        )
      ]),
    );
  }
}
