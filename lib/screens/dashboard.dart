import 'dart:async';
import 'package:amset/DrawerPages/Course/my_course_page.dart';
import 'package:amset/Models/allCoursesModel.dart';
import 'package:amset/Models/login_model.dart';
import 'package:amset/NavigationBar/CoursePages/course_page.dart';
import 'package:amset/NavigationBar/JobVacancies/job_vacancy.dart';
import 'package:amset/DrawerPages/Profile/profile_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'dart:developer';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = 'User Name'; // Placeholder for username
  String _mobile = 'Mobile number'; // Placeholder for mobile number

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      log('Token is null.');
      return;
    }

    final url = Uri.parse('https://amset-server.vercel.app/api/user/profile');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      log('Token: $token');
      log('Response status code: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final profileData = profileModelFromJson(response.body);
        setState(() {
          _username = profileData.username ?? 'Unknown User';
          _mobile = profileData.mobileNumber ?? 'No mobile number';

          // Pass username to DashboardPage
          _pages = [
            DashboardPage(
              username: _username,
              mobile: _mobile,
            ), // Pass username here
            const NotificationPage(),
            const CoursePage(),
          ];
        });
      } else if (response.statusCode == 404) {
        log('User profile not found.');
      } else {
        log('Failed to load profile data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_currentIndex == 0) {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Text(
                  'Exit App',
                  style: GoogleFonts.dmSans(
                      fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Are you sure you want to exit the app?',
                  style: GoogleFonts.dmSans(
                    fontSize: 14.sp,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'No',
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        color: const Color(0xFF006257),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Yes',
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        color: const Color(0xFF006257),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            setState(() {
              _currentIndex = 0;
            });
            return false;
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: IndexedStack(
            index: _currentIndex,
            children: _pages.isNotEmpty
                ? _pages
                : [
                    Center(
                      child: Lottie.asset(
                        'assets/images/loading.json', // Path to your Lottie animation file
                        width: 250, // Adjust the width as needed
                        height: 250, // Adjust the height as needed
                        fit: BoxFit
                            .contain, // Adjust to how you want the animation to fit
                      ),
                    ),
                  ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
          endDrawer: _buildDrawer(),
        ));
  }

  AppBar? _buildAppBar() {
    return _currentIndex == 0
        ? AppBar(
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 1),
              child: const Divider(
                color: Color.fromRGBO(213, 215, 216, 1),
              ),
            ),
            toolbarHeight: 85,
            leadingWidth: 154,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: false,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            leading: Padding(
              padding: EdgeInsets.only(left: 32.w),
              child: SvgPicture.asset(
                'assets/images/Dashboard_logo.svg',
                height: 25.h,
                width: 140.w,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: _showCoinDialog,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(213, 215, 216, 1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(21),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/amset_coin.svg',
                        height: 22.h,
                        width: 22.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '126',
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          letterSpacing: -0.5.w,
                        ),
                      ),
                      SizedBox(width: 6.w),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              GestureDetector(
                onTap: _openEndDrawer,
                child: Padding(
                  padding: EdgeInsets.only(right: 23.w),
                  child: CircleAvatar(
                    backgroundImage: const AssetImage('assets/images/man.png'),
                    radius: 19.r,
                  ),
                ),
              ),
            ],
          )
        : null;
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 85.h,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF006257),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        items: [
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? const Color(0xFF006257) : Colors.black,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('assets/images/home_icon.svg'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? const Color(0xFF006257) : Colors.black,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('assets/images/jobs_icon.svg'),
            ),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? const Color(0xFF006257) : Colors.black,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('assets/images/course_icon.svg'),
            ),
            label: 'Course',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 170,
            child: DrawerHeader(
              padding: EdgeInsets.only(left: 15.w),
              decoration: const BoxDecoration(
                color: Color.fromARGB(153, 233, 233, 233),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            const AssetImage('assets/images/man.png'),
                        radius: 30.r,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _username,
                              style: GoogleFonts.dmSans(
                                color: const Color.fromARGB(255, 31, 31, 31),
                                fontSize: 15.sp,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                            Text(
                              _mobile,
                              style: GoogleFonts.dmSans(
                                color: const Color.fromARGB(255, 49, 48, 48),
                                fontSize: 14.sp,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(
              'Profile',
              style: GoogleFonts.dmSans(),
            ),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ProfilePage(
                      //  fullName: '', // Add fullName or get it dynamically

                      username: _username, // Pass the username dynamically
                      mobile: _mobile,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              });
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(
              'My Courses',
              style: GoogleFonts.dmSans(),
            ),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const MyCoursePage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              });
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              'History',
              style: GoogleFonts.dmSans(),
            ),
            onTap: () {
              // Navigate to History page
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Settings',
              style: GoogleFonts.dmSans(),
            ),
            onTap: () {
              // Navigate to Settings page
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  void _showCoinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/amset_coin.svg',
                  height: 60.h,
                  width: 60.w,
                ),
                SizedBox(height: 16.h),
                Text(
                  '126',
                  style: GoogleFonts.dmSans(
                    fontSize: 30.sp,
                    letterSpacing: -0.5.w,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'You can earn more coins by purchasing additional courses!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    letterSpacing: -0.5.w,
                    fontSize: 16.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF75C044),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width / 2, 0),
                  ),
                  child: Text(
                    'Close',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      letterSpacing: -0.5.w,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }
}

