import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aurora/bean/video.dart';
import 'package:flutter_aurora/http/api/api.dart';
import 'package:flutter_aurora/http/aurora_httpclient.dart';
import 'package:flutter_aurora/res/colors.dart';
import 'package:flutter_aurora/res/strings.dart';
import 'package:flutter_aurora/widgets/bottom_navigation.dart';
import 'package:flutter_aurora/widgets/common_list_load_more.dart';
import 'package:flutter_aurora/widgets/common_video_list.dart';
import 'package:flutter_aurora/widgets/multi_state_layout.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

const List<Choice> choices = const <Choice>[
  const Choice(
    title: AuroraStrings.setting,
  ),
];

class Choice {
  final String title;

  const Choice({this.title});
}

class MainContainerPage extends StatefulWidget {
  final String title;

  final List<Video> videos = new List();
  ResultState refreshState = ResultState.loading;
  LoadMoreState loadMoreState = LoadMoreState.hide;
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
        primaryColor: AuroraColors.primaryColor,
        primaryColorDark: AuroraColors.primaryColor,
        accentColor: AuroraColors.primaryColor,
      ),
      home: new MainContainerPage(title: AuroraStrings.home),
    );
  }
}

class _MainContainerPageState extends State<MainContainerPage> {
  int date = 0;
  int num = 0;
  final TrackingScrollController _scrollController =
      new TrackingScrollController();
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
              title: new Text(AuroraStrings.home),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.remove_red_eye),
              title: new Text(AuroraStrings.attention),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.video_library),
              title: new Text(AuroraStrings.cache),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.history),
              title: new Text(AuroraStrings.history),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            new ListTile(
              leading: new Icon(Icons.settings),
              title: new Text(AuroraStrings.setting),
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
//          new MultiStateView(
//            content: new Center(
//              child: new NotificationListener(
//                onNotification: _onNotification,
//                child: new RefreshIndicator(
//                  key: _refreshIndicatorKey,
//                  child: new CommonVideoList(
//                    videos: widget.videos,
//                  ),
//                  onRefresh: _getVideoListInfo,
//                ),
//              ),
//            ),
//            resultState: widget.resultState,
//            retry: _retry,
//          ),
          new CommonVideoList(videos: widget.videos,resultState: widget.refreshState,onRefresh:_getVideoListInfo,retry: _retry,loadMoreState: widget.loadMoreState,onLoadMore: _LoadMoreVideoListInfo,),
        ],
      ),

      bottomNavigationBar: new MyBottomNavigation(),
    );
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      // 当没去到底部的时候，maxScrollExtent和offset会相等，可以准确的判断到达底部还有多少距离时开始加载数据了。。
      if (_scrollController.mostRecentlyUpdatedPosition.maxScrollExtent >
              _scrollController.offset &&
          _scrollController.mostRecentlyUpdatedPosition.maxScrollExtent -
                  _scrollController.offset <=
              50) {
        // 要加载更多
//        if (this.isMore && this.loadMoreStatus != LoadMoreStatus.loading) {
//          // 有下一页
//          print('load more');
//          this.loadMoreStatus = LoadMoreStatus.loading;
//          _loadMoreData();
//          setState(() {});
//
//        } else {}
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    widget.refreshState = ResultState.loading;
    _getVideoListInfo();
  }

  Future<Null> _retry() {
    setState(() {
      widget.refreshState = ResultState.loading;
    });
    return _getVideoListInfo();
  }

  Future<Null> _LoadMoreVideoListInfo(){
    setState(() {
      widget.loadMoreState = LoadMoreState.showLoading;
    });
    return Api.getHomeVideoListInfo(date, num).then((response) {
      VideoListInfo info = new VideoListInfo.fromJson(response.data);
      date = _getDateFromNextPageUrl(info.nextPageUrl);
      num = _getNumFromNextPageUrl(info.nextPageUrl);
      List<VideoData> videoDatas = info.itemList
          .where(
              (VideoData videoDate) => VIDEO_ITEM_TYPE_FOLLOW == videoDate.type)
          .toList();
      List<Video> videos =
      videoDatas.map((VideoData videoDate) => videoDate.data).toList();
      setState(() {
        widget.videos.addAll(videos);
        widget.loadMoreState = LoadMoreState.hide;
      });
    }, onError: (e) {
      setState(() {
        widget.loadMoreState = LoadMoreState.error;
      });
    });
  }

  Future<Null> _getVideoListInfo() {
    date = 0;
    num = 0;
    return Api.getHomeVideoListInfo(date, num).then((response) {
      VideoListInfo info = new VideoListInfo.fromJson(response.data);
      date = _getDateFromNextPageUrl(info.nextPageUrl);
      num = _getNumFromNextPageUrl(info.nextPageUrl);
      List<VideoData> videoDatas = info.itemList
          .where(
              (VideoData videoDate) => VIDEO_ITEM_TYPE_FOLLOW == videoDate.type)
          .toList();
      List<Video> videos =
          videoDatas.map((VideoData videoDate) => videoDate.data).toList();
      setState(() {
        widget.videos.clear();
        widget.videos.addAll(videos);
        widget.refreshState = ResultState.success;
      });
    }, onError: (e) {
      setState(() {
        widget.videos.clear();
        widget.refreshState = ResultState.error;
      });
    }
    );
  }

  int _getDateFromNextPageUrl(String nextPageUrl){
    String date = nextPageUrl?.substring(nextPageUrl.indexOf("date=") + 5, nextPageUrl.indexOf("&"));
    if(date.isNotEmpty){
      return int.parse(date);
    }else{
      return 0;
    }
  }
  int _getNumFromNextPageUrl(String nextPageUrl){
    String num = nextPageUrl?.substring(nextPageUrl.indexOf("num=") + 4, nextPageUrl.length);
    if(num.isNotEmpty){
      return int.parse(num);
    }else{
      return 0;
    }
  }

}
