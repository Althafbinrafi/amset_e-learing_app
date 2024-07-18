import 'package:amset/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const LoginPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 500.h,
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
                        SizedBox(height: 20.h),
                        Text(
                          titles[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Divider(
                          color: const Color(0xFF006257),
                          thickness: 3,
                          endIndent: 100.w,
                          indent: 100.w,
                        ),
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
              SizedBox(height: 20.h),
              CircularAvatarIndicator(
                currentPage: _currentPage,
                totalPages: images.length,
              ),
              SizedBox(height: 30.h),
              Container(
                width: 300.w,
                decoration: BoxDecoration(
                  color: _currentPage == images.length - 1
                      ? const Color(0xFF006257)
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextButton(
                  onPressed: _currentPage == images.length - 1
                      ? _onGetStartedPressed
                      : null,
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
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                width: 110.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo1.png',
                      height: 30.h,
                      width: 30.h,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'amset',
                      style: GoogleFonts.prozaLibre(
                        textStyle: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
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
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 10.h,
          width: 10.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? const Color(0xFF006257)
                : const Color(0xFFBDBDBD),
          ),
        );
      }),
    );
  }
}
