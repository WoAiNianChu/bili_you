import 'package:bili_you/pages/about/about_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bili_you/pages/login/sms_login/view.dart';
import 'index.dart';

class UserMenuPage extends GetView<UserMenuController> {
  const UserMenuPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView(context) {
    return Dialog(
      child: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 15, bottom: 10),
                  child: MaterialButton(
                    clipBehavior: Clip.antiAlias,
                    onPressed: () {},
                    shape: const CircleBorder(eccentricity: 0),
                    child: FutureBuilder(
                      future: controller.loadOldFace(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Obx(() => CachedNetworkImage(
                                //头像
                                cacheManager: controller.cacheManager,
                                width: 80,
                                height: 80,
                                imageUrl: controller.faceUrl.value,
                                placeholder: (context, url) => const SizedBox(
                                  width: 80,
                                  height: 80,
                                ),
                              ));
                        } else {
                          return Obx(() => CachedNetworkImage(
                                //头像
                                cacheManager: controller.cacheManager,
                                width: 80,
                                height: 80,
                                imageUrl: controller.faceUrl.value,
                                placeholder: (context, url) => const SizedBox(
                                  width: 80,
                                  height: 80,
                                ),
                              ));
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                            controller.name.value,
                            style: const TextStyle(fontSize: 17),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Obx(() => Text("LV${controller.level.value}",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface))),
                          const SizedBox(
                            width: 20,
                          ),
                          Obx(() => Text(
                                "${controller.currentExp}/${controller.nextExp}",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).hintColor),
                              ))
                        ],
                      ),
                      SizedBox.fromSize(
                          size: const Size(100, 2),
                          child: Obx(
                            () => LinearProgressIndicator(
                              backgroundColor: Theme.of(context).highlightColor,
                              value: controller.nextExp.value != 0
                                  ? controller.currentExp.value /
                                      controller.nextExp.value
                                  : 0,
                            ),
                          )),
                    ],
                  ),
                )
              ]),
              Row(
                children: [
                  Expanded(
                      child: Center(
                    child: MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  controller.dynamicCount.value.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color),
                                )),
                            Text(
                              "动态",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .color),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Center(
                    child: MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  controller.followingCount.value.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color),
                                )),
                            Text(
                              "关注",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .color),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Center(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Obx(() => Text(
                                  controller.followerCount.value.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .color),
                                )),
                            Text(
                              "粉丝",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .color),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              Divider(
                height: 10,
                color: Theme.of(context).dividerColor,
                indent: 25,
                endIndent: 25,
                thickness: 2,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 35, right: 35, top: 25, bottom: 25),
                  child: Row(children: [
                    const Icon(
                      Icons.settings,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 13,
                    ),
                    const Text(
                      "设置",
                      style: TextStyle(fontSize: 18),
                    )
                  ]),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 35, right: 35, top: 25, bottom: 25),
                  child: Row(children: [
                    const Icon(Icons.info),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 13,
                    ),
                    const Text(
                      "关于",
                      style: TextStyle(fontSize: 18),
                    )
                  ]),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.onLogout();
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 35, right: 35, top: 25, bottom: 25),
                  child: Row(children: [
                    const Icon(Icons.logout_rounded),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 13,
                    ),
                    const Text(
                      "退出登陆",
                      style: TextStyle(fontSize: 18),
                    )
                  ]),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
          Row(
            children: [
              IconButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: () {
                    Get.close(1);
                  },
                  icon: const Icon(Icons.close_rounded)),
              const Spacer(
                flex: 1,
              ),
              FutureBuilder(
                  future: controller.hasLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Offstage(
                        offstage: snapshot.data ?? false,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: TextButton(
                            onPressed: () {
                              Get.off(() => const PhoneLoginPage());
                            },
                            child: const Text(
                              "登录",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Spacer();
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserMenuController>(
      init: UserMenuController(),
      id: "user_face",
      builder: (_) {
        return _buildView(context);
      },
    );
  }
}
