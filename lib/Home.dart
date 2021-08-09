import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot1/changeWifi.dart';
import 'package:path_provider/path_provider.dart';

import 'pinAction.dart';
import 'roomName.dart';
import 'videos.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Color on = Colors.amber;
  Color off = Colors.blueGrey;
  var statue = []; // save data here
  int length = 10;
  bool _dataIsReady = false;
  void callSetState() {
    setState(() {
      _dataIsReady = false;
    }); // it can be called without parameters. It will redraw based on changes done in _SecondWidgetState
  }


  String id = "";
  static String dataINFile = "";
  List<String> nickNames = [];
  List<String> roomNames = [];
  List<String> dataListed = [];
  FirebaseDatabase database = new FirebaseDatabase();

  Widget build(BuildContext context) {
    if (_dataIsReady && id != "" && dataINFile != "")
    {
      print("statue is ");
      print(statue);
      return Scaffold(
          drawer: Container(
            width: MediaQuery.of(context).size.width * 2 / 3,
            child: Drawer(
              child: ListView(
                children: <Widget>[
                  Container(
                    color: Colors.purple,
                    child: Image.asset(
                      'images/splach2.jpeg',
                      fit: BoxFit.fill,
                    ),
                  ),
                  ListTile(
                    title: Text("change rooms name"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoomName()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    height: 10,
                    thickness: 3.5,
                  ),
                  ListTile(
                    title: Text("change pins Action"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePinAction()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    height: 10,
                    thickness: 3.5,
                  ),
                  ListTile(
                    title: Text("change Wifi setting"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangeWifi()),
                      );
                    },
                  ),
                  Divider(
                    color: Colors.black,
                    height: 10,
                    thickness: 3.5,
                  )
                ],
              ),
            ),
          ),
          backgroundColor: Colors.white,
          appBar: homeAppBar(),
          body: ListView.builder(
            padding: EdgeInsets.only(top: 30),
            itemCount: 5,
            itemBuilder: (BuildContext context, int i) {
              print("$i ${nickNames[i]}");

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[//0
                  nickNames[i] == "Lamp"
                      ?Lamp(i + 1, statue[i],roomNames[i])
                      :nickNames[i]=="other"?Switch(i+1, statue[i],roomNames[i]):VideoDemo(nickNames[i], i + 1, statue[i], id, callSetState, roomNames[i]),
                  //4   5
                  nickNames[i+5] == "Lamp"?Lamp(i + 6, statue[i+5],roomNames[i+5])
                      :nickNames[i+5]=="other"?Switch(i+6, statue[i+5],roomNames[i+5]):VideoDemo(
                      nickNames[i+5], i + 6, statue[i+5], id, callSetState, roomNames[i+5]),
                ],
              );
            },
          ));
    }
    else
    {
      read2().then((s) {
        dataINFile = s;

        //s=dataINFile;
        if (dataListed.length == 0) {
          for (int i = 0; i < 10; i++) {
            int g = s.indexOf('}', s.indexOf("NickName"));
            dataListed.add(s.substring(s.indexOf('{') + 1, g));
            nickNames.add(dataListed[i].substring(dataListed[i].indexOf("NickName") + "NickName:".length));
            roomNames.add(dataListed[i].substring(dataListed[i].indexOf("RoomName:") + "RoomName:".length, dataListed[i].indexOf("NickName")));
            s = s.substring(g + 1);
          }
        }
      });
      //print(id);
      readId().then((String s) {
        id = s;
        getDataFromFirebase();
      });
      return Scaffold(
          appBar: homeAppBar(),
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.purpleAccent,
            ),
          ));
    }
  }

  Widget Lamp(int number, bool statue,String roomname) {
    //print("${nickNames[number]+'on'}");
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width/2,
      height: 50.0,
      child: FlatButton(
        child: SizedBox(
          width: MediaQuery.of(context).size.width/3,
          child: Card(
              semanticContainer: true,
              elevation: 20,
              child:Column(children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width / 6),
                  child: !statue
                      ? Image.asset(
                    "images/Lampoff.jpg",
                    fit: BoxFit.fitWidth,
                  )
                      : Image.asset(
                    "images/Lampon.jpg",
                    fit: BoxFit.fitWidth,
                  ),
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                ),
                Text("${roomname}",style: TextStyle(fontSize: 20),)
              ],)
          ),),
        onPressed: () {
          print("on presed");
          FirebaseDatabase().reference().update(
              { 'pin'+number.toString():!statue,
                'changed':true
              }).then((onValue){
            print("data updated");
            setState(() {
              _dataIsReady=false;
            });
          }).catchError((onError){
            print("ON ERROR");
          });
          
//          Firestore.instance
//              .collection('modes')
//              .document('$id')
//              .updateData({"pin" + number.toString(): !statue}).then((result) {
//            setState(() {
//              _dataIsReady = false;
//            });
//          }).catchError((onError) {
//            print("onError");
//          });
        },
      ),
      //width: ,
    );

