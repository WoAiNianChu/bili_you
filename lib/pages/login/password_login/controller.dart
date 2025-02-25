import 'dart:developer';

import 'package:bili_you/common/api/login_api.dart';
import 'package:bili_you/common/api/user_api.dart';
import 'package:bili_you/common/models/login/captcha_result.dart';
import 'package:bili_you/common/models/login/password_login_result.dart';
import 'package:bili_you/pages/login/sms_login/index.dart';
import 'package:get/get.dart';

import 'package:bili_you/common/models/login/password_login_key_hash.dart';
import '../controller.dart';

class PasswordLoginController extends GetxController {
  PasswordLoginController();

  String account = "";
  String password = "";
  late CaptchaResultModel _captchaResult;

  void startLogin() async {
    startCaptcha(
      onSuccess: (captchaResult) async {
        _captchaResult = captchaResult;

        late PasswordLoginKeyHashModel passwordLoginKeyHash;
        try {
          passwordLoginKeyHash = await LoginApi.getPasswordLoginKeyHash();
        } catch (e) {
          Get.rawSnackbar(title: "登录", message: "网络错误");
          log("获取公钥错误$e");
          return;
        }
        if (passwordLoginKeyHash.code != 0) {
          Get.rawSnackbar(title: "登录", message: "获取公钥错误");
          return;
        }
        late PasswordLoginResultModel passwordLoginResult;
        try {
          passwordLoginResult = await LoginApi.postPasswordLoginInfo(
              _captchaResult, passwordLoginKeyHash, account, password);
        } catch (e) {
          Get.rawSnackbar(title: "登录", message: "网络错误");
          log(e.toString());
          return;
        }
        if (passwordLoginResult.code != 0) {
          Get.rawSnackbar(
              title: "登陆", message: "错误，${passwordLoginResult.message}");
          return;
        } else {
          if (passwordLoginResult.status == 0) {
            Get.rawSnackbar(title: "登陆", message: "成功!");
            await onLoginSuccess(await UserApi.requestUserInfo(),
                await UserApi.requestUserStat());
            Get.back();
          } else if (passwordLoginResult.status == 2) {
            //提示当前环境有安全问题，需要手机验证或绑定
            Get.rawSnackbar(
                title: "登陆", message: "错误! 当前环境有安全风险，请使用手机登陆或绑定手机号!");
            Get.off(() => const PhoneLoginPage());
          } else {
            Get.rawSnackbar(
                title: "登陆", message: "错误!,${passwordLoginResult.message}}");
          }
        }
      },
    );
  }

  _initData() {
    update(["password_login"]);
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
