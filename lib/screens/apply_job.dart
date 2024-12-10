import 'package:amset/screens/apply_now.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class JobDetailPage extends StatefulWidget {
  const JobDetailPage({super.key});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage>
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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Content with padding
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/images/job_sector1.svg'),
                          SizedBox(height: 13.h),
                          Text(
                            "Senior Accountant",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "110+ Vacancies",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF75C044),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
                            "when an unknown printer took a galley of type and scrambled it to make a",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.sp,
                              letterSpacing: -0.3,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),

                    // Scrollable containers without padding
                    SizedBox(
                      height: 169.h,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(width: 32.w),
                            _buildContainer(),
                            _buildContainer(),
                            _buildContainer(),
                            _buildContainer(),
                          ],
                        ),
                      ),
                    ),

                    // Content with padding continues
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                      child: Column(
                        children: [
                          SizedBox(height: 15.h),
                          Text(
                            "Hiring Partners",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              letterSpacing: -0.3,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              _buildLogo('assets/images/nesto.svg'),
                              _buildLogo('assets/images/geepas.svg'),
                              _buildLogo('assets/images/lulu.svg'),
                            ],
                          ),
                          SizedBox(height: 32),
                          GestureDetector(
                            child: Container(
                              width: 175.w,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(46, 53, 58, 1),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Apply For Job',
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
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            ApplyNowPage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ));
                            },
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer() {
    return Container(
      width: 276.w,
      margin: EdgeInsets.only(right: 16.r),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 70, 71, 81),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Center(),
    );
  }

  Widget _buildLogo(String assetPath) {
    return SizedBox(
      width: 50,
      height: 50,
      child: SvgPicture.asset(
        assetPath,
        fit: BoxFit.contain,
      ),
    );
  }
}
