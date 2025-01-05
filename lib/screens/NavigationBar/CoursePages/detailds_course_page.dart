import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../Models/Course Models/all_course_model.dart';
import '../../Course Lessons/all_lessons.dart';

class CourseDetailPageHome extends StatefulWidget {
  final Course course;

  const CourseDetailPageHome({super.key, required this.course});

  @override
  CourseDetailPageHomeState createState() => CourseDetailPageHomeState();
}

class CourseDetailPageHomeState extends State<CourseDetailPageHome>
    with SingleTickerProviderStateMixin {
  late Razorpay _razorpay;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String? orderId;

  @override
  void initState() {
    super.initState();

    // Razorpay setup
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Animation setup
    _setupAnimations();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _animationController.dispose();
    super.dispose();
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
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("Payment Successful");
    _verifyOrder(response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("Payment Error: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment failed. Please try again.')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet Selected");
  }

  Future<void> _verifyOrder(String paymentId) async {
    try {
      final response = await http.post(
        Uri.parse('https://amset-server.vercel.app/api/course/order/verify'),
        body: json.encode({
          'orderId': orderId,
          'paymentId': paymentId,
          'courseId': widget.course.id,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        log('Order verified and course added to account');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Purchase successful! Course added.')),
          );
        }
      } else {
        throw Exception('Failed to verify order');
      }
    } catch (e) {
      log('Error verifying order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter published chapters
    final publishedChapters = widget.course.chapters
        .where((chapter) => chapter.isPublished == true)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 67,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
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
        centerTitle: true,
        title: Text(
          'Course Details',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.normal,
            letterSpacing: -0.5,
            color: Colors.black,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    height: 200.h,
                    width: MediaQuery.of(context).size.width / 1.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.course.imageUrl),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(26.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course Title
                      Text(
                        widget.course.title,
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: SvgPicture.asset(
                          'assets/images/premium_label.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Course Description
                      Text(
                        widget.course.description.toString(),
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Price
                      Text(
                        'Price: \$${widget.course.price}',
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5,
                          color: const Color.fromARGB(255, 232, 76, 65),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Chapters
                      Text(
                        'Published Chapters:',
                        style: GoogleFonts.dmSans(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: publishedChapters.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              publishedChapters[index].title,
                              style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                letterSpacing: -0.5,
                              ),
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 107, 176, 62),
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF75C044),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AllLessonsPage(
                courseId: widget.course.id,
              );
            }));
          },
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View Classes',
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
