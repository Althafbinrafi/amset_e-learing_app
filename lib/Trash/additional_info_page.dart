// // To parse this JSON data, do
// //
// //     final coursefetchById = coursefetchByIdFromJson(jsonString);

// import 'dart:convert';

// CoursefetchById coursefetchByIdFromJson(String str) => CoursefetchById.fromJson(json.decode(str));

// String coursefetchByIdToJson(CoursefetchById data) => json.encode(data.toJson());

// class CoursefetchById {
//     Course course;

//     CoursefetchById({
//         required this.course,
//     });

//     factory CoursefetchById.fromJson(Map<String, dynamic> json) => CoursefetchById(
//         course: Course.fromJson(json["course"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "course": course.toJson(),
//     };
// }

// class Course {
//     Id id;
//     String title;
//     bool isPublished;
//     bool deleted;
//     DateTime createdAt;
//     DateTime updatedAt;
//     int v;
//     String imageUrl;
//     int price;
//     String description;
//     int vacancyCount;
//     int coinsOfRecommend;
//     List<ChapterElement> chapters;
//     List<HiringPartner> hiringPartners;
//     List<Learner> learners;

//     Course({
//         required this.id,
//         required this.title,
//         required this.isPublished,
//         required this.deleted,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.v,
//         required this.imageUrl,
//         required this.price,
//         required this.description,
//         required this.vacancyCount,
//         required this.coinsOfRecommend,
//         required this.chapters,
//         required this.hiringPartners,
//         required this.learners,
//     });

//     factory Course.fromJson(Map<String, dynamic> json) => Course(
//         id: idValues.map[json["_id"]]!,
//         title: json["title"],
//         isPublished: json["isPublished"],
//         deleted: json["deleted"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         imageUrl: json["imageUrl"],
//         price: json["price"],
//         description: json["description"],
//         vacancyCount: json["vacancyCount"],
//         coinsOfRecommend: json["coinsOfRecommend"],
//         chapters: List<ChapterElement>.from(json["chapters"].map((x) => ChapterElement.fromJson(x))),
//         hiringPartners: List<HiringPartner>.from(json["hiringPartners"].map((x) => HiringPartner.fromJson(x))),
//         learners: List<Learner>.from(json["learners"].map((x) => Learner.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": idValues.reverse[id],
//         "title": title,
//         "isPublished": isPublished,
//         "deleted": deleted,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "__v": v,
//         "imageUrl": imageUrl,
//         "price": price,
//         "description": description,
//         "vacancyCount": vacancyCount,
//         "coinsOfRecommend": coinsOfRecommend,
//         "chapters": List<dynamic>.from(chapters.map((x) => x.toJson())),
//         "hiringPartners": List<dynamic>.from(hiringPartners.map((x) => x.toJson())),
//         "learners": List<dynamic>.from(learners.map((x) => x.toJson())),
//     };
// }

// class ChapterElement {
//     ChapterChapter chapter;
//     bool isPremium;
//     String id;

//     ChapterElement({
//         required this.chapter,
//         required this.isPremium,
//         required this.id,
//     });

//     factory ChapterElement.fromJson(Map<String, dynamic> json) => ChapterElement(
//         chapter: ChapterChapter.fromJson(json["chapter"]),
//         isPremium: json["isPremium"],
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "chapter": chapter.toJson(),
//         "isPremium": isPremium,
//         "_id": id,
//     };
// }

// class ChapterChapter {
//     List<String> purchasedUsers;
//     String id;
//     String title;
//     bool isPublished;
//     Id? course;
//     int? position;
//     DateTime createdAt;
//     DateTime updatedAt;
//     int v;
//     String? description;
//     List<Question> questions;
//     bool isPremium;

//     ChapterChapter({
//         required this.purchasedUsers,
//         required this.id,
//         required this.title,
//         required this.isPublished,
//         this.course,
//         this.position,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.v,
//         this.description,
//         required this.questions,
//         required this.isPremium,
//     });

