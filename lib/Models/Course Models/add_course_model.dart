// To parse this JSON data, do
//
//     final addCourseModel = addCourseModelFromJson(jsonString);

import 'dart:convert';

AddCourseModel addCourseModelFromJson(String str) => AddCourseModel.fromJson(json.decode(str));

String addCourseModelToJson(AddCourseModel data) => json.encode(data.toJson());

class AddCourseModel {
    String message;
    Course course;

    AddCourseModel({
        required this.message,
        required this.course,
    });

    factory AddCourseModel.fromJson(Map<String, dynamic> json) => AddCourseModel(
        message: json["message"],
        course: Course.fromJson(json["course"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "course": course.toJson(),
    };
}

class Course {
    String id;
    String title;
    bool isPublished;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String description;
    String category;
    String imageUrl;
    int price;
    bool isPremium;
    bool deleted;
    int coinsOfRecommend;
    int vacancyCount;
    List<Chapter> chapters;
    List<Learner> learners;
    List<HiringPartner> hiringPartners;

    Course({
        required this.id,
        required this.title,
        required this.isPublished,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.description,
        required this.category,
        required this.imageUrl,
        required this.price,
        required this.isPremium,
        required this.deleted,
        required this.coinsOfRecommend,
        required this.vacancyCount,
        required this.chapters,
        required this.learners,
        required this.hiringPartners,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["_id"],
        title: json["title"],
        isPublished: json["isPublished"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        description: json["description"],
        category: json["category"],
        imageUrl: json["imageUrl"],
        price: json["price"],
        isPremium: json["isPremium"],
        deleted: json["deleted"],
        coinsOfRecommend: json["coinsOfRecommend"],
        vacancyCount: json["vacancyCount"],
        chapters: List<Chapter>.from(json["chapters"].map((x) => Chapter.fromJson(x))),
        learners: List<Learner>.from(json["learners"].map((x) => Learner.fromJson(x))),
        hiringPartners: List<HiringPartner>.from(json["hiringPartners"].map((x) => HiringPartner.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "isPublished": isPublished,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "description": description,
        "category": category,
        "imageUrl": imageUrl,
        "price": price,
        "isPremium": isPremium,
        "deleted": deleted,
        "coinsOfRecommend": coinsOfRecommend,
        "vacancyCount": vacancyCount,
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
        "learners": List<dynamic>.from(learners.map((x) => x.toJson())),
        "hiringPartners": List<dynamic>.from(hiringPartners.map((x) => x.toJson())),
    };
}

class Chapter {
    String chapter;
    bool isPremium;
    String id;

    Chapter({
        required this.chapter,
        required this.isPremium,
        required this.id,
    });

    factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        chapter: json["chapter"],
        isPremium: json["isPremium"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "chapter": chapter,
        "isPremium": isPremium,
        "_id": id,
    };
}

class HiringPartner {
    String companyName;
    String companyLogo;
    String poster;
    String id;

    HiringPartner({
        required this.companyName,
        required this.companyLogo,
        required this.poster,
        required this.id,
    });

    factory HiringPartner.fromJson(Map<String, dynamic> json) => HiringPartner(
        companyName: json["companyName"],
        companyLogo: json["companyLogo"],
        poster: json["poster"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "companyName": companyName,
        "companyLogo": companyLogo,
        "poster": poster,
        "_id": id,
    };
}

class Learner {
    String user;
    DateTime joinedOn;
    String id;

    Learner({
        required this.user,
        required this.joinedOn,
        required this.id,
    });

    factory Learner.fromJson(Map<String, dynamic> json) => Learner(
        user: json["user"],
        joinedOn: DateTime.parse(json["joinedOn"]),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "joinedOn": joinedOn.toIso8601String(),
        "_id": id,
    };
}
