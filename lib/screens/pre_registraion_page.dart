import 'package:amset/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PreregistrationPage extends StatefulWidget {
  const PreregistrationPage({super.key});

  @override
  State<PreregistrationPage> createState() => _PreregistrationPageState();
}

class _PreregistrationPageState extends State<PreregistrationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final String image = 'assets/images/logo1.png';

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
        Tween<double>(begin: 0.0, end: 4.0).animate(_animationController);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo at the top
                  Image.asset(
                    'assets/images/logo1.png', // Replace with your image path
                    height: 37.h,
                    width: 65.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 25.h),

                  // RichText widget
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Transform your\n career with ',
                          style: GoogleFonts.dmSans(
                            textStyle: TextStyle(
                              letterSpacing: -0.5.w,
                              color: Colors.black,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: 'industry\n focused training.',
                          style: GoogleFonts.dmSans(
                            letterSpacing: -0.5.w,
                            textStyle: TextStyle(
                              color: const Color.fromRGBO(117, 192, 68, 1),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Grid with four SVG icons
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 20.h,
                    shrinkWrap: true,
                    children: [
                      _buildSvgItem(
                          'assets/images/select_job.svg', 'Select\n  Job'),
                      _buildSvgItem(
                          'assets/images/trainning.svg', 'Training\nProvided'),
                      _buildSvgItem(
                          'assets/images/certified.svg', '    Get\nCertified'),
                      _buildSvgItem(
                          'assets/images/secure.svg', ' Secure\nYour Job'),
                    ],
                  ),

                  // Next button at the bottom
                  SizedBox(height: 50.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const Registerpage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Container(
                      width: 113.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.dmSans(
                                letterSpacing: -0.5.w,
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            const Icon(
                              Icons.arrow_forward_sharp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Method to build SVG item for grid
Widget _buildSvgItem(String assetPath, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        assetPath,
        height: 40.h,
        width: 40.w,
        // ignore: deprecated_member_use
        color: const Color.fromARGB(
            255, 0, 0, 0), // Optional: apply a color to the SVG
      ),
      SizedBox(height: 10.h),
      Text(
        label,
        style: GoogleFonts.dmSans(
          letterSpacing: -0.5.w,
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}