//     factory ChapterChapter.fromJson(Map<String, dynamic> json) => ChapterChapter(
//         purchasedUsers: List<String>.from(json["purchasedUsers"].map((x) => x)),
//         id: json["_id"],
//         title: json["title"],
//         isPublished: json["isPublished"],
//         course: idValues.map[json["course"]]!,
//         position: json["position"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//         description: json["description"],
//         questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
//         isPremium: json["isPremium"],
//     );

//     Map<String, dynamic> toJson() => {
//         "purchasedUsers": List<dynamic>.from(purchasedUsers.map((x) => x)),
//         "_id": id,
//         "title": title,
//         "isPublished": isPublished,
//         "course": idValues.reverse[course],
//         "position": position,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "__v": v,
//         "description": description,
//         "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
//         "isPremium": isPremium,
//     };
// }

// enum Id {
//     THE_66402_ED5_BD51825_E9_B605972,
//     THE_664983_A4_CB8_BFFE31_C28_E0_AD,
//     THE_664_B592_D062829_DEC630_B06_A,
//     THE_665_EEF60_B642840_C43193_E16
// }

// final idValues = EnumValues({
//     "66402ed5bd51825e9b605972": Id.THE_66402_ED5_BD51825_E9_B605972,
//     "664983a4cb8bffe31c28e0ad": Id.THE_664983_A4_CB8_BFFE31_C28_E0_AD,
//     "664b592d062829dec630b06a": Id.THE_664_B592_D062829_DEC630_B06_A,
//     "665eef60b642840c43193e16": Id.THE_665_EEF60_B642840_C43193_E16
// });

// class Question {
//     String questionText;
//     List<String> options;
//     int correctAnswerIndex;
//     String id;

//     Question({
//         required this.questionText,
//         required this.options,
//         required this.correctAnswerIndex,
//         required this.id,
//     });

//     factory Question.fromJson(Map<String, dynamic> json) => Question(
//         questionText: json["questionText"],
//         options: List<String>.from(json["options"].map((x) => x)),
//         correctAnswerIndex: json["correctAnswerIndex"],
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "questionText": questionText,
//         "options": List<dynamic>.from(options.map((x) => x)),
//         "correctAnswerIndex": correctAnswerIndex,
//         "_id": id,
//     };
// }

// class HiringPartner {
//     String companyName;
//     String poster;
//     String id;

//     HiringPartner({
//         required this.companyName,
//         required this.poster,
//         required this.id,
//     });

//     factory HiringPartner.fromJson(Map<String, dynamic> json) => HiringPartner(
//         companyName: json["companyName"],
//         poster: json["poster"],
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "companyName": companyName,
//         "poster": poster,
//         "_id": id,
//     };
// }

// class Learner {
//     User user;
//     DateTime joinedOn;
//     String id;

//     Learner({
//         required this.user,
//         required this.joinedOn,
//         required this.id,
//     });

//     factory Learner.fromJson(Map<String, dynamic> json) => Learner(
//         user: User.fromJson(json["user"]),
//         joinedOn: DateTime.parse(json["joinedOn"]),
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "user": user.toJson(),
//         "joinedOn": joinedOn.toIso8601String(),
//         "_id": id,
//     };
// }

// class User {
//     String id;
//     String username;
//     String email;
//     String password;
//     String mobileNumber;
//     bool isAdmin;
//     int v;
//     List<dynamic> courses;
//     DateTime updatedAt;
//     String? image;
//     String? address;
//     String? district;
//     String fullName;
//     String? postOffice;
//     String? pinCode;
//     String? secondaryMobileNumber;
//     List<Answer> answers;
//     List<CompletedChapter> completedChapters;
//     List<CourseCoin> courseCoins;
//     bool deleted;
//     DateTime? createdAt;
//     String? country;
//     String? experience;
//     String? experienceSector;
//     String? bioDescription;
//     String? forgotPasswordToken;
//     DateTime? forgotPasswordTokenExpiry;
//     String? verifyToken;
//     DateTime? verifyTokenExpiry;

