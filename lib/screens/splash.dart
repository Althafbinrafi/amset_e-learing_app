import 'package:amset/screens/skip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String image = 'assets/images/splash.svg';

  @override
  void initState() {
    super.initState();
    // Start the timer for 2 seconds before navigating to SkipPage
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const SkipPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            // This section centers the text vertically
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your Gateway to',
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        letterSpacing: -0.5.w,
                        color: Colors.black,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    'Retail Careers',
                    style: GoogleFonts.dmSans(
                      textStyle: TextStyle(
                        letterSpacing: -0.5.w,
                        color: const Color.fromRGBO(117, 192, 68, 1),
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  //
                  // SizedBox(
                  //   height: 30,
                  //   width: 30,
                  //   child: const CircularProgressIndicator(
                  //     backgroundColor: Color.fromRGBO(117, 192, 68, 1),
                  //     color: Color(0xFF006257), // Color of the indicator
                  //   ),
                  // ),
                ],
              ),
            ),
            // This section keeps the SVG at the bottom center
            SvgPicture.asset(
              image,
              alignment: Alignment.bottomCenter,
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
