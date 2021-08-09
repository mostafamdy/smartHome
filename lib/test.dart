import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  VideoPlayerController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'images/tst.mp4') ..initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
    _controller2 = VideoPlayerController.asset(
        'images/tst.mp4')
//    _controller=VideoPlayerController.network("https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return
      ListView(
        children: [
          Column(children: <Widget>[
            VideoWidget(controller: _controller),
            Container(
              height: 100,
              child: Center(child: Text("Login Form")),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ]),
          Column(children: <Widget>[
            VideoWidget(controller: _controller2),
            Container(
              height: 100,
              child: Center(child: Text("Login Form")),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _controller2.value.isPlaying
                      ? _controller2.pause()
                      : _controller2.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ]),
        ],
      )
    ;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}


class VideoWidget extends StatelessWidget {
  const VideoWidget({
    Key key,
    @required VideoPlayerController controller,
  })  : _controller = controller,
        super(key: key);

  final VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Container(),
    );
  }
}

class VD extends StatefulWidget {
  @override
  _VDState createState() => _VDState();
}

class _VDState extends State<VD> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            VideoDemot("tst", 1, false),
            VideoDemot("tst", 2, false),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.purple,
        ),
      ),
    );
  }
}


class VideoDemot extends StatefulWidget {
  String _videoName;
  int _number;
  bool _statue;

  VideoDemot(this._videoName, this._number, this._statue);

  String get videoName => _videoName;

  set videoName(String value) {
    _videoName = value;
  }

  @override
  VideoDemoState createState() =>
      VideoDemoState(_videoName, _number, _statue);
}

class VideoDemoState extends State<VideoDemot> {
  String _videoName;
  int _number;
  bool _statue;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;


  VideoDemoState(this._videoName, this._number, this._statue);
  @override
  void initState() {
    String V='images/${_videoName}.mp4';
    _controller = VideoPlayerController.asset(V,videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
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
                      "",
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
