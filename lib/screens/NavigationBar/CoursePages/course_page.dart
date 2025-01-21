import 'dart:convert';
import 'package:amset/screens/Course%20Lessons/all_lessons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Models/Course Models/all_course_model.dart';

class CoursePage extends StatefulWidget {
  final String userId; // Pass user ID to filter courses
  final String token; // Pass the token for authorization

  const CoursePage({super.key, required this.userId, required this.token});

  @override
  CoursePageState createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage> {
  late Future<List<Course>> _appliedCoursesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _appliedCoursesFuture = fetchAppliedCourses(widget.userId, widget.token);
  }

  Future<List<Course>> fetchAppliedCourses(String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://amset-server.vercel.app/api/course'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final allCourses = AllCoursesModel.fromJson(json.decode(response.body));

        // Filter courses where the logged-in user is in the learners list
        return allCourses.courses
            .where((course) =>
                course.learners.any((learner) => learner.user == userId))
            .toList();
      } else {
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  Future<void> _refreshCourses() async {
    setState(() {
      _appliedCoursesFuture = fetchAppliedCourses(widget.userId, widget.token);
    });
    await _appliedCoursesFuture; // Wait for the future to complete
  }

  void _retryFetch() {
    setState(() {
      _isLoading = true;
      _appliedCoursesFuture =
          fetchAppliedCourses(widget.userId, widget.token).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
        toolbarHeight: 70,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Applied Courses',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: _refreshCourses, // Replace the default RefreshIndicator
          color: const Color.fromRGBO(117, 192, 68, 1),
          backgroundColor: Colors.white,
          height: 68.0,
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 400,
          animSpeedFactor: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder<List<Course>>(
                  future: _appliedCoursesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerEffect();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Check your connection',
                                style: GoogleFonts.dmSans(
                                  fontSize: 18.sp,
                                  letterSpacing: -0.5.w,
                                )),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _retryFetch,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 8.h),
                                backgroundColor:
                                    const Color.fromRGBO(117, 192, 68, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                elevation: 0,
                                shadowColor: Colors.black.withOpacity(0.2),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Retry',
                                      style: GoogleFonts.dmSans(
                                          fontSize: 17,
                                          letterSpacing: -0.5.w,
                                          color: Colors.white),
                                    ),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No applied courses available',
                              style: GoogleFonts.dmSans(
                                fontSize: 18.sp,
                                letterSpacing: -0.5.w,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: _refreshCourses,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 10.h),
                                backgroundColor:
                                    const Color.fromRGBO(117, 192, 68, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              child: Text(
                                'Refresh',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  letterSpacing: -0.5.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final course = snapshot.data![index];
                        return CourseCard(course: course);
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

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            height: 170.h,
            width: 344.w,
          ),
        );
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => AllLessonsPage(
              courseId: course.id,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
          color: const Color.fromRGBO(117, 192, 68, 1),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            // Image Container with Black Shade
            Container(
              height: 170.h,
              width: 344.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(course.imageUrl),
                ),
              ),
              child: Stack(
                children: [
                  // Black Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Course Title Positioned at Bottom
                  Positioned(
                    bottom: 15.h,
                    left: 20.w,
                    right: 20.w,
                    child: Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.dmSans(
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