class DashboardPage extends StatefulWidget {
  final String username;
  final String mobile;

  const DashboardPage({
    super.key,
    required this.username,
    required this.mobile,
  });

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  late ScrollController _scrollController;
  late Future<List<Course>> _futureCourses;
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: 0);

    _loadCourses();

    // Use a post-frame callback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoPageChange();
    });
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
          // Icon(Icons.error_outline,
          //     color: const Color.fromARGB(255, 114, 113, 113), size: 50.r),
          // SizedBox(height: 20.h),
          Text('Check Your Connection',
              style: GoogleFonts.dmSans(
                fontSize: 18.sp,
                letterSpacing: -0.5.w,
              )),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: _loadCourses,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
              backgroundColor:
                  const Color.fromRGBO(117, 192, 68, 1), // Use custom color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 0,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.dmSans(
                  fontSize: 17, letterSpacing: -0.5.w, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 23.h),
              Row(
                children: [
                  SizedBox(width: 36.w),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hi, ',
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 25.sp,
                            letterSpacing: -0.5.w,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: widget.username, // Display username dynamically
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 25.sp,
                            letterSpacing: -1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7.h),
              Row(
                children: [
                  SizedBox(width: 36.w),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Unlock your career',
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 17.sp,
                            letterSpacing: -1,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                            text: ' completing your profile',
                            style: GoogleFonts.dmSans(
                              color: const Color.fromRGBO(70, 139, 25, 1),
                              fontSize: 17.sp,
                              decoration: TextDecoration.underline,
                              letterSpacing: -1,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              ProfilePage(
                                        // fullName:
                                        //    '', // Add fullName or get it dynamically

                                        username: widget
                                            .username, // Pass the username dynamically
                                        mobile: widget.mobile,
                                      ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ));
                              }),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(top: 20.h, left: 33.w, right: 33.w),

                height: 73.h,
                // width: MediaQuery.of(context).size.width - 49.w,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(117, 192, 68, 0.3),
                      spreadRadius: 3,
                      blurRadius: 107.7,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/profile_warning.svg',
                      height: 25.h,
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Complete your profile setup',
                            style: GoogleFonts.dmSans(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2D2D2D),
                              letterSpacing: -0.5.w,
                            ),
                          ),
                          Text(
                            'Provide your details for applying for job',
                            style: GoogleFonts.dmSans(
                              fontSize: 13.sp,
                              letterSpacing: -0.2.w,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6F6F6F),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '  Featured Jobs',
                          style: GoogleFonts.dmSans(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                          ),
                        ),
                        // SizedBox(height: 25.h),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    FutureBuilder<List<Course>>(
                      future: _futureCourses,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildShimmerEffect();
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                            'Error loading courses',
                            style: GoogleFonts.dmSans(
                              fontSize: 14.sp,
                            ),
                          ));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text(
                            'No courses available',
                            style: GoogleFonts.dmSans(
                              fontSize: 14.sp,
                            ),
                          ));
                        } else {
                          final courses = snapshot.data!;
                          return SizedBox(
                            height: 200.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: courses.length,
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return _buildCourseCard(
                                  context,
                                  course.imageUrl ??
                                      'assets/images/not_found.jpg',
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
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '  Jobs & Vacancies',
                          //  textAlign: TextAlign.start,
                          style: GoogleFonts.dmSans(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 23.h),
                    // GridView

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 15.w,
                      children: List.generate(4, (index) {
                        // List of job titles
                        final jobTitles = [
                          'Office\n Clerk',
                          'Senior\n Accountant',
                          'System\n Admin',
                          'Cashier'
                        ];
                        final jobSvg = [
                          'assets/images/job_sector.svg',
                          'assets/images/job_sector1.svg',
                          'assets/images/job_sector2.svg',
                          'assets/images/job_sector3.svg',
                        ];

                        return Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.only(left: 23),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(22.r),
                                    topRight: Radius.circular(22.r),
                                  ),
                                  color:
                                      const Color.fromRGBO(117, 192, 68, 0.15),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        jobSvg[index],
                                        height: 35.h,
                                        width: 35.w,
                                      ),
                                      SizedBox(
                                          width: 10
                                              .w), // Add spacing between icon and text
                                      Text(
                                        jobTitles[
                                            index], // Replace with job title
                                        style: GoogleFonts.dmSans(
                                          letterSpacing: -0.5.w,
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(22.r),
                                    bottomRight: Radius.circular(22.r),
                                  ),
                                  color: const Color.fromRGBO(46, 53, 58, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    '110 Vacancies',
                                    style: GoogleFonts.dmSans(
                                      letterSpacing: -0.5.w,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Text(
                            'View More',
                            style: GoogleFonts.dmSans(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.5),
                          ),
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context){
                            //   return NotificationPage();
                            // }));
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: Colors.green,
                        )
                      ],
                    ),
                    SizedBox(height: 30.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: GoogleFonts.dmSans(
                            color:
                                Colors.black, // Set a base color for all text
                            fontSize: 16.sp, // Set a base font size
                          ),
                          children: [
                            TextSpan(
                              text: 'Continue your journey\n toward a ',
                              style: GoogleFonts.dmSans(
                                  letterSpacing: -0.5.w,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 26.sp),
                            ),
                            TextSpan(
                              text: 'rewarding\n retail career.',
                              style: GoogleFonts.dmSans(
                                  letterSpacing: -0.5.w,
                                  color: const Color.fromRGBO(117, 192, 68, 1),
                                  fontSize: 26.sp,
                                  fontWeight:
                                      FontWeight.w400), // Make this part bold
                            ),
                          ]),
                    ),
                    SizedBox(height: 20.h), // Add some bottom padding
                    Container(
                      width: 175.w,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(46, 53, 58, 1),
                          borderRadius: BorderRadius.circular(22)),
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
                    const SizedBox(
                      height: 30,
                    )
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
        height: 189.h, // Adjusted to match the card height
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (_, __) => Container(
            width: 276.w, // Match the card width
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
            child: Stack(
              children: [
                // Shimmer for the image
                Container(
                  height: 169.h, // Match the image height
                  width: 276.w, // Match the image width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                // Shimmer for the gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Shimmer for the title text
                Positioned(
                  bottom: 15.h,
                  left: 15.w,
                  right: 10.w,
                  child: Container(
                    height: 40.h, // Approximate height for two lines of text
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
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
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5.w,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Details:',
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5.w,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        description,
                        style: GoogleFonts.dmSans(
                          fontSize: 16.sp,
                          letterSpacing: -0.5.w,
                        ),
                      ),
                      SizedBox(height: 70.h),
                      // Text(
                      //   '''
                      //   Course Details:
                      //   $lessons
                      //   Fee: $price
                      //   ''',
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16.sp,
                      //   ),
                      // ),
                      // SizedBox(height: 80.h),
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
                        'Want to Know more?',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5.w,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(117, 192, 68, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: TextButton(
                          onPressed: () => _launchWhatsApp(title),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/whatsapp.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                                height: 20.0,
                                width: 20.0,
                                allowDrawingOutsideViewBox: true,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Contact',
                                style: GoogleFonts.dmSans(
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
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCourseCard(BuildContext context, String imagePath, String title,
      String lessons, String description, String price, int index) {
    return Container(
      width: 276.w,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Image(
              height: 180.h,
              width: 276.w,
              image: imagePath.isNotEmpty
                  ? NetworkImage(imagePath)
                  : const AssetImage('assets/images/not_found.png')
                      as ImageProvider,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/not_found.jpg',
                  height: 180.h,
                  width: 276.w,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(213, 215, 216, 1),
                ),
                borderRadius: BorderRadius.circular(18.r),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15.h,
            left: 15.w,
            right: 10.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    _showCourseDrawer(
                        context, title, lessons, description, price);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Text(
                      'View Details',
                      style: GoogleFonts.dmSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.5,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
