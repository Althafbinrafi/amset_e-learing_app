// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, unused_import, use_super_parameters, library_private_types_in_public_api

import 'dart:developer';

import 'package:amset/Models/myCourseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

// Assuming these pages exist in your project
import 'package:amset/Pages/lessons/CourseDetails.dart';
import 'package:amset/Pages/lessons/all_lessons.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<MyCourseModel> futureCourseData;

  @override
  void initState() {
    super.initState();
    futureCourseData = fetchCourseData();
  }

  Future<MyCourseModel> fetchCourseData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? userId = prefs.getString('user_id');

    if (token == null || userId == null) {
      throw Exception('Token or User ID not found');
    }

    try {
      final response = await http.get(
        Uri.parse('https://amset-server.vercel.app/api/user/data/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return MyCourseModel.fromJson(json.decode(response.body));
      } else {
        log('Failed to load course data. Status code: ${response.statusCode}');
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      log('Error fetching course data: $e');
      throw Exception('Error fetching course data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006257),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF006257),
              child: const Center(
                child: Text(
                  'My Courses',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            height: 0.7.sh, // Using 70% of the screen height
            width: 1.sw, // Using the full screen width
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: FutureBuilder<MyCourseModel>(
              future: futureCourseData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerEffect();
                } else if (snapshot.hasError) {
                  log('Snapshot error: ${snapshot.error}');
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/No connection-bro.svg',
                        height: 200.h,
                        width: 200.w,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text('Check Your Connection !'),
                    ],
                  ));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available'));
                }

                final courseData = snapshot.data!.courseData;

                return ListView.builder(
                  itemCount: courseData.length,
                  itemBuilder: (context, index) {
                    final courseDatum = courseData[index];
                    return Column(
                      children: [
                        _buildCourseContainer(
                          context,
                          courseDatum.course.imageUrl,
                          courseDatum.course.title,
                          'Lessons', // Replace with actual lessons data if available
                          'Duration', // Replace with actual duration data if available
                          double.parse(courseDatum.progressPercentage
                                  .replaceAll('%', '')) /
                              100,
                          courseDatum.progressPercentage,
                          const Color.fromARGB(255, 255, 255, 255),
                          courseDatum.course.id,
                        ),
                        SizedBox(height: 1.h),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  color: Colors.white,
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 100.w,
                        height: 20.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseContainer(
    BuildContext context,
    String imagePath,
    String title,
    String lessons,
    String duration,
    double percent,
    String percentText,
    Color backgroundColor,
    String courseId,
  ) {
    // Convert the percentText to an integer
    int percentValue = double.parse(percentText.replaceAll('%', '')).round();
    String formattedPercentText = '$percentValue%';

    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_course_id', courseId);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AllLessonsPage(courseId: courseId);
        }));
      },
      child: Container(
        padding: EdgeInsets.all(15.w),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(18.r),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imagePath),
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1d1b1e),
                      letterSpacing: 0.3,
                      height: 1.4.h,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120.w,
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 700,
                          lineHeight: 10.h,
                          percent: percent,
                          barRadius: Radius.circular(16.r),
                          progressColor: const Color(0xFF006257),
                          backgroundColor: const Color.fromARGB(56, 0, 98, 86),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(formattedPercentText),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
