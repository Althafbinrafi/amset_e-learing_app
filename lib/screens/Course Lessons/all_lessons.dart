import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Models/Course Models/coure_fetch_by_id.dart';
import 'course_details.dart';

class AllLessonsPage extends StatefulWidget {
  final String courseId;

  const AllLessonsPage({super.key, required this.courseId});

  @override
  State<AllLessonsPage> createState() => _AllLessonsPageState();
}

class _AllLessonsPageState extends State<AllLessonsPage> {
  late Future<CoureFetchById> futureCourse;
  late Razorpay _razorpay;
  late String userId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _initializeUser();
    _loadCourse(widget.courseId);
  }

  Future<void> _initializeUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? ''; // Save userId for later use
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _loadCourse(String courseId) {
    setState(() {
      futureCourse = fetchCourse(courseId);
    });
  }

  Future<CoureFetchById> fetchCourse(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found. Please log in.');
      }

      final response = await http.get(
        Uri.parse('https://amset-server.vercel.app/api/course/$courseId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        return CoureFetchById.fromJson(decodedResponse);
      } else {
        throw Exception('Failed to fetch course data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching course: $e');
      rethrow;
    }
  }

  Future<void> _handlePurchase(String chapterId, double amount) async {
    if (!mounted) return;

    final confirm = await _showConfirmationDialog(amount);
    if (!confirm) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      final response = await http.post(
        Uri.parse(
            'https://amset-server.vercel.app/api/order/chapter/$chapterId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'amount': amount}),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        final options = {
          'key': 'rzp_test_cE8SRoaGo1LWRd',
          'amount': data['amount'],
          'currency': 'INR',
          'name': 'amset',
          'description': 'Chapter Purchase',
          'order_id': data['orderId'],
          'prefill': {
            'contact': '1234567890',
            'email': 'example@example.com',
          },
        };

        _razorpay.open(options);
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to initiate payment: $errorMessage');
      }
    } catch (e) {
      debugPrint('Error initiating payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment initiation failed: $e')),
        );
      }
    }
  }

  Future<bool> _showConfirmationDialog(double amount) async {
    return await showModalBottomSheet<bool>(
          context: context,
          isDismissible: true,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Confirm Purchase',
                    style: GoogleFonts.dmSans(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Are you sure you want to purchase this chapter for ₹${amount.toStringAsFixed(2)}?',
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.dmSans(
                            letterSpacing: -0.3,
                            color: Colors.grey,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'Confirm',
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontSize: 16.sp,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ) ??
        false; // Return false if dismissed without selection
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      final verifyResponse = await http.post(
        Uri.parse('https://amset-server.vercel.app/api/order/verify'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'razorpay_payment_id': response.paymentId,
          'razorpay_order_id': response.orderId,
          'razorpay_signature': response.signature,
        }),
      );

      debugPrint('Verify Response: ${verifyResponse.body}');

      if (!mounted) return;

      if (verifyResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment successful!')),
        );

        if (mounted) {
          _loadCourse(widget.courseId); // Reload course data
        }
      } else {
        final errorMessage =
            jsonDecode(verifyResponse.body)['message'] ?? 'Unknown error';
        throw Exception('Payment verification failed: $errorMessage');
      }
    } catch (e) {
      debugPrint('Payment verification error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment verification failed: $e')),
        );
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment failed. Try again.')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('External wallet selected: ${response.walletName}')),
    );
  }

  void _handleChapterNavigation(ChapterElement chapter) {
    final isPurchased =
        chapter.chapter.purchasedUsers?.contains(userId) ?? false;

    if (!isPurchased && chapter.chapter.isPremium == true) {
      _handlePurchase(chapter.chapter.id, 2000); // Assuming the price is 2000
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterPage(
            chapterId: chapter.chapter.id,
            courseId: widget.courseId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 1.h),
        child: FutureBuilder<CoureFetchById>(
          future: futureCourse,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  'assets/images/loading2.json',
                ),
              );
            } else if (snapshot.hasError) {
              debugPrint('Error in FutureBuilder: ${snapshot.error}');
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData) {
              final course = snapshot.data!.course;
              final publishedChapters = List<ChapterElement>.from(
                course.chapters
                    .where((chapter) => chapter.chapter.isPublished == true),
              )..sort((a, b) {
                  final posA = a.chapter.position ?? double.infinity;
                  final posB = b.chapter.position ?? double.infinity;
                  return posA.compareTo(posB);
                });

              return Column(
                children: [
                  Container(
                    height: 207.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(39),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(39),
                            image: DecorationImage(
                              image: NetworkImage(course.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(39),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  course.title,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/images/play_btn.svg',
                                height: 50.h,
                                width: 50.w,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: publishedChapters.isEmpty
                        ? Center(
                            child: Text(
                              'No published chapters available',
                              style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: publishedChapters.length,
                            itemBuilder: (context, index) {
                              final chapter = publishedChapters[index];
                              final chapterTitle = chapter.chapter.title;
                              final chapterImage = course.imageUrl;

                              // Check if the chapter is purchased
                              final isPurchased = chapter.chapter.purchasedUsers
                                      ?.contains(userId) ??
                                  false;

                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () =>
                                        _handleChapterNavigation(chapter),
                                    leading: Container(
                                      height: 62.h,
                                      width: 90.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        image: DecorationImage(
                                          image: chapterImage.isNotEmpty
                                              ? NetworkImage(chapterImage)
                                              : const AssetImage(
                                                      'assets/placeholder.png')
                                                  as ImageProvider<Object>,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      chapterTitle,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Part ${index + 1}',
                                          style: GoogleFonts.dmSans(
                                            fontSize: 14.sp,
                                            color: Colors.grey[600],
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        if (chapter.chapter.isPremium == true &&
                                            isPurchased) // Add "Purchased" text
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.amber),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10.w, right: 10.w),
                                              child: Text(
                                                'Purchased',
                                                style: GoogleFonts.dmSans(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    letterSpacing: -0.5),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (chapter.chapter.isPremium == true &&
                                            !isPurchased) // Show lock if premium and not purchased
                                          Container(
                                            margin: EdgeInsets.only(right: 8.w),
                                            child: const Icon(
                                              Icons.lock,
                                              size: 16,
                                              color: Colors.amber,
                                            ),
                                          ),
                                        SvgPicture.asset(
                                          'assets/images/play_btn.svg',
                                          height: 24.h,
                                          width: 24.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  if (index < publishedChapters.length - 1)
                                    Divider(
                                      height: 1.h,
                                      thickness: 1,
                                      color: Colors.grey[200],
                                      indent: 110.w,
                                      endIndent: 20.w,
                                    ),
                                  SizedBox(height: 5.h),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
