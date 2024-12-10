import 'package:amset/PostPurchasePages/patment_succeeded_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GetCertifiedPage extends StatefulWidget {
  const GetCertifiedPage({super.key});

  @override
  State<GetCertifiedPage> createState() => _GetCertifiedPageState();
}

class _GetCertifiedPageState extends State<GetCertifiedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/badge_success.svg',
              height: 59.h,
              width: 59.w,
            ),
            SizedBox(
              height: 9.h,
            ),
            Text(
              'amset',
              style: GoogleFonts.dmSans(
                height: 1.h,
                fontSize: 25.sp,
                letterSpacing: -0.3,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'recommended',
              style: GoogleFonts.dmSans(
                height: 0.9.h,
                fontSize: 25.sp,
                letterSpacing: -0.3,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 21.h,
            ),
            Container(
              height: 193.h,
              width: MediaQuery.of(context).size.width / 1,
              margin: EdgeInsets.symmetric(horizontal: 39.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: Color.fromRGBO(46, 53, 58, 1))),
            ),
            SizedBox(
              height: 26.h,
            ),
            GestureDetector(
              child: Container(
                width: 161.w,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 53, 58, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Certified',
                      style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () async {
                  final result = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const PaymentSucceededPage(),
                      transitionDuration: Duration.zero, // Transition duration
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
      )),
    );
  }
}
