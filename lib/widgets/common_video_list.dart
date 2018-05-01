import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aurora/bean/video.dart';

class CommonVideoList extends StatefulWidget {
  final List<Video> videos;

  CommonVideoList({Key key, @required this.videos}) : super(key: key);

  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework will re-use the State object
  // instead of creating a new State object.

  @override
  _VideoListState createState() => new _VideoListState();
}

class CommonVideoListItem extends StatelessWidget {
  static const double height = 300.0;
  final Video video;
  CommonVideoListItem({Key key, @required this.video}) : super(key: key);

  String _getVideoDetailInfo(Video video){
    int duration = video.duration==null?video.content.data.duration:video.duration;
    int hours = (duration ~/ 3600) ;
    int minutes = (duration % 3600 ~/ 60) ;
    int seconds = duration - hours *3600 - minutes *60;
    String hour = hours == 0 ? "00": hours>9? hours:"0"+hours.toString();  
    String minute = minutes == 0 ? "00": minutes>9? minutes:"0"+minutes.toString();  
    String second = seconds == 0 ? "00": seconds>9? seconds.toString():"0"+seconds.toString();
    String timeStr = (hour +":" +minute +":" + second);
    String str = '#${video.category == null
        ? video.content.data.category
        : video.category } / ' + timeStr;
    return str;
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    // TODO: implement build
    return new Container(
      padding: const EdgeInsets.all(8.0),
      height: height,
      child: new Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              height: 185.0,
              child: new Stack(
                children: <Widget>[
                  new Positioned.fill(
                    child: new Image(
                      image: new CachedNetworkImageProvider(video.cover == null
                          ? video.content.data.cover.feed
                          : video.cover.feed),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                child: new Row(
                  children: <Widget>[
                    new CircleAvatar(
                      radius: 22.0,
                      backgroundImage: new CachedNetworkImageProvider(
                          video.author == null
                              ? video.content.data.author.icon
                              : video.author.icon),
                    ),
                    new DefaultTextStyle(
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: descriptionStyle,
                      child: new Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              video.title == null
                                  ? video.content.data.title
                                  : video.title,
                              style: descriptionStyle.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                            new Text(
                              _getVideoDetailInfo(video),
                              style: descriptionStyle.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoListState extends State<CommonVideoList> {
  List<Video> _videos = new List<Video>();

  @override
  Widget build(BuildContext context) {
    return new ListView(
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      children: widget.videos.map((Video video) {
        return new CommonVideoListItem(
          video: video,
//          onCartChanged: _handleCartChanged,
        );
      }).toList(),
    );
  }

  void _handleDataChanged(List<Video> videos, bool isRefresh) {
    setState(() {
      if (isRefresh) {
        _videos.clear();
      }
      _videos.addAll(videos);
    });
  }
}
