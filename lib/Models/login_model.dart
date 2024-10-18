// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  bool deleted;
  String id;
  String? username; // Nullable
  String? email; // Nullable
  String? mobileNumber; // Nullable
  bool isAdmin;
  int v;
  List<String> courses;
  DateTime updatedAt;
  String? image; // Nullable

  ProfileModel({
    required this.deleted,
    required this.id,
    this.username, // Nullable
    this.email, // Nullable
    this.mobileNumber, // Nullable
    required this.isAdmin,
    required this.v,
    required this.courses,
    required this.updatedAt,
    this.image, // Nullable
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        deleted: json["deleted"],
        id: json["_id"],
        username: json["username"] as String?, // Nullable
        email: json["email"] as String?, // Nullable
        mobileNumber: json["mobileNumber"] as String?, // Nullable
        isAdmin: json["isAdmin"],
        v: json["__v"],
        courses: List<String>.from(json["courses"].map((x) => x)),
        updatedAt: DateTime.parse(json["updatedAt"]),
        image: json["image"] as String?, // Nullable
      );

  Map<String, dynamic> toJson() => {
        "deleted": deleted,
        "_id": id,
        "username": username,
        "email": email,
        "mobileNumber": mobileNumber,
        "isAdmin": isAdmin,
        "__v": v,
        "courses": List<dynamic>.from(courses.map((x) => x)),
        "updatedAt": updatedAt.toIso8601String(),
        "image": image,
      };
}
