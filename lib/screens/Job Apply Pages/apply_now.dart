import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Course Lessons/all_lessons.dart';

class ApplyNowPage extends StatefulWidget {
  final String courseId;

  const ApplyNowPage({super.key, required this.courseId});

  @override
  State<ApplyNowPage> createState() => _ApplyNowPageState();
}

class _ApplyNowPageState extends State<ApplyNowPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;

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

  Future<void> _applyForCourse() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        "https://amset-server.vercel.app/api/course/${widget.courseId}/apply");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      _showBottomDrawer("Error: Authentication token not found.",
          isSuccess: false, isEnrolled: false);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final message =
            jsonResponse['message'] ?? 'Successfully applied for the course';

        _showBottomDrawer(message.toString(),
            isSuccess: true, isEnrolled: false);
      } else if (response.statusCode == 400) {
        final errorResponse = jsonDecode(response.body) as Map<String, dynamic>;
        final message = errorResponse['message'] ?? 'Bad request';

        if (message == "Already enrolled") {
          _showBottomDrawer(
            "You are already enrolled in this course.",
            isSuccess: false,
            isEnrolled: true,
          );
        } else {
          _showBottomDrawer(message, isSuccess: false, isEnrolled: false);
        }
      } else {
        _showBottomDrawer(
          "Error: ${response.statusCode} ${response.reasonPhrase}",
          isSuccess: false,
          isEnrolled: false,
        );
      }
    } catch (error) {
      _showBottomDrawer("Error: $error", isSuccess: false, isEnrolled: false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showBottomDrawer(String message,
      {required bool isSuccess, required bool isEnrolled}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width / 1,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                message,
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  color: isSuccess || isEnrolled ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          AllLessonsPage(
                        courseId: widget.courseId,
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  "View Classes",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: SvgPicture.asset(
                'assets/images/back_btn.svg',
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
                    child: Center(
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 193.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(34),
                                    border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 66, 77, 93),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
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
                                GestureDetector(
                                  onTap: _isLoading ? null : _applyForCourse,
                                  child: Container(
                                    width: 159.w,
                                    height: 40,
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(46, 53, 58, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'Apply Now',
                                              style: GoogleFonts.dmSans(
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: -0.5,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            )))))));
  }
}
