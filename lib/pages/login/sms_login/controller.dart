import 'dart:developer';

import 'package:bili_you/common/api/user_api.dart';
import 'package:bili_you/common/models/login/captcha_result.dart';
import 'package:bili_you/common/models/login/sms_request_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bili_you/common/values/coutry_id.dart';
import 'package:bili_you/common/api/login_api.dart';
import '../../../common/models/login/sms_login_result.dart';
import '../controller.dart';

class PhoneLoginController extends GetxController {
  PhoneLoginController();

  List<DropdownMenuItem<Object?>> countryItems = [];
  int countryId = 86; //地区/国家码
  int tel = 0; //手机号
  int messageCode = 0; //短信验证码
  CaptchaResultModel? _captchaResult;
  SmsRequestResultModel? smsRequestResult;

  _initData() {
    update(["phone_login"]);
  }

  void onTap() {}

//点击登陆
  void startLogin() async {
    await startCaptcha(
      onSuccess: (captchaResult) {
        _captchaResult = captchaResult;
        _startRequireSms();
      },
    );
  }

//请求短信验证码
  void _startRequireSms() async {
    if (_captchaResult!.captchaData.code != 0) {
      Get.rawSnackbar(title: "获取验证码错误", message: "未进行人机测试或人机测试失败");
      return;
    }
    try {
      smsRequestResult = await LoginApi.requestSmsToPhone(
          countryId,
          tel,
          _captchaResult!.captchaData.token,
          _captchaResult!.captchaData.challenge,
          _captchaResult!.validate,
          _captchaResult!.seccode);
    } catch (e) {
      Get.rawSnackbar(title: "验证码获取失败", message: "网络错误");
      log(e.toString());
      return;
    }
    int code = smsRequestResult!.code;
    String title = "获取验证码";
    String message = "";
    if (code == 0) {
      //成功
      message = "成功";
    } else if (code == -400) {
      //请求错误
      message = "请求错误";
    } else if (code == 1002) {
      //手机号格式错误
      message = "手机号格式错误";
    } else if (code == 86203) {
      //短信发送次数已达到上限
      message = "短信发送次数已达到上限";
    } else if (code == 1003) {
      //验证码已经发送
      message = "验证码已经发送";
    } else if (code == 1025) {
      //该手机号在哔哩哔哩有过永久封禁记录，无法再次注册或绑定新账号
      message = "该手机号在哔哩哔哩有过永久封禁记录，无法再次注册或绑定新账号";
    } else if (code == 2400) {
      //登录密钥错误
      message = "登录密钥错误";
    } else if (code == 2406) {
      //验证极验服务出错
      message = "验证极验服务出错";
    } else {
      //其他错误
      message = "发生错误，code:$code，message:${smsRequestResult!.message}";
    }
    Get.rawSnackbar(title: title, message: message);
  }

  //短信验证码登录操作
  void startSmsLogin() async {
    if (smsRequestResult == null) {
      Get.rawSnackbar(title: "登录错误", message: "验证码未获取或获取失败");
      return;
    }
    late SmsLoginResultModel smsLoginResult;
    try {
      smsLoginResult = await LoginApi.smsLogin(
          countryId, tel, messageCode, smsRequestResult!.captchaKey);
    } catch (e) {
      Get.rawSnackbar(title: "短信登录错误", message: "网络错误");
      log(e.toString());
      return;
    }
    int code = smsLoginResult.code;
    String title = "验证码登录";
    String message = "";
    if (code == 0) {
      //成功登录
      message = "成功登录";
      await onLoginSuccess(
          await UserApi.requestUserInfo(), await UserApi.requestUserStat());
      Get.back();
      //请求错误
    } else if (code == 1006) {
      //请输入正确的短信验证码
      message = "请输入正确的短信验证码";
    } else if (code == 1007) {
      // 短信验证码已过期
      message = "短信验证码已过期";
    } else {
      //其他错误
      message = "发生错误，code:$code，message:${smsLoginResult.message}";
    }
    Get.rawSnackbar(title: title, message: message);
  }

  @override
  void onInit() {
    for (Map<String, dynamic> i in CountryId.contryId) {
      countryItems.add(DropdownMenuItem(
          value: i,
          child: SizedBox(
              width: 100, child: Text("+${i['country_id']} ${i['cname']}"))));
    }
    super.onInit();
  }

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
