import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RoomName extends StatefulWidget {
  @override
  _RoomNameState createState() => _RoomNameState();
}

class _RoomNameState extends State<RoomName> {
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

  Future<File> writeRoomName(
      int length, List RoomName, FileMode fileMode) async {
    final file = await _localFile;
    return file.writeAsString('len=$length$RoomName', mode: fileMode);
  }

  int RoomCount = 0;
  var _roomName = [];
  String _pinNumber;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Hello"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: RoomCount == 0
          ? ListView(children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            "Enter Rooms count",
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
            onChanged: (value) {
              RoomCount = int.parse(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
          padding: EdgeInsets.only(
              top: 25,
              right: MediaQuery.of(context).size.width / 3,
              left: MediaQuery.of(context).size.width / 3),
        )
      ])
          : ListView.builder(
        itemCount: RoomCount + 2,
        itemBuilder: (BuildContext context, int RoomNum) {
          if (RoomNum == 0) {
            return Container(
              padding: EdgeInsets.only(top: 30),
              child: Text("Enter Name",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black26)),
            );
          } else if (RoomNum == RoomCount + 1) {
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
                  print(_roomName);
                  int i = 1;
                  writeRoomName(
                      _roomName.length, _roomName, FileMode.write)
                      .whenComplete(() {
                    read().then((s) {
                      print("data in file = $s");
                    });
                  });
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => PinsInRooms()),
//                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => test(_roomName)));
                },
                backgroundColor: Colors.white,
                splashColor: Colors.black54,
              ),
            );
          } else {
            print("Counter $RoomNum");
            if (_roomName.length < RoomCount) _roomName.add("$RoomNum");
            return Container(
              padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 1 / 6,
                  top: 30,
                  left: MediaQuery.of(context).size.width * 1 / 6),
              child: TextField(
                cursorColor: Colors.purple,
                cursorWidth: 3,
                onChanged: (value) {
                  print("Room Num is $RoomNum Room Name = $_roomName");
                  _roomName[RoomNum - 1] = value;
                  print(value);
                },
                decoration: InputDecoration(
                  hintText: "Name:",
                  labelText: "Room${RoomNum}",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22.0),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class test extends StatefulWidget {
  List rooms = [];

  test(this.rooms);

  @override
  _testState createState() => _testState(rooms);
}

class _testState extends State<test> {
  List rooms = [];
  List pressed = [];
  List AvailblePins = [];
  List<pin> pins = [];
  int test1 = 0;
  int test2 = 0;

  Map<String, List<int>> chosedPins = {};
  _testState(this.rooms);

  @override
  Widget build(BuildContext context) {
    if (pressed.length == 0) {
      for (int i = 0; i < rooms.length; i++) {
        pressed.add(false);
        chosedPins[rooms[i]] = [];
      }
      for (int i = 0; i < 10; i++) {
        pins.add(pin());
        pins[i].number = i + 1;
        AvailblePins.add(i + 1);
      }
    }

    print("pins list is ${AvailblePins}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Room's pin"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50),
        child: ListView.builder(
            itemCount: rooms.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  //DropdownButton(icon: Icon(Icons.home),value: "000",),
                  RaisedButton(
                    animationDuration: Duration(milliseconds: 10),
                    splashColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.white),
                    ),
                    //clipBehavior: Clip.hardEdge,
                    color: Colors.purple,
                    elevation: 10,
                    child: Text(
                      "${rooms[index]}",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        pressed[index]
                            ? pressed[index] = false
                            : pressed[index] = true;
                      });
                    },
                  ),
                  pressed[index]
                      ? Row(
                    children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: AvailblePins.length,
                              itemBuilder: (BuildContext context, int i) {
                                return Row(
                                  children: <Widget>[
                                    Text('pin${AvailblePins[i]}'),
                                    Radio(
                                      groupValue: "1",
                                      activeColor: Colors.deepPurple,
                                      value: "0",
                                      onChanged: (v) {
                                        //List<int>l= chosedPins[rooms[index]];
                                        //l.add(AvailblePins[i]);
                                        //chosedPins.update(rooms[index],(n)=>l);
                                        chosedPins[rooms[index]]
                                            .add(AvailblePins[i]);
                                        pins[AvailblePins[i] - 1]
                                            .roomName = rooms[index];
                                        AvailblePins.removeAt(i);
                                        for (int k = 0; k < 10; k++) {
                                          print("pins[$k]");
                                          //print("Name : ${pins[k]._pinNickName}");
                                          print(
                                              "Room name : ${pins[k]._roomName}");
                                          print(
                                              "Number : ${pins[k]._number}");
                                        }
                                        print(chosedPins);
                                        setState(() {});
                                      },
                                    )
                                  ],
                                );
                              })),
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: chosedPins[rooms[index]].length,
                              itemBuilder: (BuildContext context, int i) {
                                print("Iam here");
                                return Row(
                                  children: <Widget>[
                                    Radio(
                                      groupValue: test1,
                                      hoverColor: Colors.purple,
                                      focusColor: Colors.purple,
                                      activeColor: Colors.purple,
                                      value: test2,
                                      onChanged: (v) {
                                        AvailblePins.add(
                                            chosedPins[rooms[index]][i]);
                                        chosedPins[rooms[index]]
                                            .removeAt(i);
                                        setState(() {});
                                      },
                                    ),
                                    Text(
                                        'pin${chosedPins[rooms[index]][i]}'),
                                  ],
                                );
                              })
                      ),
                      //VerticalDivider(),
                    ],
                  )
                      : Container(
                    height: 50,
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          clearFile().whenComplete((){
            writeFile(pins).whenComplete((){
              read2().then((s){
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                print(s);
              });
            });
          });
        },
        //writeFile(pins[0], FileMode.write).whenComplete((){

        child: Icon(Icons.arrow_forward_ios),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            side: BorderSide(color: Colors.white)),
      ),
    );
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

  Future<void>writeFile(List<pin>data) async {
    final file = await _localFile2;
    for(int i=0;i<10;i++){
      await file.writeAsStringSync("{Number:${data[i]._number}",mode: FileMode.append);
      await file.writeAsStringSync("RoomName:${data[i]._roomName}",mode: FileMode.append);
      await file.writeAsStringSync("NickName:${data[i]._pinNickName}}",mode: FileMode.append);
    }
    await file.writeAsStringSync("]",mode: FileMode.append);
    //return file.writeAsString('$data', mode: fileMode);
  }
  Future<void>clearFile()async{
    final file = await _localFile2;
    return file.writeAsString('[',mode: FileMode.write);
  }
}

class pin {
  int _number;
  String _roomName;
  String _pinNickName;

  int get number => _number;

  String get roomName => _roomName;

  String get pinNickName => _pinNickName;

  set pinNickName(String value) {
    _pinNickName = value;
  }

  set roomName(String value) {
    _roomName = value;
  }

  set number(int value) {
    _number = value;
  }
}
