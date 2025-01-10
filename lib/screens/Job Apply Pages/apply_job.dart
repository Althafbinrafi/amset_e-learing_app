import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Api Services/jobvacancy_api_services.dart';
import '../../Models/Course Models/course_fetch_model.dart';
import 'apply_now.dart';

class JobDetailPage extends StatefulWidget {
  final String courseId;
  const JobDetailPage({super.key, required this.courseId});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController; // PageController for poster swiping
  Timer? _autoSwipeTimer; // Timer for automatic swiping

  bool _isLoading = true;
  Course? _courseData;
  String? _error;
  int _currentPage = 0; // Keep track of the current page

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchCourseDetails();
    _setupAutoSwipe();
  }

  void _setupAnimations() {
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

  void _setupAutoSwipe() {
    _pageController = PageController(initialPage: 0);

    _autoSwipeTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_courseData != null && _courseData!.hiringPartners.length > 1) {
        // Calculate the next page
        int nextPage = (_currentPage + 1) % _courseData!.hiringPartners.length;

        // Animate to the next page
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );

        // Update the current page
        setState(() {
          _currentPage = nextPage;
        });
      }
    });
  }

  Future<void> _fetchCourseDetails() async {
    try {
      setState(() => _isLoading = true);
      final apiService = ApiService();
      final response = await apiService.fetchCourses();
      final course = response.courses.firstWhere(
        (course) => course.id == widget.courseId,
        orElse: () => throw Exception('Course not found'),
      );

      setState(() {
        _courseData = course;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _autoSwipeTimer?.cancel();
    super.dispose();
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
      body: SafeArea(
        child: _isLoading
            ? _buildShimmerEffect()
            : _error != null
                ? _buildErrorWidget()
                : _buildContent(),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      child: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon shimmer
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 45.h,
                      width: 45.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    // Title shimmer
                    // Container(
                    //   height: 24.h,
                    //   width: 200.w,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(12),
                    //   ),
                    // ),
                    SizedBox(height: 10.h),
                    // Vacancy count shimmer
                    Container(
                      height: 17.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Description shimmer
                    Column(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Container(
                            height: 16.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),

              // Posters shimmer
              SizedBox(
                height: 169.h,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 32.w),
                      ...List.generate(
                        1,
                        (index) => Container(
                          width: 276.w,
                          margin: EdgeInsets.only(right: 16.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(34),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Hiring Partners text shimmer
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 15.h),
                    // Container(
                    //   height: 39.h,
                    //   width: 200.w,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(30.r),
                    //   ),
                    // ),
                    SizedBox(height: 16.h),
                    // Partner logos shimmer
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: List.generate(
                        2,
                        (index) => Container(
                          width: 100.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),
              // Apply button shimmer
              Container(
                width: 175.w,
                height: 45.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $_error'),
          ElevatedButton(
            onPressed: _fetchCourseDetails,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0.w),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/job_sector1.svg',
                        height: 35.h,
                        width: 35.w,
                        placeholderBuilder: (context) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 35.h,
                            width: 35.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 13.h),
                      Text(
                        _courseData?.title ?? "No Title",
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
                        "${_courseData?.vacancyCount ?? 0} Vacancies",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF75C044),
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _courseData?.description ?? "No description available",
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          letterSpacing: -0.3,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                if (_courseData?.hiringPartners.isNotEmpty ?? false)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: SizedBox(
                          height: 169.h,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: _courseData!.hiringPartners.length,
                            onPageChanged: (index) {
                              // Update the current page when the user swipes manually
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return _buildPosterContainer(
                                _courseData!.hiringPartners[index],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Swiping Indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: _courseData!.hiringPartners.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Colors.black,
                          dotColor: Colors.grey[400]!,
                          dotHeight: 8.0,
                          dotWidth: 8.0,
                          expansionFactor: 3,
                          spacing: 4.0,
                        ),
                      ),
                    ],
                  ),
                if (_courseData?.hiringPartners.isNotEmpty ?? false)
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
                        const SizedBox(height: 16),
                        _buildPartnerLogosList(_courseData!.hiringPartners),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            ApplyNowPage(
                          courseId: widget.courseId,
                        ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Container(
                    width: 175.w,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(46, 53, 58, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Apply For Job',
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterContainer(HiringPartner partner) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 12.0), // Padding for each poster
      child: Container(
        width: 276.w,
        // margin: EdgeInsets.only(right: 16.r),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(138, 70, 71, 81),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(34),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  partner.poster,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 24,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.bottomCenter,
              //         end: Alignment.topCenter,
              //         colors: [
              //           Colors.black.withOpacity(0.7),
              //           Colors.transparent,
              //         ],
              //       ),
              //     ),
              //     padding: EdgeInsets.all(16.r),
              //     child: Text(
              //       partner.companyName,
              //       style: GoogleFonts.dmSans(
              //         color: Colors.white,
              //         fontSize: 16.sp,
              //         fontWeight: FontWeight.w500,
              //         letterSpacing: -0.3,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPartnerLogosList(List<HiringPartner> partners) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Horizontal scrolling
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: partners.map((partner) {
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 3.0), // Add spacing between logos
          child: _buildPartnerLogo(partner),
        );
      }).toList(),
    ),
  );
}

Widget _buildPartnerLogo(HiringPartner partner) {
  return Container(
    width: 100.w,
    height: 50.h,
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromARGB(0, 137, 134, 134),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        partner.companyLogo ?? '', // Use empty string if companyLogo is null
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.business),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
            ),
          );
        },
      ),
    ),
  );
}
