import 'package:amset/Models/myCourseModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return MyCourseModel.fromJson(json.decode(response.body));
      } else {
        print(
            'Failed to load course data. Status code: ${response.statusCode}');
        throw Exception('Failed to load course data');
      }
    } catch (e) {
      print('Error fetching course data: $e');
      throw Exception('Error fetching course data');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height / 1.4;

    return Scaffold(
      backgroundColor: const Color(0xFF006257),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: const Center(
                child: Text(
                  'My Courses',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              color: const Color(0xFF006257),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            height: screenHeight,
            width: screenWidth,
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Snapshot error: ${snapshot.error}');
                  return const Center(child: Text('Error loading data'));
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
                          screenHeight,
                          screenWidth,
                          courseDatum.course.imageUrl,
                          courseDatum.course.title,
                          'Lessons', // Replace with actual lessons data if available
                          'Duration', // Replace with actual duration data if available
                          double.parse(courseDatum.progressPercentage
                                  .replaceAll('%', '')) /
                              100,
                          courseDatum.progressPercentage,
                          Colors.orange.shade100,
                        ),
                        const SizedBox(height: 20),
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

  Widget _buildCourseContainer(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    String imagePath,
    String title,
    String lessons,
    String duration,
    double percent,
    String percentText,
    Color backgroundColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const AllLessonsPage();
        }));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 140,
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
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
              padding: const EdgeInsets.all(10),
              height: screenHeight,
              width: 120,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imagePath),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1d1b1e),
                      letterSpacing: 0.3,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(Icons.videocam),
                      const SizedBox(width: 5),
                      Text(lessons),
                      const SizedBox(width: 15),
                      const Icon(Icons.access_time_filled_rounded),
                      const SizedBox(width: 5),
                      Text(duration),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150,
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 700,
                          lineHeight: 10,
                          percent: percent,
                          barRadius: const Radius.circular(16),
                          progressColor: const Color(0xFF006257),
                          backgroundColor: const Color.fromARGB(56, 0, 98, 86),
                        ),
                      ),
                      Text(percentText),
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