//                Container(
//                  width: MediaQuery.of(context).size.width / 5,
//                  margin: EdgeInsets.only(
//                      left: MediaQuery.of(context).size.width / 4),
//                  child: CustomSwitch(
//                    activeColor: Colors.purple,
//                    value: statue,
//
//
//                    onChanged: (value) {

//
//
//
//                      print("VALUE : $value");
//                      statue = value;
//                      Firestore.instance
//                          .collection('modes')
//                          .document('$id')
//                          .updateData({"pin" + number.toString(): statue}).then(
//                              (result) {
//                        setState(() {
//                          _dataIsReady = false;
//                        });
//                      }).catchError((onError) {
//                        print("onError");
//                      });
//                    },
//                  ),
//                ),
//              ],
//            )));
  }
  Widget Switch(int number, bool statue, String roomname) {
    //print("${nickNames[number]+'on'}");
    return ButtonTheme(
      minWidth: MediaQuery.of(context).size.width/2,
      height: 50.0,
      child: FlatButton(
        child: SizedBox(
          width: MediaQuery.of(context).size.width/3,
          child: Card(
              semanticContainer: true,
              elevation: 20,
              child:Column(children: <Widget>[
                Container(
                  width: (MediaQuery.of(context).size.width / 6),
                  child: !statue
                      ? Image.asset(
                    "images/power_off.png",
                    fit: BoxFit.fitWidth,
                  )
                      : Image.asset(
                    "images/power_on.png",
                    fit: BoxFit.fitWidth,
                  ),
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                ),
                Text("${roomname}",style: TextStyle(fontSize: 20),)
              ],)
          ),),
        onPressed: () {
          print("on presed");
          FirebaseDatabase().reference().update(
              { 'pin'+number.toString():!statue,
                'changed':true
              }).then((onValue){
            print("data updated");
            setState(() {
              _dataIsReady=false;
            });
          }).catchError((onError){
            print("ON ERROR");
          });

//          Firestore.instance
//              .collection('modes')
//              .document('$id')
//              .updateData({"pin" + number.toString(): !statue}).then((result) {
//            setState(() {
//              _dataIsReady = false;
//            });
//          }).catchError((onError) {
//            print("onError");
//          });
        },
      ),
      //width: ,
    );

//                Container(
//                  width: MediaQuery.of(context).size.width / 5,
//                  margin: EdgeInsets.only(
//                      left: MediaQuery.of(context).size.width / 4),
//                  child: CustomSwitch(
//                    activeColor: Colors.purple,
//                    value: statue,
//
//
//                    onChanged: (value) {

//
//
//
//                      print("VALUE : $value");
//                      statue = value;
//                      Firestore.instance
//                          .collection('modes')
//                          .document('$id')
//                          .updateData({"pin" + number.toString(): statue}).then(
//                              (result) {
//                        setState(() {
//                          _dataIsReady = false;
//                        });
//                      }).catchError((onError) {
//                        print("onError");
//                      });
//                    },
//                  ),
//                ),
//              ],
//            )));
  }

  Widget homeAppBar() {
    return AppBar(
      title: Text("MyHome"),
      centerTitle: true,
      backgroundColor: Colors.purple,
      elevation: 25,
      //leading: Icon(Icons.home,color: Colors.white,),
    );
  }

