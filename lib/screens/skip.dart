import 'package:amset/screens/explore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Skip Page',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SkipPage(),
        );
      },
    );
  }
}

class SkipPage extends StatefulWidget {
  const SkipPage({super.key});

  @override
  State<SkipPage> createState() => _SkipPageState();
}

class _SkipPageState extends State<SkipPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  final List<String> images = [
    'assets/images/skip1.png',
    'assets/images/skip2.png',
    'assets/images/skip3.png',
  ];

  final List<String> titles = [
    'Find Your Goal',
    'Unlock Your Potential',
    'Achieve Your Dreams',
  ];

  final List<String> descriptions = [
    "Explore Amset to pinpoint your ideal career path in the hypermarket and supermarket industry.",
    "With Amset, unlock the doors to your full potential in the hypermarket and supermarket sectors.",
    "Let Amset be your partner in turning hypermarket and supermarket career dreams into reality.",
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % images.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ExplorePage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 30.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 470.h,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          images[index],
                          fit: BoxFit.contain,
                          height: 300.h,
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          titles[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Divider(
                        //   color: const Color(0xFF006257),
                        //   thickness: 3,
                        //   endIndent: 100.w,
                        //   indent: 100.w,
                        // ),
                        SizedBox(height: 10.h),
                        Text(
                          descriptions[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black.withOpacity(0.52),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 14.h),
              CircularAvatarIndicator(
                currentPage: _currentPage,
                totalPages: images.length,
              ),
              SizedBox(height: 100.h),
              Container(
                width: 300.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF006257),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextButton(
                  onPressed: _onGetStartedPressed,
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                ),
              ),
              // SizedBox(height: 30.h),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 5.h),
              //   width: 110.w,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.r),
              //   ),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Image.asset(
              //       'assets/images/logo1.png',
              //       height: 30.h,
              //       width: 30.h,
              //     ),
              //     SizedBox(width: 5.w),
              //     Text(
              //       'amset',
              //       style: GoogleFonts.prozaLibre(
              //         textStyle: TextStyle(
              //           color: const Color.fromARGB(255, 0, 0, 0),
              //           fontSize: 18.sp,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularAvatarIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const CircularAvatarIndicator({
    required this.currentPage,
    required this.totalPages,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300), // Duration for animation
          curve: Curves.linear, // Animation curve
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 6,
          width: currentPage == index ? 16 : 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: currentPage == index
                ? const Color(0xFF006257)
                : const Color(0xFFBDBDBD),
          ),
        );
      }),
    );
  }
}
