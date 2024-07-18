// ignore_for_file: depend_on_referenced_packages, deprecated_member_use, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';
import 'package:amset/Models/allCoursesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amset/Pages/course_page.dart';
import 'package:amset/Pages/notification_page.dart';
import 'package:amset/Pages/profile_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';

class Dashboard extends StatefulWidget {
  final String fullName;
  final String avatarPath;

  const Dashboard(
      {super.key, required this.fullName, required this.avatarPath});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  final List<Widget> _pages = [
    const DashboardPage(fullName: '', avatarPath: ''),
    const CoursePage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _getFullName();
  }

  Future<void> _getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedFullName = prefs.getString('full_name');
    String? storedAvatarPath = prefs.getString('avatar_path');
    setState(() {
      _pages[0] = DashboardPage(
          fullName: storedFullName ?? widget.fullName,
          avatarPath: storedAvatarPath ?? widget.avatarPath);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Color(0xFF006257),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes',
                    style: TextStyle(
                      color: Color(0xFF006257),
                    )),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          //margin: EdgeInsets.only(bottom: 20.h, left: 30.w, right: 30.w),
          decoration: const BoxDecoration(
            color: Color(0xFF006257),
            //borderRadius: BorderRadius.all(Radius.circular(25.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25.r)),
            child: GNav(
              gap: 5,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              //tabActiveBorder: Border.all(width: 1, color: Colors.white),
              tabBackgroundColor: Colors.white,
              activeColor: const Color(0xFF006257),
              color: const Color.fromARGB(
                  255, 255, 255, 255), // Inactive icon color
              tabs: const [
                GButton(
                  iconSize: 30,
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  iconSize: 30,
                  icon: Icons.menu_book_rounded,
                  text: 'Course',
                ),
                GButton(
                  iconSize: 30,
                  icon: Icons.notifications,
                  text: 'Notification',
                ),
                GButton(
                  iconSize: 30,
                  icon: Icons.account_circle,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

// The rest of the code remains unchanged...

class DashboardPage extends StatefulWidget {
  final String fullName;
  final String avatarPath;

  const DashboardPage(
      {super.key, required this.fullName, required this.avatarPath});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Course>> _futureCourses;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _futureCourses = _fetchCourses();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<List<Course>> _fetchCourses() async {
    final response =
        await http.get(Uri.parse('https://amset-server.vercel.app/api/course'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      AllCoursesModel coursesModel = AllCoursesModel.fromJson(data);
      return coursesModel.courses
          .where((course) => course.isPublished)
          .toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          padding: EdgeInsets.only(top: 60.h, left: 50.w, right: 50.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.r),
              bottomRight: Radius.circular(25.r),
            ),
            gradient: const LinearGradient(
              end: Alignment.centerLeft,
              begin: Alignment.centerRight,
              colors: <Color>[Color(0xFF00C8B2), Color(0xFF008172)],
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20.sp,
                        ),
                      ),
                      Text(
                        widget.fullName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  CircleAvatar(
                    radius: 25.r,
                    backgroundImage: widget.avatarPath.isNotEmpty
                        ? FileImage(File(widget.avatarPath))
                        : const AssetImage('assets/images/man.png')
                            as ImageProvider,
                    onBackgroundImageError: (_, __) {
                      // Provide a fallback for the image
                    },
                  ),
                ],
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 140.h),
                height: 120.h,
                width: MediaQuery.of(context).size.width - 70.w,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: const [
                      Image(
                        image: AssetImage('assets/images/event1.png'),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('assets/images/event2.png'),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('assets/images/event3.png'),
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(3, (int index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    width: _currentPage == index ? 17.w : 7.w,
                    height: 7.h,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFF006257)
                          : const Color(0xFFBDBDBD),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:
                EdgeInsets.only(left: 30.w, right: 30.w, bottom: 0, top: 1.h),
            height: 430.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Text(
                    'Our Courses',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ),
                SizedBox(height: 5.h),
                Expanded(
                  child: FutureBuilder<List<Course>>(
                    future: _futureCourses,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading courses'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No courses available'));
                      } else {
                        final courses = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 1.8,
                          ),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return _buildCourseCard(
                              context,
                              course.imageUrl ?? 'assets/images/default.png',
                              course.title,
                              '${course.chapters.length} Lessons',
                              course.description ?? 'No description available',
                              'Rs. ${course.price} /-',
                              index,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showCourseDrawer(BuildContext context, String title, String lessons,
      String description, String price) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        // ignore: sized_box_for_whitespace
        return Container(
          height: 450.h,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Color.fromARGB(255, 122, 121, 121),
                        endIndent: 150,
                        indent: 150,
                        thickness: 4,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Course Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        description,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '''
                        Course Details:
                        $lessons
                        Fee: $price 
                        ''',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 80.h), // Adjust as needed
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Are You Interested?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF006257),
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFF006257),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: TextButton(
                          onPressed: () => _launchWhatsApp(title),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/whatsapp.svg',
                                color: Colors.white,
                                height: 20.0,
                                width: 20.0,
                                allowDrawingOutsideViewBox: true,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchWhatsApp(String title) async {
    const phoneNumber = '+918089891475';
    final message = '''I am interested in the course,
*"$title"*
How can I know more?
http://amset-client.vercel.app
Amset Academy. ''';
    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCourseCard(BuildContext context, String imagePath, String title,
      String lessons, String description, String price, int index) {
    final List<Color> backgroundColors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.orange.shade100,
    ];

    Color backgroundColor = backgroundColors[index % backgroundColors.length];

    return GestureDetector(
      onTap: () =>
          _showCourseDrawer(context, title, lessons, description, price),
      child: Container(
        padding: EdgeInsets.all(15.w),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        height: 300.h, // Set the height to 300
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Row(
          children: [
            Container(
              width: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                color: backgroundColor,
                image: DecorationImage(
                  image: imagePath.isNotEmpty
                      ? NetworkImage(imagePath)
                      : const AssetImage(
                          'assets/images/default.png',
                        ) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1d1b1e),
                      letterSpacing: 0.3.sp,
                      height: 1.4.h,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.videocam_rounded,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        lessons,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(width: 20.w),
                      const Text(
                        '', // You may update this with actual data
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: const Color(0xFF006257),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
