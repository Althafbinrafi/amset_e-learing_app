import 'package:amset/PostPurchasePages/shipping_address_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentSucceededPage extends StatefulWidget {
  const PaymentSucceededPage({super.key});

  @override
  State<PaymentSucceededPage> createState() => _PaymentSucceededPageState();
}

class _PaymentSucceededPageState extends State<PaymentSucceededPage>
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
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(top: 17.h, left: 20.w),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF75C044),
                  width: 2,
                ),
                color: const Color(0x1A75C044),
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF75C044),
                  size: 20,
                ),
              ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                SvgPicture.asset(
                  'assets/images/success_icon.svg', // Replace with your success icon SVG file path
                  height: 66.h,
                  width: 66.w,
                  color: const Color(0xFF75C044),
                ),
                SizedBox(height: 20.h),
                // Title and Subtitle
                Text(
                  'Payment',
                  style: GoogleFonts.dmSans(
                    height: 1.h,
                    fontSize: 25.sp,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  'Succeeded',
                  style: GoogleFonts.dmSans(
                    height: 0.9.h,
                    fontSize: 25.sp,
                    letterSpacing: -0.3,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 23.h),
                // Placeholder for Certificate Area
                Container(
                  height: 193.h,
                  width: MediaQuery.of(context).size.width / 1,
                  margin: EdgeInsets.symmetric(horizontal: 39.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: Color.fromRGBO(46, 53, 58, 1))),
                ),
                SizedBox(height: 23.h),
                // Ship Certificate Button
                GestureDetector(
                  onTap: () {
                    Future.delayed(const Duration(milliseconds: 300), () async {
                      final result = await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              ShippingAddressPage(),
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
                  child: Container(
                    height: 37.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                        color: const Color(0xFFEBF9E7),
                        borderRadius: BorderRadius.circular(39.r),
                        border: Border.all(
                            width: 0.5.w,
                            color: Color.fromRGBO(46, 53, 58, 1))),
                    child: Center(
                      child: Text(
                        'Ship Certificate',
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // E-Certificate Option
                GestureDetector(
                  onTap: () {
                    // Add logic to handle E-Certificate download
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/pdf.svg',
                        height: 16.h,
                        width: 14.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'E-Certificate',
                        style: GoogleFonts.dmSans(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
