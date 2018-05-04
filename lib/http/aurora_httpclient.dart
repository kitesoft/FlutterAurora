
import 'dart:async';

import 'package:http/http.dart' as http;



const String BASE_URL = "http://baobab.kaiyanapp.com/api/";



class AuroraHttpClient extends http.BaseClient {

  static final http.Client _httpClient = http.Client();
  AuroraHttpClient();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _httpClient.send(request);
  }

  Future<http.Response> getWithParams(url, {Map<String, String> params}) {
    String realUrl = BASE_URL;
    if(params.length>0){
      realUrl = realUrl+url+"?";
      params.forEach((key,value){
        realUrl = realUrl + key + "=" +value + "&";
      });
    }
    // TODO: implement get
    return super.get(realUrl);
  }

}