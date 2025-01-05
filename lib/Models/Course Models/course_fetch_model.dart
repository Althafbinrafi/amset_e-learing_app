

import 'dart:convert';

CourseFetchModel courseFetchModelFromJson(String str) => CourseFetchModel.fromJson(json.decode(str));

String courseFetchModelToJson(CourseFetchModel data) => json.encode(data.toJson());

class CourseFetchModel {
    int results;
    List<Course> courses;

    CourseFetchModel({
        required this.results,
        required this.courses,
    });

    factory CourseFetchModel.fromJson(Map<String, dynamic> json) => CourseFetchModel(
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
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String description;
    String? category;
    String imageUrl;
    int price;
    bool? isPremium;
    bool deleted;
    int coinsOfRecommend;
    int vacancyCount;
    List<Chapter> chapters;
    List<Learner>? learners;
    List<HiringPartner>? hiringPartners;

    Course({
        required this.id,
        required this.title,
        required this.isPublished,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.description,
        this.category,
        required this.imageUrl,
        required this.price,
        this.isPremium,
        required this.deleted,
        required this.coinsOfRecommend,
        required this.vacancyCount,
        required this.chapters,
        this.learners,
        this.hiringPartners,
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
        learners: json["learners"] == null ? [] : List<Learner>.from(json["learners"]!.map((x) => Learner.fromJson(x))),
        hiringPartners: json["hiringPartners"] == null ? [] : List<HiringPartner>.from(json["hiringPartners"]!.map((x) => HiringPartner.fromJson(x))),
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
        "learners": learners == null ? [] : List<dynamic>.from(learners!.map((x) => x.toJson())),
        "hiringPartners": hiringPartners == null ? [] : List<dynamic>.from(hiringPartners!.map((x) => x.toJson())),
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
    bool? isPremium;
    List<Question>? questions;

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
        this.isPremium,
        this.questions,
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
        isPremium: json["isPremium"],
        questions: json["questions"] == null ? [] : List<Question>.from(json["questions"]!.map((x) => Question.fromJson(x))),
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
        "questions": questions == null ? [] : List<dynamic>.from(questions!.map((x) => x.toJson())),
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
        questionText: json["questionText"],
        options: List<String>.from(json["options"].map((x) => x)),
        correctAnswerIndex: json["correctAnswerIndex"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "questionText": questionText,
        "options": List<dynamic>.from(options.map((x) => x)),
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
        this.companyLogo,
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