//     User({
//         required this.id,
//         required this.username,
//         required this.email,
//         required this.password,
//         required this.mobileNumber,
//         required this.isAdmin,
//         required this.v,
//         required this.courses,
//         required this.updatedAt,
//         this.image,
//         this.address,
//         this.district,
//         required this.fullName,
//         this.postOffice,
//         this.pinCode,
//         this.secondaryMobileNumber,
//         required this.answers,
//         required this.completedChapters,
//         required this.courseCoins,
//         required this.deleted,
//         this.createdAt,
//         this.country,
//         this.experience,
//         this.experienceSector,
//         this.bioDescription,
//         this.forgotPasswordToken,
//         this.forgotPasswordTokenExpiry,
//         this.verifyToken,
//         this.verifyTokenExpiry,
//     });

//     factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["_id"],
//         username: json["username"],
//         email: json["email"],
//         password: json["password"],
//         mobileNumber: json["mobileNumber"],
//         isAdmin: json["isAdmin"],
//         v: json["__v"],
//         courses: List<dynamic>.from(json["courses"].map((x) => x)),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         image: json["image"],
//         address: json["address"],
//         district: json["district"],
//         fullName: json["fullName"],
//         postOffice: json["postOffice"],
//         pinCode: json["pinCode"],
//         secondaryMobileNumber: json["secondaryMobileNumber"],
//         answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
//         completedChapters: List<CompletedChapter>.from(json["completedChapters"].map((x) => completedChapterValues.map[x]!)),
//         courseCoins: List<CourseCoin>.from(json["courseCoins"].map((x) => CourseCoin.fromJson(x))),
//         deleted: json["deleted"],
//         createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
//         country: json["country"],
//         experience: json["experience"],
//         experienceSector: json["experienceSector"],
//         bioDescription: json["bioDescription"],
//         forgotPasswordToken: json["forgotPasswordToken"],
//         forgotPasswordTokenExpiry: json["forgotPasswordTokenExpiry"] == null ? null : DateTime.parse(json["forgotPasswordTokenExpiry"]),
//         verifyToken: json["verifyToken"],
//         verifyTokenExpiry: json["verifyTokenExpiry"] == null ? null : DateTime.parse(json["verifyTokenExpiry"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "username": username,
//         "email": email,
//         "password": password,
//         "mobileNumber": mobileNumber,
//         "isAdmin": isAdmin,
//         "__v": v,
//         "courses": List<dynamic>.from(courses.map((x) => x)),
//         "updatedAt": updatedAt.toIso8601String(),
//         "image": image,
//         "address": address,
//         "district": district,
//         "fullName": fullName,
//         "postOffice": postOffice,
//         "pinCode": pinCode,
//         "secondaryMobileNumber": secondaryMobileNumber,
//         "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
//         "completedChapters": List<dynamic>.from(completedChapters.map((x) => completedChapterValues.reverse[x])),
//         "courseCoins": List<dynamic>.from(courseCoins.map((x) => x.toJson())),
//         "deleted": deleted,
//         "createdAt": createdAt?.toIso8601String(),
//         "country": country,
//         "experience": experience,
//         "experienceSector": experienceSector,
//         "bioDescription": bioDescription,
//         "forgotPasswordToken": forgotPasswordToken,
//         "forgotPasswordTokenExpiry": forgotPasswordTokenExpiry?.toIso8601String(),
//         "verifyToken": verifyToken,
//         "verifyTokenExpiry": verifyTokenExpiry?.toIso8601String(),
//     };
// }

// class Answer {
//     CompletedChapter chapterId;
//     Id courseId;
//     List<UserAnswer> userAnswers;
//     String id;

//     Answer({
//         required this.chapterId,
//         required this.courseId,
//         required this.userAnswers,
//         required this.id,
//     });

