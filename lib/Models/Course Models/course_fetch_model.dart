import 'dart:convert';

CourseFetchModel courseFetchModelFromJson(String str) =>
    CourseFetchModel.fromJson(json.decode(str));

String courseFetchModelToJson(CourseFetchModel data) =>
    json.encode(data.toJson());

class CourseFetchModel {
  int results;
  List<Course> courses;

  CourseFetchModel({
    required this.results,
    required this.courses,
  });

  factory CourseFetchModel.fromJson(Map<String, dynamic> json) =>
      CourseFetchModel(
        results: json["results"] ?? 0,
        courses: (json["courses"] as List<dynamic>? ?? [])
            .map((x) => Course.fromJson(x as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "results": results,
        "courses": courses.map((x) => x.toJson()).toList(),
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
    this.category = '',
    required this.imageUrl,
    this.price = 0,
    this.isPremium = false,
    this.deleted = false,
    this.coinsOfRecommend = 0,
    this.vacancyCount = 0,
    this.chapters = const [],
    this.learners = const [],
    this.hiringPartners = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["_id"] ?? '',
        title: json["title"] ?? '',
        isPublished: json["isPublished"] ?? false,
        createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime.now(),
        v: json["__v"] ?? 0,
        description: json["description"] ?? '',
        category: json["category"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        price: json["price"] ?? 0,
        isPremium: json["isPremium"] ?? false,
        deleted: json["deleted"] ?? false,
        coinsOfRecommend: json["coinsOfRecommend"] ?? 0,
        vacancyCount: json["vacancyCount"] ?? 0,
        chapters: (json["chapters"] as List<dynamic>? ?? [])
            .map((x) => Chapter.fromJson(x as Map<String, dynamic>))
            .toList(),
        learners: (json["learners"] as List<dynamic>? ?? [])
            .map((x) => Learner.fromJson(x as Map<String, dynamic>))
            .toList(),
        hiringPartners: (json["hiringPartners"] as List<dynamic>? ?? [])
            .map((x) => HiringPartner.fromJson(x as Map<String, dynamic>))
            .toList(),
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
        "chapters": chapters.map((x) => x.toJson()).toList(),
        "learners": learners.map((x) => x.toJson()).toList(),
        "hiringPartners": hiringPartners.map((x) => x.toJson()).toList(),
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
  bool isPremium;
  List<Question> questions;

  Chapter({
    required this.id,
    required this.title,
    required this.isPublished,
    required this.course,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.description = '',
    this.isPremium = false,
    this.questions = const [],
  });

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["_id"] ?? '',
        title: json["title"] ?? '',
        isPublished: json["isPublished"] ?? false,
        course: json["course"] ?? '',
        position: json["position"] ?? 0,
        createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime.now(),
        v: json["__v"] ?? 0,
        description: json["description"] ?? '',
        isPremium: json["isPremium"] ?? false,
        questions: (json["questions"] as List<dynamic>? ?? [])
            .map((x) => Question.fromJson(x as Map<String, dynamic>))
            .toList(),
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
        "isPremium": isPremium,
        "questions": questions.map((x) => x.toJson()).toList(),
      };
}

class Question {
  String questionText;
  List<String> options;
  int correctAnswerIndex;
  String id;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.id,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionText: json["questionText"] ?? '',
        options: (json["options"] as List<dynamic>? ?? []).cast<String>(),
        correctAnswerIndex: json["correctAnswerIndex"] ?? 0,
        id: json["_id"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "questionText": questionText,
        "options": options,
        "correctAnswerIndex": correctAnswerIndex,
        "_id": id,
      };
}

class HiringPartner {
  String companyName;
  String? companyLogo;
  String poster;
  String id;

  HiringPartner({
    required this.companyName,
    this.companyLogo = '',
    required this.poster,
    required this.id,
  });

  factory HiringPartner.fromJson(Map<String, dynamic> json) => HiringPartner(
        companyName: json["companyName"] ?? '',
        companyLogo: json["companyLogo"] ?? '',
        poster: json["poster"] ?? '',
        id: json["_id"] ?? '',
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
        user: json["user"] ?? '',
        joinedOn: DateTime.tryParse(json["joinedOn"] ?? '') ?? DateTime.now(),
        id: json["_id"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "joinedOn": joinedOn.toIso8601String(),
        "_id": id,
      };
}
