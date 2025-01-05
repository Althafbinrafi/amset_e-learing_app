
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'application_success_page.dart';

class ResumeUploadPage extends StatefulWidget {
  const ResumeUploadPage({super.key});

  @override
  State<ResumeUploadPage> createState() => _ResumeUploadPageState();
}

class _ResumeUploadPageState extends State<ResumeUploadPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
              'assets/images/back_btn.svg', // Path to your SVG file
              width: 25,
              height: 25,
            ),
          ),
        ),
        title: Text(
          'User Details', // The centered title
          style: TextStyle(
            fontSize: 21.sp, // Font size for the title
            fontWeight: FontWeight.normal, // Slightly bold
            letterSpacing: -0.5, // Adjust letter spacing
            color: Colors.black, // Title color
          ),
        ),
        //centerTitle: true,
        leadingWidth: 55.0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // User Info Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name and Email Fields (Left Side)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name Field
                                Text(
                                  'Name',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7.h, horizontal: 15.w),
                                  child: Text(
                                    'Muhammed Althaf PK',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // Email Field
                                Text(
                                  'Email',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7.h, horizontal: 15.w),
                                  child: Text(
                                    'althafbinrafi@gmail.com',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      letterSpacing: -0.3,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w),
                          // Profile Picture (Right Side)
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/images/not_found.jpg',
                                  height: 115.h,
                                  width: 115.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle image change
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF75C044),
                                    ),
                                    padding: const EdgeInsets.all(6.0),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 23,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 38.h),
                    // Resume Upload Section
                    Container(
                      width: MediaQuery.of(context).size.width / 1,
                      height: 255.h,
                      margin: EdgeInsets.symmetric(horizontal: 30.w),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F9F3),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/upload.svg',
                            height: 32.h,
                            width: 27.w,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Upload your\n    Resume',
                            style: GoogleFonts.dmSans(
                                fontSize: 20.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                height: 1.1,
                                letterSpacing: -0.3),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(112, 192, 68, 10),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Color.fromRGBO(112, 192, 68, 15),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              // Handle resume upload
                            },
                            child: Text(
                              'Select',
                              style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  letterSpacing: -0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    // Next Button
                    GestureDetector(
                      child: Container(
                        width: 109.w,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(46, 53, 58, 1),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.5),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const ApplicationSuccessPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
