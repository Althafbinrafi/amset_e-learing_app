// To parse this JSON data, do
//
//     final myCourseModel = myCourseModelFromJson(jsonString);

import 'dart:convert';

MyCourseModel myCourseModelFromJson(String str) => MyCourseModel.fromJson(json.decode(str));

String myCourseModelToJson(MyCourseModel data) => json.encode(data.toJson());

class MyCourseModel {
    User user;
    List<CourseDatum> courseData;

    MyCourseModel({
        required this.user,
        required this.courseData,
    });

    factory MyCourseModel.fromJson(Map<String, dynamic> json) => MyCourseModel(
        user: User.fromJson(json["user"]),
        courseData: List<CourseDatum>.from(json["courseData"].map((x) => CourseDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "courseData": List<dynamic>.from(courseData.map((x) => x.toJson())),
    };
}

class CourseDatum {
    Course course;
    String progressPercentage;
    List<PublishedChapter> publishedChapters;

    CourseDatum({
        required this.course,
        required this.progressPercentage,
        required this.publishedChapters,
    });

    factory CourseDatum.fromJson(Map<String, dynamic> json) => CourseDatum(
        course: Course.fromJson(json["course"]),
        progressPercentage: json["progressPercentage"],
        publishedChapters: List<PublishedChapter>.from(json["publishedChapters"].map((x) => PublishedChapter.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "course": course.toJson(),
        "progressPercentage": progressPercentage,
        "publishedChapters": List<dynamic>.from(publishedChapters.map((x) => x.toJson())),
    };
}

class Course {
    String id;
    String title;
    String imageUrl;

    Course({
        required this.id,
        required this.title,
        required this.imageUrl,
    });

    factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["_id"],
        title: json["title"],
        imageUrl: json["imageUrl"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": imageUrl,
    };
}

class PublishedChapter {
    String id;
    String title;
    String course;

    PublishedChapter({
        required this.id,
        required this.title,
        required this.course,
    });

    factory PublishedChapter.fromJson(Map<String, dynamic> json) => PublishedChapter(
        id: json["_id"],
        title: json["title"],
        course: json["course"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "course": course,
    };
}

class User {
    bool deleted;
    String id;
    String username;
    String email;
    String mobileNumber;
    bool isAdmin;
    int v;
    List<Course> courses;
    DateTime updatedAt;

    User({
        required this.deleted,
        required this.id,
        required this.username,
        required this.email,
        required this.mobileNumber,
        required this.isAdmin,
        required this.v,
        required this.courses,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        deleted: json["deleted"],
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        isAdmin: json["isAdmin"],
        v: json["__v"],
        courses: List<Course>.from(json["courses"].map((x) => Course.fromJson(x))),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "deleted": deleted,
        "_id": id,
        "username": username,
        "email": email,
        "mobileNumber": mobileNumber,
        "isAdmin": isAdmin,
        "__v": v,
        "courses": List<dynamic>.from(courses.map((x) => x.toJson())),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
