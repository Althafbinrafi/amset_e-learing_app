import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../Reg and Log/register_page.dart';

class PreregistrationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() {
    super.onInit();
    _setupAnimations();
  }

  void _setupAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutCubic),
    );
    animationController.forward();
  }

  void goToRegisterPage() {
    Get.to(() => const RegisterPage(), transition: Transition.fade);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class PreregistrationPage extends StatelessWidget {
  const PreregistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PreregistrationController controller =
        Get.put(PreregistrationController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.w),
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: SlideTransition(
              position: controller.slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo1.png',
                    height: 37.h,
                    width: 65.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 25.h),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Transform your\n career with ',
                          style: GoogleFonts.dmSans(
                            textStyle: TextStyle(
                              letterSpacing: -0.5.w,
                              color: Colors.black,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: 'industry\n focused training.',
                          style: GoogleFonts.dmSans(
                            letterSpacing: -0.5.w,
                            textStyle: TextStyle(
                              color: const Color.fromRGBO(117, 192, 68, 1),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 20.h,
                    shrinkWrap: true,
                    children: [
                      _buildSvgItem(
                          'assets/images/select_job.svg', 'Select\n  Job'),
                      _buildSvgItem(
                          'assets/images/trainning.svg', 'Training\nProvided'),
                      _buildSvgItem(
                          'assets/images/certified.svg', '    Get\nCertified'),
                      _buildSvgItem(
                          'assets/images/secure.svg', ' Secure\nYour Job'),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  GestureDetector(
                    onTap: controller.goToRegisterPage,
                    child: Container(
                      width: 113.w,
                      height: 45.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: GoogleFonts.dmSans(
                                letterSpacing: -0.5.w,
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            const Icon(
                              Icons.arrow_forward_sharp,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSvgItem(String assetPath, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        assetPath,
        height: 40.h,
        width: 40.w,
        color: Colors.black,
      ),
      SizedBox(height: 10.h),
      Text(
        label,
        style: GoogleFonts.dmSans(
          letterSpacing: -0.5.w,
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}
