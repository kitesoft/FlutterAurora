import 'dart:async';

import 'package:flutter_aurora/http/aurora_httpclient.dart';


const String UUID = '97cb741ce0b4442aaca94749a506b380ca2fb30f';
const String VC = '220';
const String VD = '3.10';

class Api{
  static var client = new AuroraHttpClient();
  static Future getHomeVideoListInfo(int date,int num) {
    var path = "v5/index/tab/feed";
    return client.get(
      path,
      {
        'date': date,
        'num': num,
        'uuid': UUID,
        'vc': VC,
        'vn': VD,
      },
    );
  }
}