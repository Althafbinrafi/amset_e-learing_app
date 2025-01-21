import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    String? id;
    String? username;
    String? email;
    String? mobileNumber;
    bool? isAdmin;
    int? v;
    List<dynamic>? courses;
    DateTime? updatedAt;
    String? image;
    String? address;
    String? district;
    String? fullName;
    String? postOffice;
    String? pinCode;
    String? secondaryMobileNumber;
    List<Answer>? answers;
    List<String>? completedChapters;
    List<CourseCoin>? courseCoins;
    bool? deleted;
    String? bioDescription;

    UserModel({
        this.id,
        this.username,
        this.email,
        this.mobileNumber,
        this.isAdmin,
        this.v,
        this.courses,
        this.updatedAt,
        this.image,
        this.address,
        this.district,
        this.fullName,
        this.postOffice,
        this.pinCode,
        this.secondaryMobileNumber,
        this.answers,
        this.completedChapters,
        this.courseCoins,
        this.deleted,
        this.bioDescription,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        isAdmin: json["isAdmin"],
        v: json["__v"],
        courses: json["courses"] == null ? [] : List<dynamic>.from(json["courses"].map((x) => x)),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        image: json["image"],
        address: json["address"],
        district: json["district"],
        fullName: json["fullName"],
        postOffice: json["postOffice"],
        pinCode: json["pinCode"],
        secondaryMobileNumber: json["secondaryMobileNumber"],
        answers: json["answers"] == null ? [] : List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        completedChapters: json["completedChapters"] == null ? [] : List<String>.from(json["completedChapters"].map((x) => x)),
        courseCoins: json["courseCoins"] == null ? [] : List<CourseCoin>.from(json["courseCoins"].map((x) => CourseCoin.fromJson(x))),
        deleted: json["deleted"],
        bioDescription: json["bioDescription"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "mobileNumber": mobileNumber,
        "isAdmin": isAdmin,
        "__v": v,
        "courses": courses == null ? [] : List<dynamic>.from(courses!.map((x) => x)),
        "updatedAt": updatedAt?.toIso8601String(),
        "image": image,
        "address": address,
        "district": district,
        "fullName": fullName,
        "postOffice": postOffice,
        "pinCode": pinCode,
        "secondaryMobileNumber": secondaryMobileNumber,
        "answers": answers == null ? [] : List<dynamic>.from(answers!.map((x) => x.toJson())),
        "completedChapters": completedChapters == null ? [] : List<dynamic>.from(completedChapters!.map((x) => x)),
        "courseCoins": courseCoins == null ? [] : List<dynamic>.from(courseCoins!.map((x) => x.toJson())),
        "deleted": deleted,
        "bioDescription": bioDescription,
    };
}

class Answer {
    String? chapterId;
    String? courseId;
    List<UserAnswer>? userAnswers;
    String? id;

    Answer({
        this.chapterId,
        this.courseId,
        this.userAnswers,
        this.id,
    });

    factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        chapterId: json["chapterId"],
        courseId: json["courseId"],
        userAnswers: json["userAnswers"] == null ? [] : List<UserAnswer>.from(json["userAnswers"].map((x) => UserAnswer.fromJson(x))),
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "courseId": courseId,
        "userAnswers": userAnswers == null ? [] : List<dynamic>.from(userAnswers!.map((x) => x.toJson())),
        "_id": id,
    };
}

class UserAnswer {
    String? questionId;
    int? selectedOptionIndex;
    String? id;

    UserAnswer({
        this.questionId,
        this.selectedOptionIndex,
        this.id,
    });

    factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
        questionId: json["questionId"],
        selectedOptionIndex: json["selectedOptionIndex"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "selectedOptionIndex": selectedOptionIndex,
        "_id": id,
    };
}

class CourseCoin {
    String? courseId;
    int? coins;
    String? id;

    CourseCoin({
        this.courseId,
        this.coins,
        this.id,
    });

    factory CourseCoin.fromJson(Map<String, dynamic> json) => CourseCoin(
        courseId: json["courseId"],
        coins: json["coins"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "coins": coins,
        "_id": id,
    };
}
