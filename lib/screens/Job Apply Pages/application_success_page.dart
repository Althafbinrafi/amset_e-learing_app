import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplicationSuccessPage extends StatefulWidget {
  const ApplicationSuccessPage({super.key});

  @override
  State<ApplicationSuccessPage> createState() => _ApplicationSuccessPageState();
}

class _ApplicationSuccessPageState extends State<ApplicationSuccessPage>
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
      backgroundColor: const Color(0xFFFFFFFF),
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
        leadingWidth: 55.0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  SvgPicture.asset(
                    'assets/images/success_icon.svg', // Replace with your success icon path
                    height: 66.h,
                    width: 66.w,
                  ),
                  SizedBox(height: 20.h),
                  // Title and Subtitle
                  Text(
                    'Application',
                    style: GoogleFonts.dmSans(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Succeeded',
                    style: GoogleFonts.dmSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Job Details Box
                  Container(
                    width: MediaQuery.of(context).size.width / 1,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                    height: 263.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromRGBO(46, 53, 58, 13),
                          width: 0.3),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      'JOB DETAILS',
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(112, 192, 68, 1),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  // Go to Home Button
                  GestureDetector(
                    child: Container(
                      width: 149.w,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(46, 53, 58, 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Go to Home',
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
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
