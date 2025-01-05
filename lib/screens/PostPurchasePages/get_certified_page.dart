import 'package:amset/screens/PostPurchasePages/patment_succeeded_page.dart';
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
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
              'assets/images/back_btn.svg', // Path to your SVG file
              width: 25,
              height: 25,
            ),
          ),
        ),
        leadingWidth: 55.0,
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
                  border:
                      Border.all(color: const Color.fromRGBO(46, 53, 58, 1))),
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
                  if (!context.mounted) return;
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
