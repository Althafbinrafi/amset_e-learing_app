// To parse this JSON data, do
//
//     final myCourseModel = myCourseModelFromJson(jsonString);

import 'dart:convert';

MyCourseModel myCourseModelFromJson(String str) =>
    MyCourseModel.fromJson(json.decode(str));

String myCourseModelToJson(MyCourseModel data) => json.encode(data.toJson());

class MyCourseModel {
  User user;
  List<dynamic> courseData;

  MyCourseModel({
    required this.user,
    required this.courseData,
  });

  factory MyCourseModel.fromJson(Map<String, dynamic> json) => MyCourseModel(
        user: User.fromJson(json["user"]),
        courseData: List<dynamic>.from(json["courseData"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "courseData": List<dynamic>.from(courseData.map((x) => x)),
      };
}

class User {
  String id;
  String fullName;
  String username;
  String email;
  String mobileNumber;
  bool isAdmin;
  String bioDescription;
  List<dynamic> courses;
  bool deleted;
  String address;
  String postOffice;
  String district;
  String pinCode;
  String country;
  String experience;
  String experienceSector;
  String secondaryMobileNumber;
  List<String> completedChapters;
  List<Answer> answers;
  List<CourseCoin> courseCoins;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.isAdmin,
    required this.bioDescription,
    required this.courses,
    required this.deleted,
    required this.address,
    required this.postOffice,
    required this.district,
    required this.pinCode,
    required this.country,
    required this.experience,
    required this.experienceSector,
    required this.secondaryMobileNumber,
    required this.completedChapters,
    required this.answers,
    required this.courseCoins,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        fullName: json["fullName"],
        username: json["username"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        isAdmin: json["isAdmin"],
        bioDescription: json["bioDescription"],
        courses: List<dynamic>.from(json["courses"].map((x) => x)),
        deleted: json["deleted"],
        address: json["address"],
        postOffice: json["postOffice"],
        district: json["district"],
        pinCode: json["pinCode"],
        country: json["country"],
        experience: json["experience"],
        experienceSector: json["experienceSector"],
        secondaryMobileNumber: json["secondaryMobileNumber"],
        completedChapters:
            List<String>.from(json["completedChapters"].map((x) => x)),
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        courseCoins: List<CourseCoin>.from(
            json["courseCoins"].map((x) => CourseCoin.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "username": username,
        "email": email,
        "mobileNumber": mobileNumber,
        "isAdmin": isAdmin,
        "bioDescription": bioDescription,
        "courses": List<dynamic>.from(courses.map((x) => x)),
        "deleted": deleted,
        "address": address,
        "postOffice": postOffice,
        "district": district,
        "pinCode": pinCode,
        "country": country,
        "experience": experience,
        "experienceSector": experienceSector,
        "secondaryMobileNumber": secondaryMobileNumber,
        "completedChapters":
            List<dynamic>.from(completedChapters.map((x) => x)),
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "courseCoins": List<dynamic>.from(courseCoins.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Answer {
  String chapterId;
  String courseId;
  List<UserAnswer> userAnswers;
  String id;

  Answer({
    required this.chapterId,
    required this.courseId,
    required this.userAnswers,
    required this.id,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        chapterId: json["chapterId"],
        courseId: json["courseId"],
        userAnswers: List<UserAnswer>.from(
            json["userAnswers"].map((x) => UserAnswer.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "courseId": courseId,
        "userAnswers": List<dynamic>.from(userAnswers.map((x) => x.toJson())),
        "_id": id,
      };
}

class UserAnswer {
  String questionId;
  int selectedOptionIndex;
  String id;

  UserAnswer({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.id,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
        questionId: json["questionId"],
        selectedOptionIndex: json["selectedOptionIndex"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "selectedOptionIndex": selectedOptionIndex,
        "_id": id,
      };
}

class CourseCoin {
  String courseId;
  int coins;
  String id;

  CourseCoin({
    required this.courseId,
    required this.coins,
    required this.id,
  });

  factory CourseCoin.fromJson(Map<String, dynamic> json) => CourseCoin(
        courseId: json["courseId"],
        coins: json["coins"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "coins": coins,
        "_id": id,
      };
}
