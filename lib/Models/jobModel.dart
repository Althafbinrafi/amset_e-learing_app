// To parse this JSON data, do
//
//     final jobModel = jobModelFromJson(jsonString);

import 'dart:convert';

JobModel jobModelFromJson(String str) => JobModel.fromJson(json.decode(str));

String jobModelToJson(JobModel data) => json.encode(data.toJson());

class JobModel {
  int results;
  List<Datum> data;

  JobModel({
    required this.results,
    required this.data,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        results: json["results"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": results,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String jobTitle;
  VacancyId vacancyId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Datum({
    required this.id,
    required this.jobTitle,
    required this.vacancyId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        jobTitle: json["jobTitle"],
        vacancyId: VacancyId.fromJson(json["vacancyId"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "jobTitle": jobTitle,
        "vacancyId": vacancyId.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class VacancyId {
  String id;
  String title;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String imageUrl;

  VacancyId({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.imageUrl,
  });

  factory VacancyId.fromJson(Map<String, dynamic> json) => VacancyId(
        id: json["_id"],
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "imageUrl": imageUrl,
      };
}
