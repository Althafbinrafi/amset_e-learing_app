import 'package:amset/Models/course_fetch_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG usage

import 'package:amset/DrawerPages/Course/course_details.dart';

class AllLessonsPage extends StatefulWidget {
  final String courseId;

  const AllLessonsPage({super.key, required this.courseId});

  @override
  AllLessonsPageState createState() => AllLessonsPageState();
}

class AllLessonsPageState extends State<AllLessonsPage> {
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
      backgroundColor: Colors.white, // Background color of the page
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              top: 22, left: 22.w, right: 22.w), // Horizontal padding of 22
          child: FutureBuilder<CourseFetchModel>(
            future: futureCourse,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerEffect();
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons
                            .signal_wifi_statusbar_connected_no_internet_4_rounded,
                        size: 40,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Check Your Connection !',
                        style: GoogleFonts.dmSans(color: Colors.black),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text(
                  'No course data found',
                  style: GoogleFonts.dmSans(color: Colors.black),
                ));
              } else {
                final courseData = snapshot.data!;
                return Column(
                  children: [
                    // Course Image Container with shadow from bottom to top
                    Stack(
                      children: [
                        Container(
                          height: 207.h, // Adjust as needed
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(39),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(courseData.course.imageUrl),
                            ),
                          ),
                        ),
                        // Shadow gradient overlay at the bottom of the image
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(39),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(
                                      0.9), // Transparent at the top
                                  Colors.black.withOpacity(0.1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Title and Play Button in a Row on top of the image
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Course Title inside the image
                              Expanded(
                                child: Text(
                                  courseData.course.title,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 21.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Play Button SVG in row with the title
                              SvgPicture.asset(
                                'assets/images/play_btn.svg', // Path to your play button SVG
                                height: 54.72.h, // Adjust size as needed
                                width: 54.72.w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Lesson List below the image and title
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          width: 1.sw,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                          child: ListView.builder(
                            itemCount: courseData.chapters.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8
                                            .w), // Padding for lesson container
                                    child: _buildLessonContainer(
                                      context,
                                      courseData.chapters[index],
                                      courseData.course
                                          .imageUrl, // Pass the image URL here
                                    ),
                                  ),
                                  if (index < courseData.chapters.length - 1)
                                    SizedBox(height: 5.h),
                                ],
                              );
                            },
                          )),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 35, left: 15.w),
        height: 40.h,
        width: 40.w,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: [
        // Simulating the course image container
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 207.h, // Same as your course image height
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(39),
              color: Colors.white, // Placeholder color
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // Simulating the shimmer effect for lessons list
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            width: 1.sw, // Full screen width
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: ListView.builder(
              itemCount: 6, // Simulating 6 items for loading
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      // Simulating image placeholder for each lesson
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 62.h, // Mimicking the image size
                          width: 90.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),

                      // Simulating text placeholders for lesson titles and description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title placeholder
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            // Subtitle placeholder
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 100.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonContainer(
      BuildContext context, Chapter chapter, String imageUrl) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width, // Full screen width
            // padding: EdgeInsets.only(right: 15, left: 15),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255), // No borders
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     spreadRadius: 1,
              //     blurRadius: 10,
              //   ),
              // ],
            ),
            child: Row(
              children: [
                // Leading image (reusing the course image)
                Container(
                  height: 62.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        10.r), // Slightly rounded corners for the image
                    image: DecorationImage(
                      image: NetworkImage(imageUrl), // Use course image URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                // Chapter Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        chapter.title,
                        maxLines: 2,
                        style: GoogleFonts.dmSans(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                          //overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Part ${chapter.position}',
                            style: GoogleFonts.dmSans(color: Colors.black),
                          ),
                          SizedBox(
                            width: 9.w,
                          ),
                          // Container(
                          //   padding: EdgeInsets.only(right: 3.w, left: 3.w),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(4),
                          //       color:
                          //           const Color.fromRGBO(118, 192, 68, 0.234)),
                          //   child: Text(
                          //     'Free',
                          //     style: GoogleFonts.dmSans(
                          //         fontSize: 11.sp,
                          //         fontWeight: FontWeight.w500,
                          //         color: const Color.fromRGBO(118, 192, 68, 1)),
                          //   ),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
                // Play button SVG at the right end
                SvgPicture.asset(
                  'assets/images/play_btn.svg', // Path to your play button SVG
                  height: 21.h, // Adjust size as needed
                  width: 21.w,
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return CourseDetailsPage(
                chapter: chapter,
                courseId: widget.courseId,
                imageUrl: imageUrl, // Pass the imageUrl here
              );
            }));
          },
        ),
        SizedBox(
          height: 5.h,
        ),
        // Divider after each list item
        Divider(
          color: Colors.grey[300], // Light grey divider color
          thickness: 1.0,
          height: 19.h, // Space between items and divider
        ),
      ],
    );
  }
}
