import 'package:amset/PostPurchasePages/get_certified_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessPurchasePage extends StatefulWidget {
  const SuccessPurchasePage({super.key});

  @override
  State<SuccessPurchasePage> createState() => _SuccessPurchasePageState();
}

class _SuccessPurchasePageState extends State<SuccessPurchasePage> {
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
              'assets/images/amset_coin.svg',
              height: 52.h,
              width: 52.w,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '1000+',
              style: GoogleFonts.dmSans(
                fontSize: 33.sp,
                letterSpacing: -0.3,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'amset coins',
              style: GoogleFonts.dmSans(
                height: 0.5.h,
                fontSize: 25.sp,
                letterSpacing: -0.3,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            SvgPicture.asset(
              'assets/images/arrow_success.svg',
            ),
            SizedBox(
              height: 30.h,
            ),
            SvgPicture.asset(
              'assets/images/badge_success.svg',
              height: 59.h,
              width: 59.w,
            ),
            SizedBox(
              height: 15.h,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: GoogleFonts.dmSans(
                    color: Colors.black, // Set a base color for all text
                    fontSize: 16.sp, // Set a base font size
                  ),
                  children: [
                    TextSpan(
                      text: 'you have won\n',
                      style: GoogleFonts.dmSans(
                          height: 0.9.h,
                          letterSpacing: -0.5.w,
                          fontWeight: FontWeight.w400,
                          fontSize: 26.sp),
                    ),
                    TextSpan(
                      text: 'amset recommended\n',
                      style: GoogleFonts.dmSans(
                          height: 0.9.h,
                          letterSpacing: -0.5.w,
                          color: const Color.fromRGBO(117, 192, 68, 1),
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w400), // Make this part bold
                    ),
                    TextSpan(
                      text: 'badge',
                      style: GoogleFonts.dmSans(
                          height: 0.9.h,
                          letterSpacing: -0.5.w,
                          fontWeight: FontWeight.w400,
                          fontSize: 26.sp),
                    ),
                  ]),
            ),
            SizedBox(
              height: 19.h,
            ),
            GestureDetector(
              child: Container(
                width: 130.w,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 53, 58, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Color.fromARGB(255, 255, 255, 255),
                    )
                  ],
                ),
              ),
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () async {
                  final result = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const GetCertifiedPage(),
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
