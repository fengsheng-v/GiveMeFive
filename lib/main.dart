import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:m_loading/m_loading.dart';
import 'dart:io';

import 'generated/l10n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GIVE ME FIVE",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title:"GIVE ME FIVE"),
      builder: EasyLoading.init(),
      localizationsDelegates: [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: [
        const Locale('en', 'US'), // 美国英语
        const Locale('zh', 'CN'), // 中文简体
        ...S.delegate.supportedLocales
        //其它Locales
      ]
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver,SingleTickerProviderStateMixin {
  String _websocketUrl = 'wss://h1ghf1ve.me/hi5';
  String _originUrl = 'https://h1ghf1ve.me/';
  bool isShow = false;
  static const double origin_top = 500;
  static const double target_top = 40;
  bool _isAnimation = false;
  bool _haveFind = false;
  String _curStr = '';
  static const Color _originColor = Colors.deepPurple;
  static const Color _changedColor = Colors.red;
  Color _curColor = _originColor;
  Animation<double> _animation;
  AnimationController _controller;
  double _animationValue = origin_top;
  String localFilePath = "assets/audios/clap.mp3";
  String handImageUrl = "assets/images/hand.png";
  AudioPlayer audioPlayer;
  AudioCache audioCache;
  WebSocket webSocket;
  Timer c_timer;

  void _reset() {
    _changeText(0);
    _changeColor(_originColor);
    _resetHandPosition();
    _changeLoadingState(false);
    _isAnimation = false;
    if(c_timer!=null){
      c_timer.cancel();
      c_timer = null;
    }
  }

  void _changeText(status, {String location}) {
    setState(() {
      if (status == 0) {
        _curStr = S.current.prepare_press_hand;
      } else if (status == 1) {
        _curStr = S.current.waiting_for_back;
      } else {
        _curStr = S.current.have_find(location);
      }
    });
  }

  void _changeColor(Color value) {
    setState(() {
      _curColor = value;
    });
  }

  void _resetHandPosition() {
    setState(() {
      _animationValue = origin_top;
    });
  }

  void _changeLoadingState(bool show) {
    setState(() {
      isShow = show;
    });
  }

  play() {
    audioCache.play(localFilePath, isNotification: true);
    _changeColor(_changedColor);
    print('play success');
  }

  void stop() {
    audioPlayer.stop();
    _changeColor(_originColor);
    print('play stop');
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
    // audioPlayer.mode = PlayerMode.LOW_LATENCY;
    audioPlayer.onPlayerCompletion.listen((event) {
      print("onPlayerCompletion");
    });
    audioCache = new AudioCache(prefix: "", fixedPlayer: audioPlayer,respectSilence:true);
    audioCache.load(localFilePath);
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
            setState(() {});
          });
    // #enddocregion addListener
    initAudioPlayer();
    _changeText(0);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("$state -------");
    if (state == AppLifecycleState.paused) {
      // do sth
      if (webSocket != null) webSocket.close();
      _reset();
    }
  }

  @override
  void deactivate(){
    print("-------");
    super.deactivate();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.dispose();
    super.dispose();
  }

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void _sendMessage() {
    _changeText(1);
    // 设置超时时间
    bool haveDone = false;
    c_timer =Timer.periodic(Duration(seconds: 30), (timer) {
      ///定时任务
      timer.cancel();
      timer = null;
      if (!haveDone){
        if (webSocket != null) webSocket.close();
        _reset();
        EasyLoading.showToast(S.current.over_time,duration: Duration(milliseconds: 800));
      }
    });
    WebSocket.connect(_websocketUrl).then((WebSocket ws) {
      webSocket = ws;
      // 调用add方法发送消息
      // 监听接收消息，调用listen方法
      webSocket.listen((data) {
        // print('onData');
      }, onDone: () {
        print('onDone:' + webSocket.closeReason);
        if (webSocket.closeReason.indexOf("hi5") != -1) {
          haveDone = true;
          c_timer.cancel();
          c_timer = null;
          _changeText(2, location: webSocket.closeReason.split("::")[1]);
          haveFind();
        }
      }, onError: (error) {
        print('onError');
      }, cancelOnError: true);
      var str = "hi5:" + getRandomString(6);
      print('发送消息:' + str);
      webSocket.add(str);
    });
  }

  void haveFind() {
    _haveFind = true;
    _changeLoadingState(false);
    _controller.reset();
    _controller.forward();
    print("find");
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      ///定时任务
      timer.cancel();
      timer = null;
      play();
    });

    Timer.periodic(Duration(milliseconds: 3000), (timer) {
      ///定时任务
      timer.cancel();
      timer = null;
      _isAnimation = false;
      _haveFind = false;
      _resetHandPosition();
      stop();
      print("end");
      _changeText(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Theme(
        data: ThemeData(primarySwatch: _curColor),
        child: Scaffold(
          endDrawer: Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.whatshot),
                  title: new Text("来源"),
                  subtitle: new Text(_originUrl),
                )
              ],
            ),
          ),
          appBar: AppBar(
            title: Text(widget.title),
          ),
          backgroundColor: _curColor,
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
                        child: Image(image: AssetImage(handImageUrl)),
                      ),
                    ),
                    Positioned(
                      right: width / 2 - 180,
                      top: _haveFind ? _animation.value : _animationValue,
                      height: 300,
                      width: 300,
                      child: AnimatedContainer(
                        // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        // color: Colors.amber,
                        curve: Curves.linear,
                        duration: Duration(milliseconds: 500),
                        child: Image(image: AssetImage(handImageUrl)),
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
                            _changeLoadingState(true);
                            print("search");
                            _sendMessage();
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
                  child: Text(
                    _curStr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
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
        ));
  }
}
