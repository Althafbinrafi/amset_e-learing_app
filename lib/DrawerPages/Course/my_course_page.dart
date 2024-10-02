import 'dart:developer';
import 'package:amset/DrawerPages/Course/all_lessons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:amset/Models/my_course_model.dart';
//import 'package:amset/Pages/lessons/all_lessons.dart';

class MyCoursePage extends StatefulWidget {
  const MyCoursePage({super.key});

  @override
  MyCoursePageState createState() => MyCoursePageState();
}

class MyCoursePageState extends State<MyCoursePage> {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(vertical: 35.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'My Courses',
                      style: GoogleFonts.dmSans(
                          color: Colors.black,
                          fontSize: 27.sp,
                          fontWeight: FontWeight.normal,
                          letterSpacing: -1),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              // Main Content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
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
                          SizedBox(height: 10.h),
                          const Text('Check Your Connection !'),
                        ],
                      ));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.courseData.isEmpty) {
                      return _buildNoCoursesUI(context);
                    }

                    final courseData = snapshot.data!.courseData;

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: courseData.length,
                      itemBuilder: (context, index) {
                        final courseDatum = courseData[index];
                        return Column(
                          children: [
                            _buildCourseContainer(
                              context,
                              courseDatum.course.imageUrl,
                              courseDatum.course.title,
                              double.parse(courseDatum.progressPercentage
                                      .replaceAll('%', '')) /
                                  100,
                              courseDatum.progressPercentage,
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
        ),
      ),
    );
  }

  // Function to build the "No Courses" UI
  Widget _buildNoCoursesUI(BuildContext context) {
    return Center(
      // Wrap everything in a Center widget
      child: ConstrainedBox(
        // Use ConstrainedBox to set a maximum width
        constraints:
            BoxConstraints(maxWidth: 300.w), // Adjust max width as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/empty_courses.svg',
              height: 200.h,
              width: 200.w,
            ),
            SizedBox(height: 20.h),
            Text(
              'No courses available, please purchase one!',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 35.h),
            SizedBox(
              // Wrap button in SizedBox to control its width
              width: MediaQuery.of(context).size.width /
                  1.5, // Make button full width of its container
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/purchasePage');
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                  backgroundColor: const Color.fromRGBO(117, 192, 68, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 0,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: Text(
                  'Purchase Courses',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 100.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
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
    );
  }

  Widget _buildCourseContainer(
    BuildContext context,
    String imagePath,
    String title,
    double percent,
    String percentText,
    String courseId,
  ) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_course_id', courseId);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllLessonsPage(courseId: courseId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
          color: const Color.fromRGBO(117, 192, 68, 1),
          borderRadius: BorderRadius.circular(39.r),
        ),
        child: Column(
          children: [
            // Image Container with Gradient Overlay
            Container(
              height: 201.h,
              width: 344.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(39.r),
                image: DecorationImage(
                  fit: BoxFit.cover, // Fills the entire container
                  image: NetworkImage(imagePath),
                ),
              ),
              child: Stack(
                children: [
                  // Dark Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(39.r),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent, // Fades to transparent
                        ],
                      ),
                    ),
                  ),
                  // Course Title and Play Button (Bottom-aligned inside the image)
                  Positioned(
                    bottom: 15.h,
                    left: 30.w,
                    right: 28.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Course Title
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              fontSize: 21.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 0.3,
                              height: 1.4.h,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // Play Button Icon
                        SvgPicture.asset(
                          'assets/images/play_btn.svg',
                          width: 54.w,
                          height: 54.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Progress Bar and Percentage Text
            Padding(
              padding: EdgeInsets.all(10.w),
              // You can include the progress bar here if needed
            ),
          ],
        ),
      ),
    );
  }
}
