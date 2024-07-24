// ignore_for_file: unnecessary_import, depend_on_referenced_packages, use_super_parameters, library_private_types_in_public_api

import 'package:amset/Models/courseFetchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amset/Pages/lessons/CourseDetails.dart';

class AllLessonsPage extends StatefulWidget {
  final String courseId;

  const AllLessonsPage({Key? key, required this.courseId}) : super(key: key);

  @override
  _AllLessonsPageState createState() => _AllLessonsPageState();
}

class _AllLessonsPageState extends State<AllLessonsPage> {
  late Future<CourseFetchModel> futureCourse;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006257),
      body: FutureBuilder<CourseFetchModel>(
        future: futureCourse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (snapshot.hasError) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Check Your Connection !',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No course data found'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    color: const Color(0xFF006257),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            snapshot.data!.course.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.prozaLibre(
                                fontSize: 25.sp, color: Colors.white),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                  height: 0.7.sh, // Using 70% of the screen height
                  width: 1.sw, // Using the full screen width
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: ListView.builder(
                    itemCount: snapshot.data!.chapters.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildLessonContainer(context,
                              snapshot.data!.chapters[index], widget.courseId),
                          if (index < snapshot.data!.chapters.length - 1)
                            SizedBox(height: 20.h),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 20.h, left: 10.w),
        height: 40.h,
        width: 70.w,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Text('Back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  Widget _buildLessonContainer(
      BuildContext context, Chapter chapter, String courseId) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(15.w),
        height: 90.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: const Color(0xFF006257),
          ),
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
                borderRadius: BorderRadius.circular(40.r),
                color: const Color(0xFF006257),
              ),
              child: const Icon(
                Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return CourseDetailsPage(chapter: chapter, courseId: courseId);
        }));
      },
    );
  }
}
