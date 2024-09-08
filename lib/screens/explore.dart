import 'dart:async';
import 'package:amset/Api%20Services/jobvacancy_api_services.dart';
import 'package:amset/Models/vacany_model.dart';
import 'package:amset/screens/jobvacancy.dart';
import 'package:amset/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart'; // Import shimmer package

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool _isLoading = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  // Initialize the Future directly here
  final Future<JobVacancyModel?> _jobVacancyFuture = ApiService().fetchJobVacancies();

  @override
  void initState() {
    super.initState();

    // Auto-swipe timer
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  Widget _buildShimmer() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: 9, // Number of shimmer placeholders
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40.sp,
                  width: 40.sp,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 5.h),
                Container(
                  height: 12.sp,
                  width: 60.sp,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(100.0), // Set the height of the AppBar
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          child: AppBar(
            toolbarHeight: 140.h,
            backgroundColor: const Color.fromRGBO(55, 202, 0, 1),
            title: Text(
              ' Explore',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp),
            ),
            actions: [
              Container(
                width: 90.w,
                height: 37,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextButton(
                  onPressed: _onGetStartedPressed,
                  child: _isLoading
                      ? SizedBox(
                          height: 17.h,
                          width: 17.w,
                          child: const CircularProgressIndicator(
                            color: Color.fromRGBO(55, 202, 0, 1),
                          ),
                        )
                      : Text(
                          'Login',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 15.sp,
                          ),
                        ),
                ),
              ),
              SizedBox(
                width: 15.w,
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            // Swiping Container
            SizedBox(
              height: 130.h,
              width: MediaQuery.of(context).size.width / 1.2,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: index == 0
                          ? Colors.blueGrey
                          : index == 1
                              ? const Color.fromARGB(255, 170, 175, 76)
                              : const Color.fromARGB(255, 51, 215, 230),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            // Indicator Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  height: 7.h,
                  width: _currentPage == index ? 19 : 7,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? const Color(0xFF006257)
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                );
              }),
            ),
            SizedBox(height: 23.h),
            Row(children: [
              Text(
                "Job Vacancies",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
              )
            ]),
            SizedBox(
              height: 15.h,
            ),
            // Job Vacancies Grid with Shimmer Effect
            Expanded(
              child: FutureBuilder<JobVacancyModel?>(
                future: _jobVacancyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmer(); // Show shimmer while loading
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Failed to load data.'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final jobVacancies = snapshot.data!.data;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                      ),
                      itemCount: jobVacancies.length,
                      itemBuilder: (BuildContext context, int index) {
                        final job = jobVacancies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const JobVacancyPage();
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  job.imageUrl,
                                  height: 40.sp,
                                  width: 40.sp,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  job.title,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
