// To parse this JSON data, do
//
//     final registrationModel = registrationModelFromJson(jsonString);

import 'dart:convert';

RegistrationModel registrationModelFromJson(String str) => RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) => json.encode(data.toJson());

class RegistrationModel {
    String message;
    bool success;
    User user;

    RegistrationModel({
        required this.message,
        required this.success,
        required this.user,
    });

    factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
        message: json["message"],
        success: json["success"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "success": success,
        "user": user.toJson(),
    };
}

class User {
    String fullName;
    String username;
    String email;
    String mobileNumber;
    bool isAdmin;
    List<dynamic> courses;
    bool deleted;
    String id;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    User({
        required this.fullName,
        required this.username,
        required this.email,
        required this.mobileNumber,
        required this.isAdmin,
        required this.courses,
        required this.deleted,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: json["fullName"],
        username: json["username"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        isAdmin: json["isAdmin"],
        courses: List<dynamic>.from(json["courses"].map((x) => x)),
        deleted: json["deleted"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "username": username,
        "email": email,
        "mobileNumber": mobileNumber,
        "isAdmin": isAdmin,
        "courses": List<dynamic>.from(courses.map((x) => x)),
        "deleted": deleted,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
