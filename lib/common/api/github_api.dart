import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/github/github_releases_item.dart';
import 'api_constants.dart';

class GithubApi {
  static Future<GithubReleasesItemModel> requestLatestRelease() async {
    var response = await Dio().get(ApiConstants.githubLatestRelease,
        options: Options(headers: {
          "Authorization": base64.decode(
              "dG9rZW4gZ2hwX05ia0huNm9aRlRJN0ZyTzFPb1R4MkF3U21oTFN0OTBhN1lQVQ==")
        }));

    return GithubReleasesItemModel.fromJson(response.data);
  }
}
