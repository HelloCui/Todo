import 'package:dio/dio.dart';

Options options= new Options(
    baseUrl:"https://cuijiajie.com",
    connectTimeout:5000,
    receiveTimeout:3000
);
bool isDebug = false;
String proxy = 'localhost:8888';
final dio = Dio(options)
  ..onHttpClientCreate = (client) {
    client.findProxy = (url) {
      return isDebug ? 'PROXY $proxy' : 'DIRECT';
    };
  };
