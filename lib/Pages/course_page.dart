import 'package:amset/Pages/lessons/CourseDetails.dart';
import 'package:amset/Pages/lessons/all_lessons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height / 1.4;

    return Scaffold(
      backgroundColor: Color(0xFF006257),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  'My Courses',
                  style: TextStyle(fontSize: 28, color: Colors.white),
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
            child: Column(
              children: [
                _buildCourseContainer(
                  context,
                  screenHeight,
                  screenWidth,
                  'assets/images/fasion.png',
                  'Restaurant Operation and Management',
                  '11 Lessons',
                  '6 Hours',
                  0.8,
                  '80%',
                  Colors.orange.shade100,
                ),
                SizedBox(
                  height: 20,
                ),
                _buildCourseContainer(
                  context,
                  screenHeight,
                  screenWidth,
                  'assets/images/mobile.png',
                  'Mobile Retail Excellence',
                  '8 Lessons',
                  '4 Hours',
                  0.6,
                  '60%',
                  Colors.blue.shade100,
                ),
                SizedBox(
                  height: 20,
                ),
                _buildCourseContainer(
                  context,
                  screenHeight,
                  screenWidth,
                  'assets/images/market.png',
                  'Hypermarket Management Mastery',
                  '23 Lessons',
                  '12 Hours',
                  1,
                  '100%',
                  Colors.green.shade100,
                ),
              ],
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
          return AllLessonsPage();
        }));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 130,
        width: screenWidth,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
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
              padding: EdgeInsets.all(10),
              height: screenHeight,
              width: 120,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
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
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: [
                      Icon(Icons.videocam),
                      SizedBox(
                        width: 5,
                      ),
                      Text(lessons),
                      SizedBox(
                        width: 15,
                      ),
                      Icon(Icons.access_time_filled_rounded),
                      SizedBox(
                        width: 5,
                      ),
                      Text(duration),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                          progressColor: Color(0xFF006257),
                          backgroundColor: Color.fromARGB(56, 0, 98, 86),
                        ),
                      ),
                      Text(percentText)
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
