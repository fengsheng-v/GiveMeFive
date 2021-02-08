import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:m_loading/m_loading.dart';
import 'package:audioplayers/audioplayers.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GIVE ME FIVE',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'GIVE ME FIVE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool isShow = false;
  static const double origin_top = 500;
  static const double target_top = 40;
  bool _isAnimation = false;
  bool _haveFind = false;
  String _str = 'Waiting for someone to high-five you back.';
  String _haveFindStr = 'you have got one.';

  Animation<double> _animation;
  AnimationController _controller;
  AnimationStatus _animationState;
  double _animationValue = origin_top;

  AudioPlayer audioPlayer;
  AudioCache audioCache;
  void _resetState() {
    setState(() {
      _animationValue = origin_top;
    });
  }

  void _changeLoadingState() {
    setState(() {
      isShow = !isShow;
    });
  }

  play() async {
    audioPlayer = await audioCache.play("audio/clap.mp3");
    // audioPlayer.setReleaseMode(ReleaseMode.STOP);
    // await audioPlayer.play(
    //   "assets/audio/clap.mp3",isLocal: true
    // );
    // if (result == 1) {
    //   // success
    //   print('play success');
    // } else {
    //   print('play failed');
    // }
    print('play success');
  }

  stop() async {
    int result = await audioPlayer.release();
    if (result == 1) {
      print('stop release');
    } else {
      print('stop release');
    }
  }

  @override
  void deactivate() async{
    print('结束');
    // int result = await audioPlayer.release();
    // if (result == 1) {
    //   print('release success');
    // } else {
    //   print('release failed');
    // }
    super.deactivate();
  }

  void initAudioPlayer() async{
    // audioPlayer = new AudioPlayer();
    // await audioPlayer.setUrl('assets/audio/clap.mp3',isLocal: true);
    audioCache = new AudioCache();
  }

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    // #docregion addListener
    _animation =
        Tween<double>(begin: origin_top, end: target_top).animate(_controller)
          ..addListener(() {
            // #enddocregion addListener
            setState(() {
              _animationValue = _animation.value;
            });
            // #docregion addListener
          })
          ..addStatusListener((AnimationStatus state) {
            setState(() {
              _animationState = state;
            });
          });
    // #enddocregion addListener
    initAudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
              children: <Widget>[
                Container(
                  height: 300,
                  width: 800,
                  margin: EdgeInsets.all(20.0),
                ),
                Positioned(
                  top: target_top - 20,
                  height: 300,
                  width: 300,
                  child: Container(
                    // margin: EdgeInsets.all(20.0),
                    child: Image(image: AssetImage("images/hand.png")),
                  ),
                ),
                Positioned(
                  right: 60,
                  top: _haveFind ? _animation.value : _animationValue,
                  height: 300,
                  width: 300,
                  child: AnimatedContainer(
                    // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    // color: Colors.amber,
                    curve: Curves.linear,
                    duration: Duration(milliseconds: 500),
                    child: Image(image: AssetImage("images/hand.png")),
                  ),
                ),
                Positioned(
                  top: target_top - 20,
                  height: 300,
                  width: 250,
                  child: Container(
                    margin: EdgeInsets.all(0.0),
                    child: FlatButton(
                      // child: Image(image: AssetImage("images/hand.png")),
                      // textColor: Colors.blue,
                      color: Colors.transparent,
                      disabledColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        if (_isAnimation) return;
                        _isAnimation = true;
                        _changeLoadingState();
                        print("search");
                        Timer.periodic(Duration(milliseconds: 1000), (timer) {
                          _haveFind = true;
                          ///定时任务
                          timer.cancel();
                          timer = null;
                          _changeLoadingState();
                          _controller.reset();
                          _controller.forward();
                          print("find");
                          play();
                          Timer.periodic(Duration(milliseconds: 1000), (timer) {
                            ///定时任务
                            timer.cancel();
                            timer = null;
                            _isAnimation = false;
                            _haveFind = false;
                            _resetState();
                            stop();
                            print("end");
                          });
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 100,
              alignment: Alignment.center,
              color: Colors.transparent,
              margin: EdgeInsets.all(20.0),
              child: Text(
                _haveFind ? _haveFindStr : _str,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  height: 1.2,
                ),
              ),
            ),
            if (isShow)
              Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(20.0),
                  child: Water2CircleLoading(
                    color: Colors.white,
                  )),
          ],
        ),
      ),
    );
  }
}
