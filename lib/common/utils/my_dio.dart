import 'dart:developer';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_flutter_transformer2/dio_flutter_transformer2.dart';
import 'package:path_provider/path_provider.dart';

abstract class MyDio {
  static Dio dio = Dio();
  static Dio dioNoCookie = Dio();
  static late CookieManager cookieManager;
  static init() async {
    if (kIsWeb) {
      cookieManager = CookieManager(CookieJar());
    } else {
      //设置cookie存放的位置，保存cookie
      var cookiePath =
          "${(await getApplicationSupportDirectory()).path}/.cookies/";
      cookieManager =
          CookieManager(PersistCookieJar(storage: FileStorage(cookiePath)));
    }
    dio.transformer = FlutterTransformer();
    dio.interceptors.add(cookieManager);
    try {
      dio.get(ApiConstants.bilibiliBase); //获取默认cookie
    } catch (e) {
      log("utils/my_dio, ${e.toString()}");
    }
  }
}
