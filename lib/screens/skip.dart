//import 'package:amset/screens/explore.dart';
import 'package:amset/screens/pre_registraion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart'; // Import ScreenUtil

class SkipPage extends StatefulWidget {
  const SkipPage({super.key});

  @override
  State<SkipPage> createState() => _SkipPageState();
}

class _SkipPageState extends State<SkipPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final String image = 'assets/images/skip.svg';
  final String title = 'Welcome to';
  final String subtitle = 'Amset Academy!';
  final String description =
      "Unlock your future with expert-guided courses and guaranteed job placements.";

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const PreregistrationPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
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
                              letterSpacing: -0.5.w,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5.w,
                              color: const Color.fromRGBO(117, 192, 68, 1),
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5.w,
                              fontSize: 15.sp,
                              color: const Color.fromRGBO(58, 66, 72, 0.652),
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 50.h),
                        Container(
                          width: 133.w,
                          height: 45.h,
                          decoration: BoxDecoration(
                            color: _isLoading ? Colors.grey : Colors.black,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: TextButton(
                            onPressed: _onGetStartedPressed,
                            child: _isLoading
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
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
        ),
      ),
    );
  }
}
