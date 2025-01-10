// To parse this JSON data, do
//
//     final chapterOrderModel = chapterOrderModelFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

ChapterOrderModel chapterOrderModelFromJson(String str) => ChapterOrderModel.fromJson(json.decode(str));

String chapterOrderModelToJson(ChapterOrderModel data) => json.encode(data.toJson());

class ChapterOrderModel {
    bool? success;
    Data? data;

    ChapterOrderModel({
        this.success,
        this.data,
    });

    factory ChapterOrderModel.fromJson(Map<String, dynamic> json) => ChapterOrderModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    List<PaymentDetail>? paymentDetails;

    Data({
        this.paymentDetails,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        paymentDetails: json["paymentDetails"] == null ? [] : List<PaymentDetail>.from(json["paymentDetails"]!.map((x) => PaymentDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "paymentDetails": paymentDetails == null ? [] : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
    };
}

class PaymentDetail {
  String? orderId;
  int? amount;
  String? status;
  DateTime? createdAt;
  Chapter? chapter;

  PaymentDetail({
    this.orderId,
    this.amount,
    this.status,
    this.createdAt,
    this.chapter,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        orderId: json["orderId"],
        amount: json["amount"],
        status: json["status"],
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
        chapter: json["chapter"] != null ? Chapter.fromJson(json["chapter"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "amount": amount,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "chapter": chapter?.toJson(),
      };
}

class Chapter {
  String? id;
  String? title;
  String? description;

  Chapter({
    this.id,
    this.title,
    this.description,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
      };
}


enum PurchasedUser {
    THE_664818_C2866366_C3_A2_FA1_BD1,
    THE_675_A6_F95_DD4_F660_D464_F5441,
    THE_6760584643964102_BF3_B743_B
}

final purchasedUserValues = EnumValues({
    "664818c2866366c3a2fa1bd1": PurchasedUser.THE_664818_C2866366_C3_A2_FA1_BD1,
    "675a6f95dd4f660d464f5441": PurchasedUser.THE_675_A6_F95_DD4_F660_D464_F5441,
    "6760584643964102bf3b743b": PurchasedUser.THE_6760584643964102_BF3_B743_B
});

class Question {
    String? questionText;
    List<String>? options;
    int? correctAnswerIndex;
    String? id;

    Question({
        this.questionText,
        this.options,
        this.correctAnswerIndex,
        this.id,
    });

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionText: json["questionText"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
        correctAnswerIndex: json["correctAnswerIndex"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "questionText": questionText,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "correctAnswerIndex": correctAnswerIndex,
        "_id": id,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
