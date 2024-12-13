import 'dart:convert';
import 'dart:developer';
import 'package:amset/DrawerPages/Course/all_lessons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amset/Models/allCoursesModel.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _createOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      log("Error: Auth token is missing. User may need to log in.");
      return;
    }

    const int maxRetries = 3;
    int retryCount = 0;
    int delay = 2000; // Start with a 2-second delay

    while (retryCount < maxRetries) {
      try {
        final response = await http.post(
          Uri.parse('https://amset-server.vercel.app/api/order/create'),
          body: json.encode({
            'amount': widget.course.price * 100,
            'currency': 'INR',
            'courseId': widget.course.id,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          orderId = data['orderId'];
          openCheckout();
          return; // Exit function on success
        } else {
          log('Failed to create order - Status code: ${response.statusCode}, Body: ${response.body}');
          throw Exception('Failed to create order');
        }
      } catch (e) {
        log('Attempt ${retryCount + 1} failed: $e');
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2; // Exponential backoff
        retryCount++;
      }
    }

    log('Order creation failed after $maxRetries attempts.');
  }

  Future<void> _verifyOrder(String paymentId) async {
    try {
      final response = await http.post(
        Uri.parse('https://amset-server.vercel.app/api/course/order/verify'),
        body: json.encode({
          'orderId': orderId,
          'paymentId': paymentId,
          'courseId': widget.course.id, // Pass course ID for verification
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        log('Order verified and course added to account');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase successful! Course added.')),
        );
      } else {
        throw Exception('Failed to verify order');
      }
    } catch (e) {
      log('Error verifying order: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("Payment Successful");
    _verifyOrder(response.paymentId!); // Verify order with backend
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

  void openCheckout() {
    var options = {
      'key': 'rzp_test_KBl96fHCU3zqGI',
      'amount': widget.course.price * 100, // Amount in paise
      'name': 'Amset Course Purchase',
      'description': widget.course.title,
      'order_id': orderId,
      'prefill': {'contact': '', 'email': ''},
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _showConfirmationDrawer() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm Purchase',
                style: GoogleFonts.dmSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Are you sure you want to purchase \n ${widget.course.title} for \$${widget.course.price}?',
                style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  'Continue to Payment',
                  style: GoogleFonts.dmSans(
                    letterSpacing: -0.5,
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _createOrder(); // First create order
                },
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
        automaticallyImplyLeading: false,
        toolbarHeight: 67,
        leading: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: const Icon(Icons.arrow_back_ios_new_rounded),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Courses Details',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
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
                        image: NetworkImage(widget.course.imageUrl ??
                            'https://placeholder.com/344x201'),
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
                        'Chapters:',
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
                        itemCount: widget.course.chapters.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              widget.course.chapters[index].title,
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
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255)),
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
          // _showConfirmationDrawer,
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
                    color: Colors.white),
              ),
              const SizedBox(width: 10),
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   child: SvgPicture.asset('assets/images/premium.svg',
              //       width: 20.w,
              //       height: 20.h,
              //       colorFilter: const ColorFilter.mode(
              //         Colors.white,
              //         BlendMode.srcIn,
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
