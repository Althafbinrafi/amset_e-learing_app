
// To parse this JSON data, do
//
//     final allCoursesModel = allCoursesModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

AllCoursesModel allCoursesModelFromJson(String str) => AllCoursesModel.fromJson(json.decode(str));

String allCoursesModelToJson(AllCoursesModel data) => json.encode(data.toJson());

class AllCoursesModel {
    int results;
    List<Course> courses;

    AllCoursesModel({
        required this.results,
        required this.courses,
    });

    factory AllCoursesModel.fromJson(Map<String, dynamic> json) => AllCoursesModel(
        results: json["results"],
        courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": results,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
    };
}

class Course {
    String id;
    String title;
    bool isPublished;
    List<Chapter> chapters;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String? description;
    String? category;
    String? imageUrl;
    int price;
    bool? deleted;

    Course({
        required this.id,
        required this.title,
        required this.isPublished,
        required this.chapters,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        this.description,
        this.category,
        this.imageUrl,
        required this.price,
        this.deleted,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["_id"],
        title: json["title"],
        isPublished: json["isPublished"],
        chapters: List<Chapter>.from(json["chapters"].map((x) => Chapter.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        description: json["description"],
        category: json["category"],
        imageUrl: json["imageUrl"],
        price: json["price"],
        deleted: json["deleted"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "isPublished": isPublished,
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "description": description,
        "category": category,
        "imageUrl": imageUrl,
        "price": price,
        "deleted": deleted,
    };
}

class Chapter {
    String id;
    String title;
    bool isPublished;
    String course;
    int position;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String? description;

    Chapter({
        required this.id,
        required this.title,
        required this.isPublished,
        required this.course,
        required this.position,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        this.description,
    });

    factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["_id"],
        title: json["title"],
        isPublished: json["isPublished"],
        course: json["course"],
        position: json["position"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "isPublished": isPublished,
        "course": course,
        "position": position,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "description": description,
    };
}
