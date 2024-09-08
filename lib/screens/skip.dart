import 'package:amset/screens/explore.dart';
import 'package:amset/screens/preRegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart'; // Import ScreenUtil

class SkipPage extends StatefulWidget {
  const SkipPage({super.key});

  @override
  State<SkipPage> createState() => _SkipPageState();
}

class _SkipPageState extends State<SkipPage> {
  bool _isLoading = false;

  final String image = 'assets/images/skip.svg';
  final String title = 'Welcome to';
  final String subtitle = 'Amset Academy!';
  final String description =
      "Unlock your future with expert-guided courses and guaranteed job placements.";

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const PreregistrationPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                //height: 470.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      image,
                      fit: BoxFit.contain,
                      height: 250.h,
                    ),
                    SizedBox(height: 25.h),
                    Text(
                      title,
                      style: GoogleFonts.dmSans(
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    //SizedBox(height: 10.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.dmSans(
                          color: Color.fromRGBO(117, 192, 68, 1),
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                          fontSize: 15.sp,
                          color: Color.fromRGBO(58, 66, 72, 0.652),
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 50.h),
                    Container(
                      width: 133.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: TextButton(
                        onPressed: _onGetStartedPressed,
                        child: _isLoading
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Get Started',
                                style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
