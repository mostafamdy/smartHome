//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PinsInRooms extends StatefulWidget {
  @override
  _PinsInRoomsState createState() => _PinsInRoomsState();
}

class _PinsInRoomsState extends State<PinsInRooms> {
  var _rooms = [];
  var _pins=[0,0,0,0,0,0,0,0,0,0];
  bool _dataIsReady = false;
  int _len = 0;
  Map<String,String> Rooms_Pins = {};
  @override
  Widget build(BuildContext context) {
    int last_indux, last_indux2 = 0;
    int i = 0;
    if (_dataIsReady && _len != 0) {
      print("done");
      print("_len$_len");
//      Scaffold(
//        appBar: AppBar(),
//        body: ListView.builder(
//            itemCount: _len,
//            itemBuilder: (BuildContext context, int ind) {
//              return IconButton(
//                //padding: EdgeInsets.only(left: 30),
//                iconSize: 150,
//                icon:
//                Card(
//                  elevation: 10,
//                  color: Colors.purple,
//                  child: Container(
//                    alignment: Alignment.center,
//                    height: 100,
//                    child: Text(
//                      "${_rooms[ind]}",
//                      style: TextStyle(fontSize: 20, color: Colors.white),
//                    ),
//                  ),
//                  margin: EdgeInsets.only(
//                      left: MediaQuery.of(context).size.width / 3,
//                      right: MediaQuery.of(context).size.width / 3,
//                      bottom: 30,
//                      top: 30),
//                ),onPressed: (){
//
//                print("hi from ${_rooms[ind]}");
//              },)
//              ;
//
////                Column(
////                //mainAxisAlignment: MainAxisAlignment.spaceAround,
////                //crossAxisAlignment: CrossAxisAlignment.center,
////                children: <Widget>[
////                Center(child:Text('${_rooms[ind]}')),
////                  Container(
////                    width: 1,
////                    height: 50,
////                    color: Colors.grey,
////                  ),
////                  VerticalDivider(),
////                  Divider(),
////                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                  children: <Widget>[Container(
////                    margin: EdgeInsets.only(left: 30),
////                    width: 1,
////                    height: 50,
////                    color: Colors.grey,
////                  ),Container(
////                    margin: EdgeInsets.only(right: 30),
////                    width: 1,
////                    height: 50,
////                    color: Colors.grey,
////                  ),],)
//////                Container(child: IconButton(icon: Image.asset('images\\0_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\1_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 8),),
//////                  Container(child: IconButton(icon: Image.asset('images\\2_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\3_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\4_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\5_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\6_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\7_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\8_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
//////                  Container(child: IconButton(icon: Image.asset('images\\9_on.jpg'), onPressed: null,iconSize: 8,),margin: EdgeInsets.only(right: 30),),
////              ],);
//            }),
//      );
      return Scaffold(
        appBar: AppBar(
          title: Text("Hello"),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: ListView.builder(
          itemCount: _len + 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                padding: EdgeInsets.only(top: 30),
                child: Text("Enter pin Numbers seperted by - ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black26)),
              );
            } else if (index == _len + 1) {
              return Container(
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
                    for(int j=0;j<_len;j++){
                      String patient=Rooms_Pins[_rooms[j]];
                      int end=patient.length;
                      int last_in1;
                      int last_in2=0;
                      for(int q=0;q<end;q++){
                        last_in1=patient.indexOf('-',last_in2);
                        last_in1!=0?print(patient.substring(last_in2,last_in1+1)):print(patient.substring(last_in2));
                        last_in2=last_in1;
                      }
                    }
                    print(Rooms_Pins);
                  },
                  backgroundColor: Colors.white,
                  splashColor: Colors.black54,
                ),
              );
            } else {
              Rooms_Pins["${_rooms[index-1]}"]="";
              return Column(
                children: <Widget>[
                  Text(
                    "${_rooms[index - 1]}",
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 1 / 6,
                      top: 30,
                      left: MediaQuery.of(context).size.width * 1 / 6,
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.purple,
                      cursorWidth: 3,
                      onChanged: (value) {
                        Rooms_Pins['${_rooms[index-1]}']=value;
                      },
                      decoration: InputDecoration(
                        hintText: "1 - 2 - 3",
                        labelText: "pins",
                        helperText: index == 1
                            ? "if you wrote 1-2-3 that means pin1, pin2 and pin3 are in this room"
                            : "",
                        helperStyle:
                        TextStyle(fontSize: 15, color: Colors.blue),
                        helperMaxLines: 5,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      );
    } else {
      print(_dataIsReady);
      print(_len);
      read().then((s) {
        last_indux2 = s.indexOf('[') + 1;
        print(s);
        _len = int.parse(s.substring(s.indexOf('len=') + 4, last_indux2 - 1));
        while (i < _len && _rooms.length < _len) {
          last_indux = s.indexOf(':', last_indux2);
          _rooms.add(s.substring(last_indux2, last_indux - 1));
          last_indux2 = last_indux + 4;
          i++;
        }
        print(_rooms);
        print(_rooms[2]);
        setState(() {
          _dataIsReady = true;
        });
        //print(_dataIsReady);
      });
      return Scaffold(
        body: CircularProgressIndicator(),
      );
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> read() async {
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

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/data2.txt');
  }

  Future<File> writeRoomName(List RoomName, FileMode fileMode) async {
    final file = await _localFile;
    return file.writeAsString('$RoomName', mode: fileMode);
  }
}
