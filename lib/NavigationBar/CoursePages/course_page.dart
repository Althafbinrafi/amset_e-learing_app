import 'dart:convert';
import 'package:amset/NavigationBar/CoursePages/detailds_course_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amset/Models/allCoursesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  CoursePageState createState() => CoursePageState();
}

class CoursePageState extends State<CoursePage> {
  late Future<List<Course>> _publishedCoursesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _publishedCoursesFuture = fetchPublishedCourses();
  }

  Future<List<Course>> fetchPublishedCourses() async {
    final response =
        await http.get(Uri.parse('https://amset-server.vercel.app/api/course'));
    if (response.statusCode == 200) {
      final allCourses = AllCoursesModel.fromJson(json.decode(response.body));
      return allCourses.courses.where((course) => course.isPublished).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  void _retryFetch() {
    setState(() {
      _isLoading = true;
      _publishedCoursesFuture = fetchPublishedCourses().whenComplete(() {
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
          'Amset Courses',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _publishedCoursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display Shimmer effect while loading
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
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
                    return  Center(
                        child: Text('No published courses available',style: GoogleFonts.dmSans(color: Colors.black),));
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
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Display a fixed number of shimmer items
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
    return Container(
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
          // Image Container with Gradient Overlay
          Container(
            height: 170.h,
            width: 344.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    course.imageUrl ?? 'assets/images/not_found.jpg'),
              ),
            ),
            child: Stack(
              children: [
                // Dark Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Course Title and Play Button
                Positioned(
                  bottom: 15.h,
                  left: 20.w,
                  right: 28.w,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Course Title
                      Expanded(
                        child: Text(
                          course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -1,
                            height: 1.4,
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
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.amber, width: 1),
                            borderRadius: BorderRadius.circular(30)),
                        child: SvgPicture.asset(
                          'assets/images/premium.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Additional Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   '${course.chapters.length} Chapters',
                //   style: TextStyle(fontSize: 14.sp, color: Colors.white),
                // ),
                // SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: \$${course.price}',
                      style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          letterSpacing: -1,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  CourseDetailPageHome(
                                course: course,
                              ),
                              transitionDuration: Duration.zero, // No animation
                              reverseTransitionDuration:
                                  Duration.zero, // No animation on pop
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        //iconColor: Color.fromRGBO(117, 192, 68, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'More Details',
                        style: GoogleFonts.dmSans(
                            letterSpacing: -1,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
