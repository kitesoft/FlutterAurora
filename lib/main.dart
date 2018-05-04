import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aurora/bean/video.dart';
import 'package:flutter_aurora/http/aurora_httpclient.dart';
import 'package:flutter_aurora/widgets/bottom_navigation.dart';
import 'package:flutter_aurora/widgets/common_video_list.dart';
import 'package:flutter_aurora/widgets/multi_state_layout.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

const List<Choice> choices = const <Choice>[
  const Choice(
    title: '设置',
  ),
];

class Choice {
  final String title;

  const Choice({this.title});
}

class MainContainerPage extends StatefulWidget {
  final String title;

  final List<Video> videos = new List();
  ResultState resultState = ResultState.loading;
  MainContainerPage({Key key, this.title}) : super(key: key);

  @override
  _MainContainerPageState createState() => new _MainContainerPageState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FlutterAurora',
      theme: new ThemeData(
        primaryColor: new Color(0xffffc107),
        primaryColorDark: new Color(0xffffa000),
        accentColor: new Color(0xffffc107),
      ),
      home: new MainContainerPage(title: '首页'),
    );
  }
}

class _MainContainerPageState extends State<MainContainerPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        brightness: Brightness.dark,
        iconTheme: new IconThemeData(color: Colors.white),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {},
          ),
          new PopupMenuButton<Choice>(
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return new PopupMenuItem<Choice>(
                  value: choice,
                  child: new Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('User Name'),
              accountEmail: new Text('email@example.com'),
              currentAccountPicture: new CircleAvatar(
                  backgroundImage: new CachedNetworkImageProvider(
                      "https://avatars2.githubusercontent.com/u/18547710?s=460&v=4")),
              onDetailsPressed: () {},
            ),
            new ListTile(
              leading: new Icon(Icons.home),
              title: new Text('首页'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.remove_red_eye),
              title: new Text('关注'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.video_library),
              title: new Text('缓存'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.history),
              title: new Text('观看记录'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text('设置'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: new Stack(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        alignment: new Alignment(1.0, 1.0),
        children: <Widget>[
          new MultiStateView(
            content: new Center(
                child: new RefreshIndicator(
                    key: _refreshIndicatorKey,
                    child: new CommonVideoList(videos: widget.videos),
                    onRefresh: _getVideoListInfo)),
            resultState: widget.resultState,
            retry: _getVideoListInfo,
          ),
          new MyBottomNavigation(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.resultState = ResultState.loading;
    _getVideoListInfo();
  }

  Future<Null> _getVideoListInfo() {
    setState(() {
      widget.resultState = ResultState.loading;
    });
    var client = new AuroraHttpClient();
    var url = "v5/index/tab/feed";
    return client.getWithParams(
      url,
      params: {
        'num': '0',
        'page': '1',
        'uuid': '97cb741ce0b4442aaca94749a506b380ca2fb30f',
        'vc': '220',
        'vn': '3.10',
      },
    ).then((response) {
      Map videoMap = json.decode(response.body);
      VideoListInfo info = new VideoListInfo.fromJson(videoMap);
      List<VideoData> videoDatas = info.itemList
          .where(
              (VideoData videoDate) => VIDEO_ITEM_TYPE_FOLLOW == videoDate.type)
          .toList();
      List<Video> videos =
          videoDatas.map((VideoData videoDate) => videoDate.data).toList();
      setState(() {
        widget.videos.clear();
        widget.videos.addAll(videos);
        widget.resultState = ResultState.success;
      });
    },onError: (e){
      setState(() {
        widget.videos.clear();
        widget.resultState = ResultState.error;
      });
    });
  }
}
