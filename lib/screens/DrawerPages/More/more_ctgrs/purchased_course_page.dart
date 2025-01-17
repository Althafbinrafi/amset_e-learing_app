import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Models/Purchase Model/chapter_order_model.dart';

class PurchasedCoursesPage extends StatefulWidget {
  final String userId;

  const PurchasedCoursesPage({
    super.key,
    required this.userId,
  });

  @override
  State<PurchasedCoursesPage> createState() => _PurchasedCoursesPageState();
}

class _PurchasedCoursesPageState extends State<PurchasedCoursesPage> {
  late Future<List<PaymentDetail>> _purchasedDetailsFuture;

  @override
  void initState() {
    super.initState();
    _purchasedDetailsFuture = fetchPaymentDetails(widget.userId);
  }

  Future<String> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please log in.');
      }
      return token;
    } catch (e) {
      throw Exception('Error retrieving token: $e');
    }
  }

  Future<List<PaymentDetail>> fetchPaymentDetails(String userId) async {
    final token = await _getToken();

    try {
      final response = await http.get(
        Uri.parse('https://amset-server.vercel.app/api/order/chapters'),
        headers: {'Authorization': 'Bearer $token'},
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw Exception('Server returned an empty response.');
        }

        final chapterOrder =
            ChapterOrderModel.fromJson(json.decode(response.body));

        final List<PaymentDetail> paymentDetails =
            chapterOrder.data?.paymentDetails ?? [];

        debugPrint('Found ${paymentDetails.length} payment details');
        return paymentDetails;
      } else {
        throw Exception(
            'Failed to fetch payment details: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error fetching payment details: $e');
      throw Exception('Error fetching payment details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Purchase History',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5.w,
          ),
        ),
        centerTitle: true,
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
      body: FutureBuilder<List<PaymentDetail>>(
        future: _purchasedDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                'assets/images/loading2.json',
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load purchased details.\nError: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(fontSize: 16.sp),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No purchased chapters available.',
                style: GoogleFonts.dmSans(fontSize: 16.sp),
              ),
            );
          }

          // Sort the payment details by `createdAt` in descending order
          final paymentDetails = snapshot.data!;
          paymentDetails.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          // final paymentDetails = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: paymentDetails.length,
            itemBuilder: (context, index) {
              final paymentDetail = paymentDetails[index];
              final chapter = paymentDetail.chapter;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      chapter?.title ?? "No Title",
                      style: GoogleFonts.dmSans(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Description
                    // Text(
                    //   'Description: ${chapter?.description ?? "No description available"}',
                    //   style: GoogleFonts.dmSans(
                    //     fontSize: 14.sp,
                    //     color: Colors.grey.shade600,
                    //   ),
                    //   maxLines: 3,
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    // SizedBox(height: 8.h),
                    // Order ID
                    Row(
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Order ID: ${paymentDetail.orderId ?? "Unknown"}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Amount
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Amount: ₹${paymentDetail.amount ?? 0}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // Purchased Date
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Purchased Date: ${paymentDetail.createdAt != null ? "${paymentDetail.createdAt!.day.toString().padLeft(2, '0')}/${paymentDetail.createdAt!.month.toString().padLeft(2, '0')}/${paymentDetail.createdAt!.year}" : "Unknown"}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),
                    // Status
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Status: ${paymentDetail.status ?? "Unknown"}',
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            color: paymentDetail.status == "completed"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
