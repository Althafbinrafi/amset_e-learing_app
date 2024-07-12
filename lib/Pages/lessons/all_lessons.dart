import 'package:amset/Models/courseFetchModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amset/Pages/lessons/CourseDetails.dart';
import 'package:amset/Models/myCourseModel.dart'; // Assuming the model classes are here

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
    print('Token: $token');
    print('Course ID: $courseId');
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

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return CourseFetchModel.fromJson(jsonDecode(response.body));
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
      backgroundColor: Color(0xFF006257),
      body: FutureBuilder<CourseFetchModel>(
        future: futureCourse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            ));
          } else if (snapshot.hasError) {
            print('Snapshot error: ${snapshot.error}');
            return Center(
                child: Text(
              'Failed to load course data',
              style: TextStyle(color: Colors.white),
            ));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No course data found'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            snapshot.data!.course.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.prozaLibre(
                                fontSize: 25, color: Colors.white),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    color: Color(0xFF006257),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
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
                          _buildLessonContainer(
                              context, snapshot.data!.chapters[index]),
                          if (index < snapshot.data!.chapters.length - 1)
                            SizedBox(height: 20),
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
        margin: EdgeInsets.only(top: 20, left: 10),
        height: 40,
        width: 70,
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Text('Back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  Widget _buildLessonContainer(BuildContext context, Chapter chapter) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(15),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Color(0xFF006257),
          ),
          boxShadow: [
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
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Color(0xFF006257),
              ),
              child: Icon(
                Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Part ${chapter.position}'),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CourseDetailsPage(chapter: chapter);
        }));
      },
    );
  }
}
