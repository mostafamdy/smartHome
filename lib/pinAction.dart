import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot1/Home.dart';
import 'package:path_provider/path_provider.dart';

class ChangePinAction extends StatefulWidget {
  @override
  _ChangePinActionState createState() => _ChangePinActionState();
}

class _ChangePinActionState extends State<ChangePinAction> {
  String data;

  List<String> subdata = [];

  List<String> selectedUser = [];

  List<Item> users = <Item>[
    Item(
        'TV',
        Icon(
          Icons.tv,
          color: Color(0xFF167F67),
        )),
    Item(
        "Lamp",
        Icon(
          Icons.lightbulb_outline,
          color: const Color(0xFF167F67),
        )),
    Item(
        'Air Condition',
        Icon(
          Icons.format_indent_decrease,
          color: const Color(0xFF167F67),
        )),
    Item(
        'fan',
        Icon(
          Icons.trip_origin,
          color: const Color(0xFF167F67),
        )),
    Item(
        'other',
        Icon(
          Icons.mobile_screen_share,
          color: const Color(0xFF167F67),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    if (selectedUser.length == 0) {
      print("in if $selectedUser");
      for (int i = 0; i < 10; i++) {
        selectedUser.add("select item");
      }
    }
    print("$selectedUser");
    return Scaffold(

        appBar: AppBar(
          title: Text("Hello"),
          centerTitle: true,
          backgroundColor: Colors.purple,
          elevation: 25,
        ),

        body: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 10,
                  ),
                  //EdgeInsets.only(top: 30),),
                  Text("Pin${index + 1}"),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                  ),
                  DropdownButton<Item>(
                    hint: Text("${selectedUser[index]}"),
                    onChanged: (Item Value) {
                      setState(() {
                        selectedUser[index] = Value.name;
                      });
                    },
                    items: users.map((Item user) {
                      return DropdownMenuItem<Item>(
                        value: user,
                        child: Row(
                          children: <Widget>[
                            user.icon,
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              user.name,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }),

        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purple,
            elevation: 10,
            child: Icon(Icons.arrow_forward_ios),
            shape: CircleBorder(
                side: BorderSide(color: Colors.white, width: 3)),
            onPressed: () {
              read2().then((s) {
                print("data in file $s");
                int j = 0;
                List<String> test = [];
                while (j < 10) {
                  int g = s.indexOf('}', s.indexOf("NickName"));
                  test.add(s.substring(s.indexOf('{') + 1, g));
                  test[j] = test[j].replaceRange(
                      test[j].indexOf("NickName"), test[j].length,
                      "NickName:${selectedUser[j]}");
                  // print("test[j]" + test[j]);
                  s = s.substring(g + 1);

                  //print("s = \n$s\n");
                  j++;
                }
                //print("test after loop \n $test");
                subdata = test;
                print("subdata =$subdata");
              })
                  .whenComplete(() {
                print("sebdata before clear file \n $subdata");
                clearFile().whenComplete(() {
                  writeFile(subdata);
                }).whenComplete(() {
                  read2().then((s) {
                    print("saved result is \n $s");
                    HomeState.dataINFile="";
                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                  });
                });
              });
            }));
  }

  Future<String> get _localPath2 async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> clearFile() async {
    final file = await _localFile2;
    return file.writeAsString('[', mode: FileMode.write);
  }

  Future<void> writeFile(List<String> data) async {
    final file = await _localFile2;
    for (int i = 0; i < 10; i++) {
      await file.writeAsStringSync("{"+data[i]+"}", mode: FileMode.append);
    }
    await file.writeAsStringSync("]", mode: FileMode.append);
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
}

class Item {
  Item(this._name, this._icon);
  String _name;
  Icon _icon;

  String get name => _name;
  set name(String value) {
    _name = value;
  }

  Icon get icon => _icon;
  set icon(Icon value) {
    _icon = value;
  }
}
