import 'dart:convert';

JobVacancyModel jobVacancyModelFromJson(String str) => JobVacancyModel.fromJson(json.decode(str));

String jobVacancyModelToJson(JobVacancyModel data) => json.encode(data.toJson());

class JobVacancyModel {
    int results;
    List<Datum> data;

    JobVacancyModel({
        required this.results,
        required this.data,
    });

    factory JobVacancyModel.fromJson(Map<String, dynamic> json) => JobVacancyModel(
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
    String title;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String imageUrl;

    Datum({
        required this.id,
        required this.title,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.imageUrl,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