//sleep here
  Future<void> getDataFromFirebase() {
    print("database reference");
    database.reference().once().then((DataSnapshot data){
      print("data is${data.value}");
      if (statue.length == 0) {
        for (int i = 0; i < length; i++) {
          statue.add(data.value['pin' + (i + 1).toString()]);
        }
      } else if (statue.length != 0 && statue.length <= length) {
        for (int i = 0; i < length; i++) {
          statue[i] = data.value['pin' + (i + 1).toString()];
        }
      }
      print(statue);
      if (statue[0] == true || statue[0] == false) {
        setState(() {
          _dataIsReady = true;
        });
      } else {
        setState(() {
          _dataIsReady = false;
        });
      }
    });
    //print(database.reference().path);

//    Firestore.instance
//        .collection('modes')
//        .document('$id')
//        .get()
//        .then((DocumentSnapshot ds) {
//      if (statue.length == 0) {
//        for (int i = 0; i < length; i++) {
//          statue.add(ds.data['pin' + (i + 1).toString()]);
//        }
//      } else if (statue.length != 0 && statue.length <= length) {
//        for (int i = 0; i < length; i++) {
//          statue[i] = ds.data['pin' + (i + 1).toString()];
//        }
//      }
//      print(statue);
//      if (statue[0] == true || statue[0] == false) {
//        setState(() {
//          _dataIsReady = true;
//        });
//      } else {
//        setState(() {
//          _dataIsReady = false;
//        });
//      }
//    });
  }

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
      return '0';
    }
  }

  Future<String> get _localPath2 async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> read2() async {
    try {
      final file = await _localFile2;
      // Read the file.
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return '0';
    }
  }

  Future<File> get _localFile2 async {
    final path = await _localPath2;
    print(path);
    return File('$path/data2.txt');
  }

  Future<void> get_data_from_server() async {
    //connect to server
    String ip = "192.168.1.6:5000";
    var url = Uri.http(ip, '/');
    String parameter = "?id=$id";
    http.Response response = await http.get(url.toString() + parameter);

    String data = response.body;

    int last_indux = 0;
    if (statue.length == 0) {
      for (int i = 0; i < length; i++) {
        last_indux = data.indexOf('=', last_indux) + 1;
        statue.add(data[last_indux]);
      }
    } else if (statue.length != 0 && statue.length <= length) {
      for (int i = 0; i < length; i++) {
        last_indux = data.indexOf('=', last_indux) + 1;
        statue[i] = data[last_indux];
      }
//      print("data is \n");
//      print(data);
//      print("________________________________________________________________");
//      print(statue);
//      print("________________________________________________________________");
    }
  }

  Widget pinServer(int number, bool statue) {
    return Column(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          color: !statue ? off : on,
          margin: EdgeInsets.only(bottom: 20, top: 20),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.purpleAccent,
          child: FloatingActionButton(
            backgroundColor: Colors.purpleAccent,
            elevation: 15,
            onPressed: () async {
              //update statue and send data to server
              if (!statue) {
                statue = true;
              } else if (statue) {
                statue = false;
              }

//**************************send to server******************************
              var ip = "192.168.1.6:5000";
              String path = "/send_pin";
              String parameter = "?id=" +
                  1.toString() +
                  "&state=" +
                  statue.toString() +
                  "&number=" +
                  number.toString();
              var url = Uri.http(ip, path);
              http.Response res = await http.get(url.toString() + parameter);

              print("debug mode in line 86 " + res.body);
//*************************************************************************
              if (res.body == "00") {
                setState(() {
                  _dataIsReady = false;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

