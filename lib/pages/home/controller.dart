import 'dart:developer';

import 'package:bili_you/common/api/api_constants.dart';
import 'package:bili_you/common/api/search_api.dart';
import 'package:bili_you/common/api/user_api.dart';
import 'package:bili_you/common/models/search/default_search_word.dart';
import 'package:bili_you/common/models/user/user_info.dart';
import 'package:bili_you/common/values/cache_keys.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  HomeController();
  CacheManager cacheManager = CacheManager(Config(CacheKeys.userFaceKey));
  RxString faceUrl = ApiConstants.noface.obs;
  late UserInfoModel userInfo;

  RxString defaultSearchWord = "搜索".obs;

  _initData() async {
    update(["home"]);
    refreshDefaultSearchWord();
  }

  refreshDefaultSearchWord() async {
    try {
      DefaultSearchWordModel defaultSearchWordModel =
          await SearchApi.requestDefaultSearchWord();
      if (defaultSearchWordModel.code == 0) {
        defaultSearchWord.value = defaultSearchWordModel.showName;
      }
    } catch (e) {
      log("获取搜素框默认词失败,网络错误?");
      log(e.toString());
    }
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() async {
    super.onReady();
    _initData();
  }

  Future<void> refreshFace() async {
    try {
      userInfo = await UserApi.requestUserInfo();
      faceUrl.value = userInfo.face;
    } catch (e) {
      faceUrl.value = ApiConstants.noface;
      log(e.toString());
    }
  }

  Future<void> loadOldFace() async {
    var pref = (await SharedPreferences.getInstance());
    faceUrl.value = pref.getString("userFace") ?? ApiConstants.noface;
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
