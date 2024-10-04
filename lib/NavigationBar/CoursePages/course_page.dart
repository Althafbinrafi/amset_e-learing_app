import 'dart:convert';
import 'package:amset/NavigationBar/CoursePages/detailds_course_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amset/Models/allCoursesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  late Future<List<Course>> _publishedCoursesFuture;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      appBar: AppBar(
        toolbarHeight: 60,
        // leading: GestureDetector(
        //   child: Icon(Icons.arrow_back_ios_new_rounded),
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        // ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Amset Courses',
          style: GoogleFonts.dmSans(fontSize: 24.sp),
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No published courses available'));
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
                    course.imageUrl ?? 'https://placeholder.com/344x201'),
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
                        Colors.black.withOpacity(0.9),
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
                            letterSpacing: 0.3,
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
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailPageHome(
                              course: course,
                            ),
                          ),
                        );
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
