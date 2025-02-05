import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'pre_registraion_page.dart';

class SkipController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoading = false.obs;
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  final String image = 'assets/images/skip.svg';
  final String title = 'Welcome to';
  final String subtitle = 'Amset Academy!';
  final String description =
      "Unlock your future with expert-guided courses and guaranteed job placements.";

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

  void onGetStartedPressed() {
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.off(() => const PreregistrationPage());
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class SkipPage extends StatelessWidget {
  const SkipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SkipController controller = Get.put(SkipController());

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
        child: Center(
          child: FadeTransition(
            opacity: controller.fadeAnimation,
            child: SlideTransition(
              position: controller.slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          controller.image,
                          fit: BoxFit.contain,
                          height: 250.h,
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          controller.title,
                          style: GoogleFonts.dmSans(
                              color: Colors.black,
                              letterSpacing: -0.5.w,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          controller.subtitle,
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5.w,
                              color: const Color.fromRGBO(117, 192, 68, 1),
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          controller.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(
                              letterSpacing: -0.5.w,
                              fontSize: 15.sp,
                              color: const Color.fromRGBO(58, 66, 72, 0.652),
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 50.h),
                        Obx(
                          () => Container(
                            width: 133,
                            height: 45,
                            decoration: BoxDecoration(
                              color: controller.isLoading.value
                                  ? Colors.grey
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                            child: TextButton(
                              onPressed: controller.onGetStartedPressed,
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Get Started',
                                      style: GoogleFonts.dmSans(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                            ),
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
      ),
    );
  }
}
