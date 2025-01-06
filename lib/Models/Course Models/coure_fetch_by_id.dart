import 'dart:convert';

CoureFetchById coureFetchByIdFromJson(String str) =>
    CoureFetchById.fromJson(json.decode(str));

String coureFetchByIdToJson(CoureFetchById data) => json.encode(data.toJson());

class CoureFetchById {
  Course course;

  CoureFetchById({required this.course});

  factory CoureFetchById.fromJson(Map<String, dynamic> json) => CoureFetchById(
        course: Course.fromJson(json["course"]),
      );

  Map<String, dynamic> toJson() => {
        "course": course.toJson(),
      };
}

class Course {
  String id;
  String title;
  bool? isPublished; // Nullable
  bool? deleted; // Nullable
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String description;
  String imageUrl;
  int price;
  int vacancyCount;
  int coinsOfRecommend;
  List<ChapterElement> chapters;

  Course({
    required this.id,
    required this.title,
    this.isPublished, // Nullable
    this.deleted, // Nullable
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.vacancyCount,
    required this.coinsOfRecommend,
    required this.chapters,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["_id"] ?? "",
        title: json["title"] ?? "Untitled Course",
        isPublished: json["isPublished"], // Directly assign nullable value
        deleted: json["deleted"], // Directly assign nullable value
        createdAt: DateTime.parse(
            json["createdAt"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updatedAt"] ?? DateTime.now().toIso8601String()),
        v: json["__v"] ?? 0,
        description: json["description"] ?? "No description available.",
        imageUrl: json["imageUrl"] ?? "",
        price: json["price"] ?? 0,
        vacancyCount: json["vacancyCount"] ?? 0,
        coinsOfRecommend: json["coinsOfRecommend"] ?? 0,
        chapters: (json["chapters"] as List<dynamic>?)
                ?.map((x) => ChapterElement.fromJson(x))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "isPublished": isPublished,
        "deleted": deleted,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "description": description,
        "imageUrl": imageUrl,
        "price": price,
        "vacancyCount": vacancyCount,
        "coinsOfRecommend": coinsOfRecommend,
        "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
      };
}

class ChapterElement {
  ChapterChapter chapter;
  bool isPremium;
  String id;
  final List<String> purchasedUsers; // Add this field

  ChapterElement({
    required this.chapter,
    required this.isPremium,
    required this.id,
    required this.purchasedUsers,
  });

  factory ChapterElement.fromJson(Map<String, dynamic> json) => ChapterElement(
        chapter: ChapterChapter.fromJson(json["chapter"]),
        isPremium: json["isPremium"],
        id: json["_id"],
        purchasedUsers: List<String>.from(json['purchasedUsers'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "chapter": chapter.toJson(),
        "isPremium": isPremium,
        "_id": id,
      };
}

class ChapterChapter {
  String id;
  String title;
  bool? isPublished; // Nullable
  String? course;
  int? position;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? description;
  String? videoUrl;
  List<Question> questions;
  bool? isPremium; // Nullable

  ChapterChapter({
    required this.id,
    required this.title,
    this.isPublished, // Nullable
    this.course,
    this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.description,
    this.videoUrl,
    required this.questions,
    this.isPremium, // Nullable
  });

  factory ChapterChapter.fromJson(Map<String, dynamic> json) => ChapterChapter(
        id: json["_id"] ?? "",
        title: json["title"] ?? "Untitled Chapter",
        isPublished: json["isPublished"], // Directly assign nullable value
        course: json["course"],
        position: json["position"],
        createdAt: DateTime.parse(
            json["createdAt"] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json["updatedAt"] ?? DateTime.now().toIso8601String()),
        v: json["__v"] ?? 0,
        description: json["description"],
        videoUrl: json["videoUrl"],
        questions: (json["questions"] as List<dynamic>?)
                ?.map((x) => Question.fromJson(x))
                .toList() ??
            [],
        isPremium: json["isPremium"], // Directly assign nullable value
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
        "videoUrl": videoUrl,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "isPremium": isPremium,
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
  String companyLogo;
  String poster;
  String id;

  HiringPartner({
    required this.companyName,
    required this.companyLogo,
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
  User user;
  DateTime joinedOn;
  String id;

  Learner({
    required this.user,
    required this.joinedOn,
    required this.id,
  });

  factory Learner.fromJson(Map<String, dynamic> json) => Learner(
        user: User.fromJson(json["user"]),
        joinedOn: DateTime.parse(json["joinedOn"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "joinedOn": joinedOn.toIso8601String(),
        "_id": id,
      };
}

class User {
  String id;
  String fullName;
  String username;
  String email;
  String password;
  String mobileNumber;
  bool isAdmin;
  String? bioDescription; // Nullable
  List<dynamic> courses;
  bool deleted;
  String? image; // Nullable
  String? forgotPasswordToken; // Nullable
  DateTime? forgotPasswordTokenExpiry; // Nullable
  String? verifyToken; // Nullable
  DateTime? verifyTokenExpiry; // Nullable
  String? address; // Nullable
  String? postOffice; // Nullable
  String? district; // Nullable
  String? pinCode; // Nullable
  String? country; // Nullable
  String? experience; // Nullable
  String? experienceSector; // Nullable
  String? secondaryMobileNumber; // Nullable
  int v;
  DateTime updatedAt;
  List<Answer> answers;
  List<String> completedChapters;
  List<CourseCoin> courseCoins;
  DateTime? createdAt; // Nullable

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.mobileNumber,
    required this.isAdmin,
    this.bioDescription,
    required this.courses,
    required this.deleted,
    this.image,
    this.forgotPasswordToken,
    this.forgotPasswordTokenExpiry,
    this.verifyToken,
    this.verifyTokenExpiry,
    this.address,
    this.postOffice,
    this.district,
    this.pinCode,
    this.country,
    this.experience,
    this.experienceSector,
    this.secondaryMobileNumber,
    required this.v,
    required this.updatedAt,
    required this.answers,
    required this.completedChapters,
    required this.courseCoins,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        fullName: json["fullName"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        mobileNumber: json["mobileNumber"],
        isAdmin: json["isAdmin"],
        bioDescription: json["bioDescription"],
        courses: List<dynamic>.from(json["courses"].map((x) => x)),
        deleted: json["deleted"],
        image: json["image"],
        forgotPasswordToken: json["forgotPasswordToken"],
        forgotPasswordTokenExpiry: json["forgotPasswordTokenExpiry"] == null
            ? null
            : DateTime.parse(json["forgotPasswordTokenExpiry"]),
        verifyToken: json["verifyToken"],
        verifyTokenExpiry: json["verifyTokenExpiry"] == null
            ? null
            : DateTime.parse(json["verifyTokenExpiry"]),
        address: json["address"],
        postOffice: json["postOffice"],
        district: json["district"],
        pinCode: json["pinCode"],
        country: json["country"],
        experience: json["experience"],
        experienceSector: json["experienceSector"],
        secondaryMobileNumber: json["secondaryMobileNumber"],
        v: json["__v"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        completedChapters:
            List<String>.from(json["completedChapters"].map((x) => x)),
        courseCoins: List<CourseCoin>.from(
            json["courseCoins"].map((x) => CourseCoin.fromJson(x))),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "username": username,
        "email": email,
        "password": password,
        "mobileNumber": mobileNumber,
        "isAdmin": isAdmin,
        "bioDescription": bioDescription,
        "courses": List<dynamic>.from(courses.map((x) => x)),
        "deleted": deleted,
        "image": image,
        "forgotPasswordToken": forgotPasswordToken,
        "forgotPasswordTokenExpiry":
            forgotPasswordTokenExpiry?.toIso8601String(),
        "verifyToken": verifyToken,
        "verifyTokenExpiry": verifyTokenExpiry?.toIso8601String(),
        "address": address,
        "postOffice": postOffice,
        "district": district,
        "pinCode": pinCode,
        "country": country,
        "experience": experience,
        "experienceSector": experienceSector,
        "secondaryMobileNumber": secondaryMobileNumber,
        "__v": v,
        "updatedAt": updatedAt.toIso8601String(),
        "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
        "completedChapters":
            List<dynamic>.from(completedChapters.map((x) => x)),
        "courseCoins": List<dynamic>.from(courseCoins.map((x) => x.toJson())),
        "createdAt": createdAt?.toIso8601String(),
      };
}

class Answer {
  String chapterId;
  String courseId;
  List<UserAnswer> userAnswers;
  String id;

  Answer({
    required this.chapterId,
    required this.courseId,
    required this.userAnswers,
    required this.id,
  });

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        chapterId: json["chapterId"],
        courseId: json["courseId"],
        userAnswers: List<UserAnswer>.from(
            json["userAnswers"].map((x) => UserAnswer.fromJson(x))),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "chapterId": chapterId,
        "courseId": courseId,
        "userAnswers": List<dynamic>.from(userAnswers.map((x) => x.toJson())),
        "_id": id,
      };
}

class UserAnswer {
  String questionId;
  int selectedOptionIndex;
  String id;

  UserAnswer({
    required this.questionId,
    required this.selectedOptionIndex,
    required this.id,
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
  String courseId;
  int coins;
  String id;

  CourseCoin({
    required this.courseId,
    required this.coins,
    required this.id,
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
