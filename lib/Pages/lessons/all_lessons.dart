import 'package:amset/Pages/lessons/CourseDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllLessonsPage extends StatelessWidget {
  const AllLessonsPage({Key? key}) : super(key: key);

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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Restaurant Operations and Management',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, color: Colors.white),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(20),
                    //     color: const Color.fromARGB(255, 255, 255, 255),
                    //   ),
                    //   width: MediaQuery.of(context).size.width / 2.4,
                    //   padding: EdgeInsets.all(10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         '7 Lessons',
                    //         style: TextStyle(
                    //             color: const Color.fromARGB(255, 0, 0, 0),
                    //             fontSize: 17),
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //       ),
                    //       Text('4 Hours',
                    //           style: TextStyle(
                    //               color: const Color.fromARGB(255, 0, 0, 0),
                    //               fontSize: 17))
                    //     ],
                    //   ),
                    // )
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
              itemCount: 7,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildLessonContainer(context, index + 1),
                    if (index < 6) SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
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

  Widget _buildLessonContainer(BuildContext context, int lessonNumber) {
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
                    'Introduction to the Course',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Part $lessonNumber')
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CourseDetailsPage();
        }));
      },
    );
  }
}
