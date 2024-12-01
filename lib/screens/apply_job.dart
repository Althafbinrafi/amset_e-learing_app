// import 'package:flutter/material.dart';

// class JobDetailPage extends StatefulWidget {
//   @override
//   _JobDetailPageState createState() => _JobDetailPageState();
// }

// class _JobDetailPageState extends State<JobDetailPage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     constraints: BoxConstraints(
//                       maxWidth: 400,
//                     ),
//                     child: Column(
//                       children: [
//                         Icon(
//                           Icons.work,
//                           size: 48,
//                           color: Colors.black,
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           "Senior Accountant",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "110+ Vacancies",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.green,
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
//                           "when an unknown printer took a galley of type and scrambled it to make a",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         SizedBox(height: 32),
//                         Container(
//                           height: 169,
//                           width: 276,
//                           child: Stack(
//                             children: [
//                               PageView(
//                                 controller: _pageController,
//                                 onPageChanged: (int page) {
//                                   setState(() {
//                                     _currentPage = page;
//                                   });
//                                 },
//                                 children: [
//                                   _buildSwipeContainer(
//                                       "Container 1", Colors.blue[100]!),
//                                   _buildSwipeContainer(
//                                       "Container 2", Colors.green[100]!),
//                                   _buildSwipeContainer(
//                                       "Container 3", Colors.orange[100]!),
//                                   _buildSwipeContainer(
//                                       "Container 4", Colors.purple[100]!),
//                                 ],
//                               ),
//                               Positioned(
//                                 bottom: 10,
//                                 left: 0,
//                                 right: 0,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: List.generate(
//                                     4,
//                                     (index) => _buildDotIndicator(index),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 32),
//                         Text(
//                           "Hiring Partners",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                         SizedBox(height: 16),
//                         Wrap(
//                           alignment: WrapAlignment.center,
//                           spacing: 16,
//                           runSpacing: 16,
//                           children: [
//                             _buildLogo('assets/nesto.png'),
//                             _buildLogo('assets/geepas.png'),
//                             _buildLogo('assets/lulu.png'),
//                           ],
//                         ),
//                         SizedBox(height: 32),
//                         Center(
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                               ),
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 32, vertical: 12),
//                             ),
//                             onPressed: () {},
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   "Apply For Job",
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 16),
//                                 ),
//                                 SizedBox(width: 8),
//                                 Icon(Icons.arrow_forward, color: Colors.white),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 32),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSwipeContainer(String text, Color color) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         color: color,
//         border: Border.all(
//           color: Colors.grey[300]!,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 1,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.grey[800],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDotIndicator(int index) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 4),
//       width: 8,
//       height: 8,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: _currentPage == index ? Colors.blue : Colors.grey[300],
//       ),
//     );
//   }

//   Widget _buildLogo(String assetPath) {
//     return Container(
//       width: 50,
//       height: 50,
//       child: Image.asset(
//         assetPath,
//         fit: BoxFit.contain,
//         errorBuilder: (context, error, stackTrace) {
//           return Icon(
//             Icons.image_not_supported,
//             size: 50,
//             color: Colors.grey[400],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:amset/screens/apply_now.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class JobDetailPage extends StatelessWidget {
  const JobDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(top: 17.h, left: 20.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF75C044),
                width: 2,
              ),
              color: const Color(0x1A75C044),
            ),
            child: GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF75C044),
                  size: 20,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        leadingWidth: 50.w,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Content with padding
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                  child: Column(
                    children: [
                      SvgPicture.asset('assets/images/job_sector1.svg'),
                      SizedBox(height: 13.h),
                      Text(
                        "Senior Accountant",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "110+ Vacancies",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF75C044),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
                        "when an unknown printer took a galley of type and scrambled it to make a",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          letterSpacing: -0.3,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),

                // Scrollable containers without padding
                SizedBox(
                  height: 169.h,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 32.w),
                        _buildContainer(),
                        _buildContainer(),
                        _buildContainer(),
                        _buildContainer(),
                      ],
                    ),
                  ),
                ),

                // Content with padding continues
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      Text(
                        "Hiring Partners",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          letterSpacing: -0.3,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildLogo('assets/images/nesto.svg'),
                          _buildLogo('assets/images/geepas.svg'),
                          _buildLogo('assets/images/lulu.svg'),
                        ],
                      ),
                      SizedBox(height: 32),
                      GestureDetector(
                        child: Container(
                          width: 175.w,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(46, 53, 58, 1),
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Apply For Job',
                                style: GoogleFonts.dmSans(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.5),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: Color.fromARGB(255, 255, 255, 255),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const ApplyNowPage();
                          }));
                        },
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      width: 276.w,
      margin: EdgeInsets.only(right: 16.r),
      decoration: BoxDecoration(
        //color: ,
        border: Border.all(
          color: const Color.fromARGB(255, 70, 71, 81),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(34),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2),
        //     spreadRadius: 1,
        //     blurRadius: 5,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Center(
          // child: Text(

          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.grey[800],
          //   ),
          // ),
          ),
    );
  }

  Widget _buildLogo(String assetPath) {
    return Container(
      width: 50,
      height: 50,
      child: SvgPicture.asset(
        assetPath,
        fit: BoxFit.contain,
        // placeholderBuilder: (BuildContext context) => Container(
        //   padding: const EdgeInsets.all(10.0),
        //   child: CircularProgressIndicator(),
        // ),
        // errorBuilder: (context, error, stackTrace) {
        //   return Icon(
        //     Icons.image_not_supported,
        //     size: 50,
        //     color: Colors.grey[400],
        //   );
        // },
      ),
    );
  }
}
