
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';


const String BASE_URL = "http://baobab.kaiyanapp.com/api/";



class AuroraHttpClient{

  static final Options options= new Options(
      baseUrl: BASE_URL,
      connectTimeout:8000,
      receiveTimeout:5000
  );
  static final Dio dio = new Dio(options);
  AuroraHttpClient();

  Future get(String path,data) {
    return dio.get(path,data: data,options: new Options(method:"GET"));
  }

  Future post(String path,data) {
    return dio.post(path,data: data,options: new Options(method:"POST"));
  }

}