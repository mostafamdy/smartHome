import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDemo extends StatefulWidget {
  String _videoName;
  int _number;
  bool _statue;
  String _id;
  String _roomName;
  final Function onClick;

  VideoDemo(this._videoName, this._number, this._statue, this._id, this.onClick,
      this._roomName);

  String get videoName => _videoName;

  set videoName(String value) {
    _videoName = value;
  }
  //VideoDemo() : super();

  @override
  VideoDemoState createState() =>
      VideoDemoState(_videoName, _number, _statue, _id, onClick, _roomName);
}

class VideoDemoState extends State<VideoDemo> {
  String _videoName;
  int _number;
  bool _statue;
  String _id;
  String _roomName;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  final Function onClick;

  VideoDemoState(this._videoName, this._number, this._statue, this._id,
      this.onClick, this._roomName);
  @override
  void initState() {
    String VP='images/${_videoName}.mp4';
    _controller = VideoPlayerController.asset(VP,videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    print("in dispose");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      ButtonTheme(
          minWidth: MediaQuery.of(context).size.width/2,
          height: 50.0,
          child: FlatButton(
            child: SizedBox(
              width: MediaQuery.of(context).size.width/3,
              child:Card(
                semanticContainer: true,
                elevation: 20,
                child:
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      child: FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if(_statue){
                              print("$_number play");
                              _controller.play();
                            }
                            else{
                              _controller.pause();
                            }
//                            _controller.value;
//                          print(_controller.value);
                            return _controller.value.initialized
                                ? Container(
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ))
                                : Container(
                              color: Colors.black12,
                              height: 30,
                              width: 30,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      width: 100,
                      //MediaQuery.of(context).size.width / 3,
                      height: 100,
                    ),
                    Text(
                      "$_roomName",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
//              Padding(
//                padding: EdgeInsets.only(
//                    right: MediaQuery.of(context).size.width / 6),
//              )
//            ],
//          )
              ),),
            onPressed: () {
//              setState(() {
//                _controller.value.isPlaying
//                    ? _controller.pause()
//                    : _controller.play();
//              });

              print("on presed");
              FirebaseDatabase().reference().update(
              { 'pin'+_number.toString():!_statue,
                'changed':true
              }
                //!_statue
              ).then((onValue){
                sleep(Duration(milliseconds: 0));
                widget.onClick();
                print("data updated");
              }).catchError((onError){
                print("ON ERROR");
              });
//              Firestore.instance
//                  .collection('modes')
//                  .document('$_id')
//                  .updateData({"pin" + _number.toString(): !_statue}).then(
//                      (result) {
//                    sleep(Duration(milliseconds: 500));
//                    widget.onClick();
//                  }).catchError((onError) {
//                print("onError");
//              });
            },
//          child: _controller.value.isPlaying?Card(
//
//          )
//                  ? Image.asset(
//                'images\\power_on.png',
//                width: 100,
//                height: 100,
//              )
//              //color: Colors.deepPurple,)
//                  : Image.asset(
//                'images\\power_off.png',
//              ),
//),
          ));
  }
}
