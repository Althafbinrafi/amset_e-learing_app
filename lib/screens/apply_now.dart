import 'package:amset/screens/resume_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplyNowPage extends StatefulWidget {
  const ApplyNowPage({super.key});

  @override
  State<ApplyNowPage> createState() => _ApplyNowPageState();
}

class _ApplyNowPageState extends State<ApplyNowPage> {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card with icon
                Container(
                  // width: 314.w,
                  height: 193.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: const Color.fromARGB(255, 66, 77, 93),
                      width: 1,
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     blurRadius: 10,
                    //     spreadRadius: 1,
                    //     offset: const Offset(0, 4),
                    //   ),
                    // ],
                  ),
                  // child: Center(
                  //   child: CircleAvatar(
                  //     radius: 24,
                  //     backgroundColor: Colors.pink.shade100,
                  //     child: const Text(
                  //       "A",
                  //       style: TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
                SizedBox(height: 16.h),

                // Title and subtitle
                Text(
                  "Senior Accountant Post",
                  style: GoogleFonts.dmSans(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 31.h),
                Text(
                  "LuLu International",
                  style: GoogleFonts.dmSans(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  "Lorem Ipsum has been the industry's standard dummy text ever since the "
                  "1500s, when an unknown printer took a galley of type and scrambled it to "
                  "make a type specimen book.",
                  style: GoogleFonts.dmSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Apply Now button
                GestureDetector(
                  child: Container(
                    width: 159.w,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(46, 53, 58, 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Apply Now',
                          style: GoogleFonts.dmSans(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.5),
                        ),
                        // const SizedBox(
                        //   width: 5,
                        // ),
                        // const Icon(
                        //   Icons.arrow_forward,
                        //   size: 18,
                        //   color: Color.fromARGB(255, 255, 255, 255),
                        // )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResumeUploadPage();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
