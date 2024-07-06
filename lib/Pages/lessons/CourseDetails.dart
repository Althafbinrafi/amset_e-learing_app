// import 'package:flutter/material.dart';
// import 'package:amset/Widgets/video_Player.dart';

// class CourseDetailsPage extends StatefulWidget {
//   const CourseDetailsPage({Key? key}) : super(key: key);

//   @override
//   State<CourseDetailsPage> createState() => _CourseDetailsPageState();
// }

// class _CourseDetailsPageState extends State<CourseDetailsPage> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height / 1.5;

//     return Scaffold(
//       backgroundColor: Color(0xFF006257),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 child: Center(
//                   child: Container(
//                     height: MediaQuery.of(context).size.height / 1,
//                     width: MediaQuery.of(context).size.width / 1,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(18),
//                     ),
//                     child: CoursePlayer(key: UniqueKey()),
//                   ),
//                 ),
//                 color: Color(0xFF006257),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               height: screenHeight,
//               width: screenWidth,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//                 color: Color.fromARGB(255, 255, 255, 255),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(5),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _selectedIndex = 0;
//                             });
//                           },
//                           child: Container(
//                             child: Center(
//                               child: Text(
//                                 'Video Lessons',
//                                 style: TextStyle(
//                                   color: _selectedIndex == 0
//                                       ? Colors.black
//                                       : const Color.fromARGB(
//                                           255, 255, 255, 255),
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                             height: MediaQuery.of(context).size.height / 1,
//                             width: MediaQuery.of(context).size.width / 2.2,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               color: _selectedIndex == 0
//                                   ? Colors.white
//                                   : Colors.transparent,
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _selectedIndex = 1;
//                             });
//                           },
//                           child: Container(
//                             child: Center(
//                               child: Text(
//                                 'Description',
//                                 style: TextStyle(
//                                   color: _selectedIndex == 1
//                                       ? Colors.black
//                                       : const Color.fromARGB(
//                                           255, 255, 255, 255),
//                                   fontSize: 18,
//                                 ),
//                               ),
//                             ),
//                             height: MediaQuery.of(context).size.height / 1,
//                             width: MediaQuery.of(context).size.width / 2.2,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(30),
//                               color: _selectedIndex == 1
//                                   ? Colors.white
//                                   : Colors.transparent,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     height: 55,
//                     width: MediaQuery.of(context).size.width / 1,
//                     decoration: BoxDecoration(
//                       color: Color(0xFF006257),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                   Expanded(
//                     child: _selectedIndex == 0
//                         ? _buildVideoLessonsContent()
//                         : _buildDescriptionContent(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoLessonsContent() {
//     return ListView.builder(
//       itemCount: 7,
//       itemBuilder: (context, index) {
//         return Column(
//           children: [
//             _videoLessonsPlays(context, index + 1),
//             if (index < 6) SizedBox(height: 20),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildDescriptionContent() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Text(
//         'This is the description of the course. It includes details about the course content, '
//         'structure, objectives, and any other relevant information that students need to know.',
//         style: TextStyle(fontSize: 16),
//       ),
//     );
//   }

//   Widget _videoLessonsPlays(BuildContext context, int lessonNumber) {
//     return Container(
//       padding: EdgeInsets.all(15),
//       height: 90,
//       width: MediaQuery.of(context).size.width / 1.12,
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 255, 255, 255),
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Color(0xFF006257),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             spreadRadius: 1,
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 60,
//             width: 60,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(40),
//               color: Color(0xFF006257),
//             ),
//             child: Icon(
//               Icons.play_arrow,
//               size: 40,
//               color: Colors.white,
//             ),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Lesson $lessonNumber',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text('Part $lessonNumber'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:amset/Models/courseFetchModel.dart';
import 'package:flutter/material.dart';
import 'package:amset/Widgets/video_Player.dart';
import 'package:amset/Pages/lessons/all_lessons.dart'; // Assuming AllLessonsPage.dart contains CourseFetchModel and Chapter classes

class CourseDetailsPage extends StatefulWidget {
  final Chapter chapter;

  const CourseDetailsPage({Key? key, required this.chapter}) : super(key: key);

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height / 1.5;

    return Scaffold(
      backgroundColor: Color(0xFF006257),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1,
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: CoursePlayer(
                      key: UniqueKey(),
                      videoUrl: widget.chapter.videoUrl,
                    ),
                  ),
                ),
                color: Color(0xFF006257),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'Video Lessons',
                                style: TextStyle(
                                  color: _selectedIndex == 0
                                      ? Colors.black
                                      : const Color.fromARGB(
                                          255, 255, 255, 255),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 1,
                            width: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  color: _selectedIndex == 1
                                      ? Colors.black
                                      : const Color.fromARGB(
                                          255, 255, 255, 255),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 1,
                            width: MediaQuery.of(context).size.width / 2.2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height: 55,
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: BoxDecoration(
                      color: Color(0xFF006257),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: _selectedIndex == 0
                        ? _buildVideoLessonsContent()
                        : _buildDescriptionContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoLessonsContent() {
    return Center(
      child: CoursePlayer(
        key: UniqueKey(),
        videoUrl: widget.chapter.videoUrl,
      ),
    );
  }

  Widget _buildDescriptionContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        widget.chapter.description,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
