import 'package:bili_you/common/models/home/recommend_item.dart';
import 'package:bili_you/common/values/cache_keys.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'widgets/recommend_card.dart';
import 'package:bili_you/common/api/home_api.dart';

import 'package:bili_you/common/utils/string_format_utils.dart';

class RecommendController extends GetxController {
  RecommendController();
  List<Widget> recommendViewList = <Widget>[];

  ScrollController scrollController = ScrollController();
  EasyRefreshController refreshController = EasyRefreshController(
      controlFinishLoad: true, controlFinishRefresh: true);
  int refreshIdx = 0;
  CacheManager cacheManager =
      CacheManager(Config(CacheKeys.recommendItemCoverKey));

  void animateToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

//加载并追加视频推荐
  Future<bool> _addRecommendItems() async {
    List<RecommendItemModel> list =
        (await HomeApi.requestRecommendVideos(16, refreshIdx)).data.item;
    for (RecommendItemModel i in list) {
      recommendViewList.add(RecommendCard(
          cacheManager: cacheManager,
          imageUrl: i.coverPic,
          playNum: StringFormatUtils.numFormat(i.playNum),
          danmakuNum: StringFormatUtils.numFormat(i.danmakuNum),
          timeLength: StringFormatUtils.timeLengthFormat(i.timeLength),
          title: i.title,
          upName: i.upName,
          bvid: i.bvid,
          cid: i.cid));
    }
    refreshIdx += 1;
    return true;
  }

  void onRefresh() async {
    recommendViewList.clear();
    update(["recommend"]);
    await cacheManager.emptyCache();
    if (await _addRecommendItems()) {
      refreshController.finishRefresh(IndicatorResult.success);
    } else {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
    update(["recommend"]);
  }

  void onLoad() async {
    if (await _addRecommendItems()) {
      refreshController.finishLoad(IndicatorResult.success);
      refreshController.resetFooter();
    } else {
      refreshController.finishLoad(IndicatorResult.fail);
    }
    update(["recommend"]);
  }

  _initData() {
    update(["recommend"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
