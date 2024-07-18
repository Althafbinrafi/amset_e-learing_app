// ignore_for_file: file_names

import 'dart:convert';

CourseFetchModel courseFetchModelFromJson(String str) =>
    CourseFetchModel.fromJson(json.decode(str));

String courseFetchModelToJson(CourseFetchModel data) =>
    json.encode(data.toJson());

class CourseFetchModel {
  Course course;
  List<Chapter> chapters;

  CourseFetchModel({
    required this.course,
    required this.chapters,
  });

  factory CourseFetchModel.fromJson(Map<String, dynamic> json) =>
      CourseFetchModel(
        course: Course.fromJson(json["course"]),
        chapters: List<Chapter>.from(
            json["chapters"].map((x) => Chapter.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "course": course.toJson(),
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
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
  String description;
  String videoUrl;

  Chapter({
    required this.id,
    required this.title,
    required this.isPublished,
    required this.course,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.description,
    required this.videoUrl,
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
        description: json["description"] ?? '', // Handle null value
        videoUrl: json["videoUrl"] ?? '', // Handle null value
      );

  get lessons => null;

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
        "videoUrl": videoUrl,
      };
}

class Course {
  bool deleted;
  String id;
  String title;
  bool isPublished;
  List<String> chapters;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String description;
  String category;
  String imageUrl;

  Course({
    required this.deleted,
    required this.id,
    required this.title,
    required this.isPublished,
    required this.chapters,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        deleted: json["deleted"],
        id: json["_id"],
        title: json["title"],
        isPublished: json["isPublished"],
        chapters: List<String>.from(json["chapters"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        description: json["description"] ?? '', // Handle null value
        category: json["category"] ?? '', // Handle null value
        imageUrl: json["imageUrl"] ?? '', // Handle null value
      );

  Map<String, dynamic> toJson() => {
        "deleted": deleted,
        "_id": id,
        "title": title,
        "isPublished": isPublished,
        "chapters": List<dynamic>.from(chapters.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "description": description,
        "category": category,
        "imageUrl": imageUrl,
      };
}
