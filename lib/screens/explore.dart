import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amset/screens/jobvacancy.dart';
import 'package:amset/screens/login.dart';

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

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Standard Fade Transition to Login Page
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

  void _navigateToJobVacancyPage() {
    // Cool Slide Transition to Job Vacancy Page
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const JobVacancyPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.1, 0.0); // Slide from right to left
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    // List of SVG paths
    final List<String> svgImages = [
      'assets/images/food.svg',
      'assets/images/saloon.svg',
      'assets/images/fashion.svg',
      'assets/images/hyper.svg',
      'assets/images/electric.svg',
      'assets/images/IT.svg',
    ];

    final List<String> jobTitles = [
      'Restaurent',
      'Saloon & Spa',
      'Fasion Design',
      'Hypermarket',
      'Electrician',
      'IT Field',
    ];

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
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: _navigateToJobVacancyPage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            svgImages[index],
                            height: 40.sp,
                            width: 40.sp,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            jobTitles[index],
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