//     factory Answer.fromJson(Map<String, dynamic> json) => Answer(
//         chapterId: completedChapterValues.map[json["chapterId"]]!,
//         courseId: idValues.map[json["courseId"]]!,
//         userAnswers: List<UserAnswer>.from(json["userAnswers"].map((x) => UserAnswer.fromJson(x))),
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "chapterId": completedChapterValues.reverse[chapterId],
//         "courseId": idValues.reverse[courseId],
//         "userAnswers": List<dynamic>.from(userAnswers.map((x) => x.toJson())),
//         "_id": id,
//     };
// }

// enum CompletedChapter {
//     THE_6649934776_FFD5_FFA8_C21_D7_C,
//     THE_6649935_C76_FFD5_FFA8_C21_D90,
//     THE_664_A36_E694_C80_B364_C19_A150,
//     THE_6652_E8_BB3_C58_E42650_ADA2_FA,
//     THE_66_FB800_DABFD5_E0_D3_D175_D1_D,
//     THE_675122456_A8_B13_F965_D17_EB4
// }

// final completedChapterValues = EnumValues({
//     "6649934776ffd5ffa8c21d7c": CompletedChapter.THE_6649934776_FFD5_FFA8_C21_D7_C,
//     "6649935c76ffd5ffa8c21d90": CompletedChapter.THE_6649935_C76_FFD5_FFA8_C21_D90,
//     "664a36e694c80b364c19a150": CompletedChapter.THE_664_A36_E694_C80_B364_C19_A150,
//     "6652e8bb3c58e42650ada2fa": CompletedChapter.THE_6652_E8_BB3_C58_E42650_ADA2_FA,
//     "66fb800dabfd5e0d3d175d1d": CompletedChapter.THE_66_FB800_DABFD5_E0_D3_D175_D1_D,
//     "675122456a8b13f965d17eb4": CompletedChapter.THE_675122456_A8_B13_F965_D17_EB4
// });

// class UserAnswer {
//     QuestionId questionId;
//     int selectedOptionIndex;
//     String id;

//     UserAnswer({
//         required this.questionId,
//         required this.selectedOptionIndex,
//         required this.id,
//     });

//     factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
//         questionId: questionIdValues.map[json["questionId"]]!,
//         selectedOptionIndex: json["selectedOptionIndex"],
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "questionId": questionIdValues.reverse[questionId],
//         "selectedOptionIndex": selectedOptionIndex,
//         "_id": id,
//     };
// }

// enum QuestionId {
//     THE_6753_F1_F2516_DBAB95466_F4_A8,
//     THE_675_A648_FF07540389_D5_C3_BD1,
//     THE_675_A6644_F07540389_D5_C4250,
//     THE_675_A664_EF07540389_D5_C42_BD,
//     THE_675_A7049_DD4_F660_D464_F59_CD,
//     THE_67790793_C0000345684_AD1_EC
// }

// final questionIdValues = EnumValues({
//     "6753f1f2516dbab95466f4a8": QuestionId.THE_6753_F1_F2516_DBAB95466_F4_A8,
//     "675a648ff07540389d5c3bd1": QuestionId.THE_675_A648_FF07540389_D5_C3_BD1,
//     "675a6644f07540389d5c4250": QuestionId.THE_675_A6644_F07540389_D5_C4250,
//     "675a664ef07540389d5c42bd": QuestionId.THE_675_A664_EF07540389_D5_C42_BD,
//     "675a7049dd4f660d464f59cd": QuestionId.THE_675_A7049_DD4_F660_D464_F59_CD,
//     "67790793c0000345684ad1ec": QuestionId.THE_67790793_C0000345684_AD1_EC
// });

// class CourseCoin {
//     Id courseId;
//     int coins;
//     String id;

//     CourseCoin({
//         required this.courseId,
//         required this.coins,
//         required this.id,
//     });

//     factory CourseCoin.fromJson(Map<String, dynamic> json) => CourseCoin(
//         courseId: idValues.map[json["courseId"]]!,
//         coins: json["coins"],
//         id: json["_id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "courseId": idValues.reverse[courseId],
//         "coins": coins,
//         "_id": id,
//     };
// }

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//             reverseMap = map.map((k, v) => MapEntry(v, k));
//             return reverseMap;
//     }
// }
