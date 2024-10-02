import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amset/screens/dashboard.dart'; // Import Dashboard
import 'package:amset/screens/skip.dart'; // Import SkipPage or LoginPage if needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final String image = 'assets/images/splash.svg';

  @override
  void initState() {
    super.initState();
    // Start the timer for 2 seconds before checking login status
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Simulate the splash screen delay for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is logged in by retrieving the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? fullName = prefs.getString('email');
    String? avatarPath = prefs.getString('avatar_path');

    if (token != null && fullName != null && avatarPath != null) {
      // If token exists, navigate to the Dashboard
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => Dashboard(
           // fullName: fullName,
           // avatarPath: avatarPath,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      // If token doesn't exist, navigate to SkipPage (or LoginPage)
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const SkipPage(), // or LoginPage
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    }
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
