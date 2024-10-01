import 'package:amset/Pages/lessons/all_lessons.dart';
import 'package:amset/Widgets/video_Player.dart';
import 'package:flutter/material.dart';
import 'package:amset/Models/course_fetch_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class CourseDetailsPage extends StatefulWidget {
  final Chapter chapter;
  final String courseId;
  final String imageUrl;

  const CourseDetailsPage({
    super.key,
    required this.chapter,
    required this.courseId,
    required this.imageUrl,
  });

  @override
  CourseDetailsPageState createState() => CourseDetailsPageState();
}

class CourseDetailsPageState extends State<CourseDetailsPage> {
  int _selectedIndex = 0;
  late Future<CourseFetchModel> futureCourse;
  ValueNotifier<bool> isFullScreen = ValueNotifier(false);
  String? _currentlyPlayingChapterId; // To track the currently playing chapter

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCourse(widget.courseId);
    _currentlyPlayingChapterId =
        widget.chapter.id; // Set the initial playing chapter
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
        builder: (context) => AllLessonsPage(courseId: widget.courseId),
      ),
    );
    return false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: ValueListenableBuilder<bool>(
            valueListenable: isFullScreen,
            builder: (context, isFullScreen, child) {
              return Stack(
                children: [
                  Column(
                    children: [
                      // Video Player Section
                      Expanded(
                        flex: isFullScreen ? 1 : 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: isFullScreen
                              ? MediaQuery.of(context).size.height
                              : null, // Full height in full-screen
                          color: const Color(0xFF006257),
                          child: AspectRatio(
                            aspectRatio: 16 / 9, // Aspect ratio of the video
                            child: CoursePlayer(
                              videoUrl: widget.chapter.videoUrl,
                              isFullScreen: this.isFullScreen,
                            ),
                          ),
                        ),
                      ),
                      if (!isFullScreen)
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 10.h),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                _buildTabBar(),
                                SizedBox(height: 20.h),
                                Expanded(
                                  child: _selectedIndex == 0
                                      ? FutureBuilder<CourseFetchModel>(
                                          future: futureCourse,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                                  child: Text(
                                                      'No course data found'));
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
                  ),
                  // Full-screen back button
                  if (isFullScreen)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            isFullScreen = false; // Exit full-screen
                          });

                          SystemChrome.setPreferredOrientations(
                            [
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ],
                          );
                        },
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

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(198, 71, 139, 25),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _buildTabItem('Video Lessons', 0),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: _buildTabItem('Description', 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: _selectedIndex == index ? Colors.white : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(vertical: 5.h),
        alignment: Alignment.center,
        child: Text(
          text,
          style: GoogleFonts.dmSans(
            color: _selectedIndex == index ? Colors.black : Colors.white,
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
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
        return _buildLessonContainer(
            context, lessons[index], 'assets/images/default.png');
      },
    );
  }

  Widget _buildLessonContainer(
      BuildContext context, Chapter chapter, String imageUrl) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Set the currently playing chapter ID
            setState(() {
              _currentlyPlayingChapterId = chapter.id; // Mark as playing
            });

            // Navigate to the selected chapter's detail page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CourseDetailsPage(
                    chapter: chapter,
                    courseId: widget.courseId,
                    imageUrl: imageUrl,
                  );
                },
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Row(
              children: [
                Container(
                  height: 62.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      image: NetworkImage(widget.imageUrl),
                      onError: (error, stackTrace) {
                        print('Image load error: $error');
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.dmSans(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Text(
                            'Part ${chapter.position}',
                            style: GoogleFonts.dmSans(fontSize: 13.sp),
                          ),
                          SizedBox(width: 9.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: const Color.fromRGBO(118, 192, 68, 0.234),
                            ),
                            child: Text(
                              'Free',
                              style: GoogleFonts.dmSans(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(118, 192, 68, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Conditionally show "Playing..." or the play button
                _currentlyPlayingChapterId == chapter.id
                    ? Padding(
                        padding: EdgeInsets.only(right: 0.w),
                        child: const Icon(
                          Icons.pause_circle_filled,
                          size: 29,
                          color: Color.fromRGBO(118, 192, 68, 1),
                        )
                        // Text(
                        //   'Playing',
                        //   style: GoogleFonts.dmSans(
                        //     fontSize: 13.sp,
                        //     fontWeight: FontWeight.bold,
                        //     color: const Color(0xFF006257),
                        //   ),
                        // ),
                        )
                    : SvgPicture.asset(
                        'assets/images/play_btn.svg',
                        height: 22.h,
                        width: 22.w,
                      ),
              ],
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Divider(
          color: Colors.grey[300],
          thickness: 1.0,
          height: 19.h,
        ),
      ],
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
