// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:amset/Models/allCoursesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amset/Pages/course_page.dart';
import 'package:amset/Pages/notification_page.dart';
import 'package:amset/Pages/profile_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
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
        avatarPath: storedAvatarPath ?? widget.avatarPath,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: duplicate_ignore
    // ignore: deprecated_member_use
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
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Color(0xFF006257),
                  ),
                ),
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
          decoration: const BoxDecoration(
            color: Color(0xFF006257),
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
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              tabBackgroundColor: Colors.white,
              activeColor: const Color(0xFF006257),
              color: const Color.fromARGB(255, 255, 255, 255),
              tabs: const [
                GButton(
                  iconSize: 25,
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  iconSize: 25,
                  icon: Icons.menu_book_rounded,
                  text: 'Course',
                ),
                GButton(
                  iconSize: 25,
                  icon: Icons.favorite_rounded,
                  text: 'Favourite',
                ),
                GButton(
                  iconSize: 25,
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

class DashboardPage extends StatefulWidget {
  final String fullName;
  final String avatarPath;

  const DashboardPage(
      {super.key, required this.fullName, required this.avatarPath});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Course>> _futureCourses;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer _timer;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
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

  Future<void> _loadCourses() async {
    setState(() {
      _futureCourses = _fetchCourses();
    });
  }

  Future<List<Course>> _fetchCourses() async {
    try {
      final response = await http
          .get(Uri.parse('https://amset-server.vercel.app/api/course'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AllCoursesModel coursesModel = AllCoursesModel.fromJson(data);
        _hasError = false;
        return coursesModel.courses
            .where((course) => course.isPublished)
            .toList();
      } else {
        _hasError = true;
        throw Exception('Failed to load courses');
      }
    } catch (e) {
      _hasError = true;
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _hasError ? _buildErrorPage() : _buildDashboard(),
    );
  }

  Widget _buildErrorPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 100.r),
          SizedBox(height: 20.h),
          Text('Failed to load courses', style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: _loadCourses,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          centerTitle: true,
          toolbarHeight: 58,
          backgroundColor: const Color(0xFF008172),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' Amset',
                style: TextStyle(
                    fontSize: 25.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.only(top: 20.h),
                height: 120.h,
                width: MediaQuery.of(context).size.width - 40.w,
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
                        image: AssetImage('assets/images/skip1.png'),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('assets/images/skip2.png'),
                        fit: BoxFit.cover,
                      ),
                      Image(
                        image: AssetImage('assets/images/skip3.png'),
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
              SizedBox(height: 30.h),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' Recommended',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20.sp,
                            )),
                        GestureDetector(
                          child: const Text('See All'),
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    FutureBuilder<List<Course>>(
                      future: _futureCourses,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildShimmerEffect(); // Show shimmer effect while loading
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading courses'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No courses available'));
                        } else {
                          final courses = snapshot.data!;
                          return SizedBox(
                            height:
                                224.h, // Fixed height for the horizontal list
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return _buildCourseCard(
                                  context,
                                  course.imageUrl ??
                                      'assets/images/default.png',
                                  course.title,
                                  '${course.chapters.length} Lessons',
                                  course.description ??
                                      'No description available',
                                  'Rs. ${course.price} /-',
                                  index,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(' Explore',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 20.sp,
                            )),
                        GestureDetector(
                          child: const Text('See All'),
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    FutureBuilder<List<Course>>(
                      future: _futureCourses,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildShimmerEffect(); // Show shimmer effect while loading
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading courses'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No courses available'));
                        } else {
                          final courses = snapshot.data!;
                          return SizedBox(
                            height:
                                250.h, // Fixed height for the horizontal list
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return _buildCourseCard(
                                  context,
                                  course.imageUrl ??
                                      'assets/images/default.png',
                                  course.title,
                                  '${course.chapters.length} Lessons',
                                  course.description ??
                                      'No description available',
                                  'Rs. ${course.price} /-',
                                  index,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(' Premium',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 20.sp,
                                )),
                            SizedBox(width: 4.w),
                            const Icon(Icons.workspace_premium_rounded,
                                color: Colors.amber),
                          ],
                        ),
                        GestureDetector(
                          child: const Text('See All'),
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    FutureBuilder<List<Course>>(
                      future: _futureCourses,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildShimmerEffect(); // Show shimmer effect while loading
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error loading courses'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No courses available'));
                        } else {
                          final courses = snapshot.data!;
                          return SizedBox(
                            height:
                                250.h, // Fixed height for the horizontal list
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return _buildCourseCard(
                                  context,
                                  course.imageUrl ??
                                      'assets/images/default.png',
                                  course.title,
                                  '${course.chapters.length} Lessons',
                                  course.description ??
                                      'No description available',
                                  'Rs. ${course.price} /-',
                                  index,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 250.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 180.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ),
        ),
      ),
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
                      SizedBox(height: 80.h),
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
        width: 180.w, // Fixed width for each course card
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120.h, // Fixed height for the image
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
                color: backgroundColor,
                image: DecorationImage(
                  image: imagePath.isNotEmpty
                      ? NetworkImage(imagePath)
                      : const AssetImage('assets/images/default.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.all(0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: const Color(0xff1d1b1e),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.label,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Hypermarket',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.favorite_outline_rounded,
                        color: Color.fromARGB(255, 90, 89, 89),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
