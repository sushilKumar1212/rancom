// To parse this JSON data, do
//
//     final onboardModel = onboardModelFromJson(jsonString);

import 'dart:convert';

OnboardModel onboardModelFromJson(String str) =>
    OnboardModel.fromJson(json.decode(str));

String onboardModelToJson(OnboardModel data) => json.encode(data.toJson());

class OnboardModel {
  OnboardModel({
    required this.success,
    required this.introductionScreenData,
  });

  bool success;
  List<IntroductionScreenDatum> introductionScreenData;

  factory OnboardModel.fromJson(Map<String, dynamic> json) => OnboardModel(
        success: json["success"],
        introductionScreenData: List<IntroductionScreenDatum>.from(
            json["introductionScreenData"]
                .map((x) => IntroductionScreenDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "introductionScreenData":
            List<dynamic>.from(introductionScreenData.map((x) => x.toJson())),
      };
}

class IntroductionScreenDatum {
  IntroductionScreenDatum({
    required this.id,
    required this.title,
    this.description,
    required this.articles,
    required this.order,
    required this.v,
    required this.imageUrl,
  });

  String id;
  String title;
  String? description;
  List<Article> articles;
  int order;
  int v;
  String imageUrl;

  factory IntroductionScreenDatum.fromJson(Map<String, dynamic> json) =>
      IntroductionScreenDatum(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
        order: json["order"],
        v: json["__v"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
        "order": order,
        "__v": v,
        "image_url": imageUrl,
      };
}

class Article {
  Article({
    required this.title,
    required this.description,
  });

  String title;
  String description;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
