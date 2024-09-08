import 'package:amset/screens/RegisterPage.dart';
import 'package:amset/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PreregistrationPage extends StatelessWidget {
  const PreregistrationPage({super.key});

  final String image = 'assets/images/logo1.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              // Logo at the top
              Image.asset(
                image,
                height: 37.h,
                width: 65.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 25.h),

              // RichText widget
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Transform your\n career with ',
                      style: GoogleFonts.dmSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextSpan(
                      text: 'industry\n focused training.',
                      style: GoogleFonts.dmSans(
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

              // Grid with four SVG icons
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20.w,
                mainAxisSpacing: 20.h,
                shrinkWrap: true, // Make the GridView take minimal space
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

              // Next button at the bottom
              SizedBox(height: 50.h),
              GestureDetector(
                onTap: () {
                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: Container(
                  width: 113.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400),
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
    );
  }

  // Method to build SVG item for grid
  Widget _buildSvgItem(String assetPath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          assetPath,
          height: 40.h,
          width: 40.w,
          color: Color.fromARGB(
              255, 0, 0, 0), // Optional: apply a color to the SVG
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
