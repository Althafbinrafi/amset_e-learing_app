// ignore_for_file: unused_import, file_names, deprecated_member_use

import 'package:amset/Pages/lessons/all_lessons.dart';
import 'package:amset/Widgets/video_Player.dart';
import 'package:flutter/material.dart';
import 'package:amset/Models/courseFetchModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:amset/Pages/lessons/AllLessonsPage.dart'; // Import the AllLessonsPage

class CourseDetailsPage extends StatefulWidget {
  final Chapter chapter;
  final String courseId;

  const CourseDetailsPage(
      {super.key, required this.chapter, required this.courseId});

  @override
  // ignore: library_private_types_in_public_api
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  int _selectedIndex = 0;
  late Future<CourseFetchModel> futureCourse;
  ValueNotifier<bool> isFullScreen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCourse(widget.courseId);
  }

  Future<CourseFetchModel> fetchCourse(String courseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('https://amset-server.vercel.app/api/course/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return CourseFetchModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      throw Exception('Error fetching course data');
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => AllLessonsPage(
                courseId: widget.courseId,
              )),
    );
    return false; // Prevent the default back action
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF006257),
        body: SafeArea(
          child: ValueListenableBuilder<bool>(
            valueListenable: isFullScreen,
            builder: (context, isFullScreen, child) {
              return Column(
                children: [
                  Expanded(
                    flex: isFullScreen ? 1 : 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 18.5.h),
                      color: const Color(0xFF006257),
                      child: CoursePlayer(
                        videoUrl: widget.chapter.videoUrl,
                        isFullScreen: this.isFullScreen,
                      ),
                    ),
                  ),
                  if (!isFullScreen)
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.r),
                            topRight: Radius.circular(30.r),
                          ),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFF006257),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = 0;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                          color: _selectedIndex == 0
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Video Lessons',
                                          style: TextStyle(
                                            color: _selectedIndex == 0
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedIndex = 1;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.r),
                                          color: _selectedIndex == 1
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Description',
                                          style: TextStyle(
                                            color: _selectedIndex == 1
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Expanded(
                              child: _selectedIndex == 0
                                  ? FutureBuilder<CourseFetchModel>(
                                      future: futureCourse,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return const Center(
                                            child: Text(
                                              'Failed to load course data',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        } else if (!snapshot.hasData) {
                                          return const Center(
                                              child:
                                                  Text('No course data found'));
                                        } else {
                                          return _buildLessonsList(
                                              snapshot.data!);
                                        }
                                      },
                                    )
                                  : _buildDescriptionContent(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLessonsList(CourseFetchModel course) {
    final lessons = course.chapters;
    if (lessons.isEmpty) {
      return const Center(child: Text('No lessons available'));
    }
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        return _buildLessonContainer(context, lessons[index]);
      },
    );
  }

  Widget _buildLessonContainer(BuildContext context, Chapter chapter) {
    bool isCurrentChapter =
        chapter.id == widget.chapter.id; // Check if it's the current chapter
    return GestureDetector(
      onTap: isCurrentChapter
          ? null
          : () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return CourseDetailsPage(
                    chapter: chapter, courseId: widget.courseId);
              }));
            },
      child: Container(
        padding: EdgeInsets.all(15.w),
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color.fromARGB(141, 0, 98, 86)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60.h,
              width: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.r),
                color: const Color(0xFF006257),
              ),
              child: isCurrentChapter
                  ? Icon(Icons.pause, size: 35.sp, color: Colors.white)
                  : Icon(Icons.play_arrow, size: 40.sp, color: Colors.white),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  Text('Part ${chapter.position}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionContent() {
    return Padding(
      padding: EdgeInsets.all(16.0.w),
      child: SingleChildScrollView(
        child: Text(
          widget.chapter.description,
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
    );
  }
}
