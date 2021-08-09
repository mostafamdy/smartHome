import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot1/roomName.dart';
import 'package:iot1/test.dart';
import 'package:path_provider/path_provider.dart';

import 'Home.dart';
import 'login.dart';

void main() => runApp(App());
//void main() => runApp(VD());
//void main() => runApp(MaterialApp(home: Scaffold(body: VideoApp(),),));

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes:<String, WidgetBuilder> {
        "/home": (BuildContext context) => Home(),
        "/login":(BuildContext context) => Login()
      },
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }
  Future<String> readId() async {
    try {
      final file = await _localFile;
      // Read the file.
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), () {
      readId().then((String s) {
        print("nnnnnnnnn");
        print(s);
        if (s == "") {
          print("Login");
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      body: Center(child: Icon(Icons.home,color: Colors.purpleAccent,size: 50,),),
        body: Stack(children: <Widget>[
          Image.asset("images/splach2.jpeg",fit: BoxFit.fitHeight,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,),
          Container(padding: EdgeInsets.only(bottom: 50),child:CircularProgressIndicator(),alignment: Alignment.bottomCenter)//MediaQuery.of(context).size.width,)
        ],)
    );
  }
}
