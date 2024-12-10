import 'package:amset/screens/resume_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ApplyNowPage extends StatefulWidget {
  const ApplyNowPage({super.key});

  @override
  State<ApplyNowPage> createState() => _ApplyNowPageState();
}

class _ApplyNowPageState extends State<ApplyNowPage>
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

    _animationController.forward(); // Trigger animation
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card container
                    Container(
                      height: 193.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: const Color.fromARGB(255, 66, 77, 93),
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Title
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

                    // Subtitle
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
                    SizedBox(height: 16),

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
                    SizedBox(height: 24),

                    // Apply Now button
                    GestureDetector(
                      child: Container(
                        width: 159.w,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(46, 53, 58, 1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Apply Now',
                              style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 300),
                            () async {
                          final result = await Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const ResumeUploadPage(),
                              transitionDuration:
                                  Duration.zero, // Transition duration
                              reverseTransitionDuration:
                                  Duration.zero, // Reverse transition duration
                            ),
                          );

                          // Handle result if needed
                          if (result != null) {
                            setState(() {
                              // Update state if necessary
                            });
                          }
                        });
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
