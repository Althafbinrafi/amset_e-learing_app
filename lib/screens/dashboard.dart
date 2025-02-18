import 'dart:async';
import 'package:amset/Constants/constants_color.dart';
import 'package:amset/screens/DrawerPages/Live%20sessions/live_sessions.dart';
import 'package:amset/screens/DrawerPages/More/more_page.dart';
import 'package:amset/screens/NavigationBar/CoursePages/course_page.dart';
import 'package:amset/screens/NavigationBar/JobVacancies/job_vacancy.dart';
import 'package:amset/screens/DrawerPages/Profile/profile_page.dart';
import 'package:amset/screens/DrawerPages/Profile/user_details_page.dart';
import 'package:amset/screens/PostPurchasePages/success_purchase_page.dart';
import 'package:amset/screens/DrawerPages/PrivacyPolicy/security_policy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'dart:developer';
import '../Models/Course Models/all_course_model.dart';
import '../Models/Reg & Log Models/login_model.dart';
import 'DrawerPages/T and C/t_and_c.dart';
import 'Job Apply Pages/apply_job.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username = 'User Name';
  String _mobile = 'Mobile number';
  String _fullName = 'Full Name';
  String? _userId;
  String? _avatarUrl;
  int _totalCoins = 0;
  String? _bio = 'User Bio';
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    _userId = prefs.getString('user_id');

    if (_userId != null) {
      log("User ID from SharedPreferences: $_userId");
    } else {
      log("No User ID found in SharedPreferences.");
    }

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
        final profileData = userModelFromJson(response.body);

        int totalCoins = profileData.courseCoins?.fold<int>(
              0,
              (sum, coin) => sum + (coin.coins ?? 0),
            ) ??
            0;

        setState(() {
          _username = profileData.username ?? "Unknown User";
          _mobile = profileData.mobileNumber ?? "Unknown Mobile";
          _fullName = profileData.fullName ?? "Full Name";
          _avatarUrl = profileData.image;
          _totalCoins = totalCoins;
          _bio = profileData.bioDescription;

          _pages = [
            DashboardPage(
              username: _username,
              mobile: _mobile,
              fullName: _fullName,
              userId: _userId ?? 'Unknown User ID',
              avatar: _avatarUrl,
              totalCoins: _totalCoins,
            ),
            const JobVacancy(),
            CoursePage(
              userId: _userId.toString(),
              token: token,
            ),
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
          return await Get.defaultDialog(
            title: 'Exit App',
            titleStyle: GoogleFonts.dmSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            content: Text(
              'Are you sure you want to exit the app?',
              style: GoogleFonts.dmSans(fontSize: 14.sp),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false), // Return false
                child: Text('No', style: GoogleFonts.dmSans(fontSize: 14.sp)),
              ),
              TextButton(
                onPressed: () => Get.back(result: true), // Return true
                child: Text('Yes', style: GoogleFonts.dmSans(fontSize: 14.sp)),
              ),
            ],
          );
        } else {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        }
      },
      child: Scaffold(
        endDrawerEnableOpenDragGesture: false,
        key: _scaffoldKey,
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(),
        body: _currentIndex == 0
            ? LiquidPullToRefresh(
                springAnimationDurationInMilliseconds: 400,
                animSpeedFactor: 2,
                showChildOpacityTransition: false,
                onRefresh: _fetchProfileData, // Triggered on pull
                color: const Color.fromRGBO(117, 192, 68, 1),
                backgroundColor: AppColors.white,
                height: 68.0,
                child: IndexedStack(
                  index: _currentIndex,
                  children: _pages.isNotEmpty
                      ? _pages
                      : [
                          Center(
                            child: Lottie.asset(
                              'assets/images/loading.json',
                              width: 250,
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                ),
              )
            : IndexedStack(
                index: _currentIndex,
                children: _pages.isNotEmpty
                    ? _pages
                    : [
                        Center(
                          child: Lottie.asset(
                            'assets/images/loading.json',
                            width: 250,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
              ),
        bottomNavigationBar: _buildBottomNavigationBar(),
        endDrawer: _buildDrawer(),
      ),
    );
  }

  AppBar? _buildAppBar() {
    return _currentIndex == 0
        ? AppBar(
            surfaceTintColor: AppColors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 1),
              child: const Divider(
                color: AppColors.dividerColor,
              ),
            ),
            toolbarHeight: 85,
            leadingWidth: 154,
            iconTheme: const IconThemeData(color: AppColors.white),
            centerTitle: false,
            backgroundColor: AppColors.white,
            leading: Padding(
              padding: EdgeInsets.only(left: 32.w),
              child: GestureDetector(
                child: SvgPicture.asset(
                  'assets/images/Dashboard_logo.svg',
                  height: 25.h,
                  width: 140.w,
                ),
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
                      color: AppColors.borderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(21),
                    color: AppColors.transparent,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/amset_coin.svg',
                        height: 22.h,
                        width: 22.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '$_totalCoins ',
                        style: GoogleFonts.dmSans(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.bgBlack,
                          letterSpacing: -0.5.w,
                        ),
                      ),
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
                    radius: 19.r,
                    backgroundImage:
                        _avatarUrl != null && _avatarUrl!.isNotEmpty
                            ? NetworkImage(_avatarUrl!)
                            : const AssetImage('assets/images/man.png')
                                as ImageProvider,
                  ),
                ),
              ),
              // Refresh Icon
              // IconButton(
              //   onPressed: _fetchProfileData, // Trigger refresh manually
              //   icon: const Icon(
              //     Icons.refresh,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          )
        : null;
  }

  Widget _buildBottomNavigationBar() {
    return SizedBox(
      height: 85,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.focusedColor,
        unselectedItemColor: AppColors.bgBlack,
        items: [
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? AppColors.focusedColor : AppColors.bgBlack,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('assets/images/home_icon.svg'),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? AppColors.focusedColor : AppColors.bgBlack,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('assets/images/jobs_icon.svg'),
            ),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? AppColors.focusedColor : AppColors.bgBlack,
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
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 160,
            child: DrawerHeader(
              padding: EdgeInsets.only(left: 15.w),
              decoration: const BoxDecoration(
                color: Color.fromARGB(120, 233, 233, 233),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: _avatarUrl != null
                            ? NetworkImage(_avatarUrl!)
                            : null,
                        radius: 33.r,
                        child: _avatarUrl == null
                            ? Image.asset('assets/images/man.png')
                            : null, // Fallback avatar
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _fullName,
                              style: GoogleFonts.dmSans(
                                color: AppColors.bgBlack,
                                fontSize: 17.sp,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                            Row(
                              children: [
                                Text(
                                  "@",
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.bgBlack,
                                    fontSize: 16.sp,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _username,
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.bgBlack,
                                    fontSize: 16.sp,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
          _buildDrawerItem(
            icon: Icons.account_circle,
            title: 'Profile',
            backgroundColor: const Color(0x47C0C1C0),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (!mounted) return;
                Get.to(
                  () => ProfilePage(
                    username: _username,
                    mobile: _mobile,
                    fullName: _fullName,
                    avatar: _avatarUrl,
                    totalCoins: _totalCoins,
                    bioDescription: _bio,
                  ),
                  transition: Transition.noTransition,
                  duration: Duration.zero,
                );
              });
            },
          ),
          _buildDrawerItem(
            icon: Icons.privacy_tip,
            title: 'security Policy',
            backgroundColor: const Color.fromARGB(72, 192, 193, 192),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              if (!mounted) return;
              Get.to(
                () =>
                    const SecurityPolicy(), // Create an instance of the SecurityPolicy widget
                transition: Transition.noTransition,
                duration: Duration.zero,
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.view_list_rounded,
            title: 'Terms & Conditions',
            backgroundColor: const Color.fromARGB(72, 192, 193, 192),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              if (!mounted) return;
              Get.to(
                () => const TermsAndConditionsPage(),
                transition: Transition.noTransition,
                duration: Duration.zero,
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.live_tv_rounded,
            title: 'Live',
            backgroundColor: const Color.fromARGB(72, 192, 193, 192),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              if (!mounted) return;
              Get.to(
                () => const LiveSessions(),
                transition: Transition.noTransition,
                duration: Duration.zero,
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.more_vert,
            title: 'More',
            backgroundColor: const Color.fromARGB(72, 192, 193, 192),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 300));
              if (!mounted) return;
              Get.to(
                () => MorePage(
                  userId: _userId.toString(),
                ),
                transition: Transition.noTransition,
                duration: Duration.zero,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: GoogleFonts.dmSans(
            letterSpacing: -0.3,
            fontSize: 15.sp,
          ),
        ),
        onTap: onTap,
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
        ),
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
                  '$_totalCoins',
                  style: GoogleFonts.dmSans(
                    fontSize: 30.sp,
                    letterSpacing: -0.5.w,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bgBlack,
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
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.amsetGreen,
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
                      color: AppColors.white,
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
  final String fullName;
  final String? userId;
  final String? avatar;
  final int totalCoins; // Accept total coins

  const DashboardPage(
      {super.key,
      required this.username,
      required this.mobile,
      required this.fullName,
      this.userId,
      required this.totalCoins,
      this.avatar});

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
  bool _showProfileDashboard = false; // Default to false

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: 0);

    _fetchProfileData(); // Fetch profile data and set _showProfileDashboard
    _loadCourses();

    log("User ID: ${widget.userId}");

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

  Future<void> _fetchProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');

    if (token == null || userId == null) {
      log('Token or User ID is null.');
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if any required field is null
        final isProfileIncomplete = [
          data['fullName'],
          data['username'],
          data['email'],
          data['address'],
          data['mobileNumber'],
          data['postOffice'],
          data['pinCode'],
          data['image'],
          data['secondaryMobileNumber'],
        ].any((field) => field == null);

        if (isProfileIncomplete) {
          setState(() {
            _showProfileDashboard = true;
          });
        } else {
          setState(() {
            _showProfileDashboard = false;
          });
        }
      } else {
        log('Failed to fetch profile data. Status Code: ${response.statusCode}');
        setState(() {
          _showProfileDashboard = false;
        });
      }
    } catch (e) {
      log('Error fetching profile data: $e');
      setState(() {
        _showProfileDashboard = false;
      });
    }
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
      backgroundColor: AppColors.white,
      body: _hasError ? _buildErrorPage() : _buildMainDashboard(),
    );
  }

  Widget _buildMainDashboard() {
    return FutureBuilder<List<Course>>(
      future: _futureCourses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(
              'assets/images/loading.json',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
          );
        } else if (snapshot.hasError) {
          return _buildErrorPage();
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildDashboard(snapshot.data!.last);
        } else {
          return const Center(child: Text('No courses available'));
        }
      },
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
              backgroundColor: AppColors.amsetGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation: 0,
              shadowColor: Colors.black.withAlpha(51),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.dmSans(
                  fontSize: 17, letterSpacing: -0.5.w, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(Course course) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              if (_showProfileDashboard)
                ProfileDashboard(
                  onClose: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('hasShownProfileDashboard', true);

                    setState(() {
                      _showProfileDashboard = false;
                    });
                  },
                  fullName: widget.fullName,
                  mobile: widget.mobile,
                  userId: widget.userId ?? '',
                  username: widget.username,
                ),
              SizedBox(height: 23.h),
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
                            color: AppColors.black,
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
                          return const Center(
                              child: Text('Error loading courses'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No courses available'));
                        } else {
                          // Filter published courses and sort by vacancy count
                          final courses = snapshot.data!
                              .where((course) => course.isPublished)
                              .toList()
                            ..sort((a, b) =>
                                b.vacancyCount.compareTo(a.vacancyCount));

                          // Take only the first 4 courses
                          final featuredCourses = courses.take(4).toList();

                          return SizedBox(
                            height: 200.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: featuredCourses.length,
                              itemBuilder: (context, index) {
                                final course = featuredCourses[index];
                                return _buildCourseCard(
                                  context,
                                  course.imageUrl,
                                  course.title,
                                  course.id,
                                  '${course.chapters.length} Lessons',
                                  course.description,
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
                          style: GoogleFonts.dmSans(
                            color: AppColors.bgBlack,
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 23.h),
                    FutureBuilder<List<Course>>(
                      future: _futureCourses,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildShimmerEffectVacencies();
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error loading jobs',
                              style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No jobs available',
                              style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                              ),
                            ),
                          );
                        } else {
                          // Filter only published jobs and take first 4
                          final jobs = snapshot.data!
                              .where((job) =>
                                  job.isPublished) // Filter published jobs only
                              .take(4) // Take first 4 jobs
                              .toList();

                          return Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                  mainAxisSpacing: 14.h,
                                  crossAxisSpacing: 15.w,
                                ),
                                itemCount: jobs.length,
                                itemBuilder: (context, index) {
                                  final job = jobs[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => JobDetailPage(
                                          courseId: job.id.toString(),
                                        ),
                                        transition: Transition.noTransition,
                                        duration: Duration.zero,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding:
                                                EdgeInsets.only(left: 16.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(22.r),
                                                topRight: Radius.circular(22.r),
                                              ),
                                              color: AppColors.jobBgGreen,
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/job_sector1.svg',
                                                    height: 35.h,
                                                    width: 35.w,
                                                    placeholderBuilder: (context) =>
                                                        const CircularProgressIndicator(),
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Expanded(
                                                    child: Text(
                                                      job.title,
                                                      style: GoogleFonts.dmSans(
                                                        letterSpacing: -0.5.w,
                                                        color: AppColors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
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
                                                bottomLeft:
                                                    Radius.circular(22.r),
                                                bottomRight:
                                                    Radius.circular(22.r),
                                              ),
                                              color: AppColors.bgBlack,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${job.vacancyCount} Vacancies',
                                                style: GoogleFonts.dmSans(
                                                  letterSpacing: -0.5.w,
                                                  color: AppColors.white,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                            ],
                          );
                        }
                      },
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
                              letterSpacing: -0.5,
                            ),
                          ),
                          onTap: () {
                            Get.to(
                              () => const JobVacancy(),
                              transition: Transition.noTransition,
                              duration: Duration.zero,
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: AppColors.amsetGreen,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          style: GoogleFonts.dmSans(
                            color: AppColors
                                .black, // Set a base color for all text
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
                                  color: AppColors.amsetGreen,
                                  fontSize: 26.sp,
                                  fontWeight:
                                      FontWeight.w400), // Make this part bold
                            ),
                          ]),
                    ),
                    SizedBox(height: 20.h), // Add some bottom padding
                    GestureDetector(
                      child: Container(
                        width: 175.w,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: AppColors.bgBlack,
                            borderRadius: BorderRadius.circular(22)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Apply For Job',
                              style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.5),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: AppColors.white,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.to(
                          () => const SuccessPurchasePage(),
                          transition: Transition.noTransition,
                          duration: Duration.zero,
                        );
                      },
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
}

Widget _buildShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: AppColors.shimmerBase,
    highlightColor: AppColors.shimmerHLight,
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
                  color: AppColors.white,
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
                        AppColors.shadeBlackColor,
                        AppColors.transparent,
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
                    color: AppColors.white,
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

Widget _buildShimmerEffectVacencies() {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 14.h,
      crossAxisSpacing: 15.w,
    ),
    itemCount: 4, // Placeholder count for shimmer
    itemBuilder: (context, index) {
      return Column(
        children: [
          // Top section of the shimmer card
          Expanded(
            flex: 2,
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHLight,
              child: Container(
                // margin:
                //     EdgeInsets.symmetric(horizontal: 10.w), // Uniform margin
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22.r),
                    topRight: Radius.circular(22.r),
                  ),
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
          // Bottom section of the shimmer card
          Expanded(
            flex: 1,
            child: Shimmer.fromColors(
              baseColor: AppColors.shimmerBase,
              highlightColor: AppColors.shimmerHLight,
              child: Container(
                //     margin: EdgeInsets.symmetric(horizontal: 10.w), // Same margin
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22.r),
                    bottomRight: Radius.circular(22.r),
                  ),
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildCourseCard(BuildContext context, String imagePath, String title,
    String id, String lessons, String description, String price, int index) {
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
                  AppColors.black
                      .withAlpha(179), // 70% opacity (255 * 0.7 = 178.5 → 179)
                  AppColors.transparent,
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
                  color: AppColors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => JobDetailPage(courseId: id),
                    transition: Transition.noTransition,
                    duration: Duration.zero,
                  );
                  // _showCourseDrawer(
                  //     context, title, lessons, description, price);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.white),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.dmSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.5,
                      color: AppColors.bgBlack,
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

class ProfileDashboard extends StatefulWidget {
  final String fullName;
  final String username;
  final String mobile;
  final String userId;
  final VoidCallback onClose;

  const ProfileDashboard({
    super.key,
    required this.fullName,
    required this.username,
    required this.mobile,
    required this.userId,
    required this.onClose,
  });

  @override
  ProfileDashboardState createState() => ProfileDashboardState();
}

class ProfileDashboardState extends State<ProfileDashboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 23.h),
        // Name and Close Icon in the Same Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 36.w),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hi, ',
                      style: GoogleFonts.dmSans(
                        color: AppColors.black,
                        fontSize: 25.sp,
                        letterSpacing: -0.5.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: widget.fullName, // Display username dynamically
                      style: GoogleFonts.dmSans(
                        color: AppColors.black,
                        fontSize: 25.sp,
                        letterSpacing: -1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: 27.w, bottom: 11), // Adjust padding if needed
              child: GestureDetector(
                onTap: widget.onClose, // Notify parent to close dashboard
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 1,
                        color: AppColors.borderColor,
                      )),
                  child: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.greyColor,
                  ),
                ),
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
                      color: AppColors.black,
                      fontSize: 17.sp,
                      letterSpacing: -1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  TextSpan(
                    text: ' completing your profile',
                    style: GoogleFonts.dmSans(
                      color: AppColors.amsetGreen,
                      fontSize: 17.sp,
                      decoration: TextDecoration.underline,
                      letterSpacing: -1,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(
                          () => UserDetailsPage(
                            userName: widget.username,
                            mobile: widget.mobile,
                            fullName: widget.fullName,
                            userId: widget.userId,
                          ),
                          transition: Transition.noTransition,
                          duration: Duration.zero,
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.h, left: 33.w, right: 33.w),
          child: Stack(
            children: [
              Container(
                height: 73.h,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadeGreenColor,
                      spreadRadius: 3,
                      blurRadius: 107.7,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 20.w),
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
                              color: AppColors.bgBlack,
                              letterSpacing: -0.5.w,
                            ),
                          ),
                          Text(
                            'Provide your details for applying for job',
                            style: GoogleFonts.dmSans(
                              fontSize: 12.sp,
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
            ],
          ),
        ),
        // Add other sections below this
      ],
    );
  }
}
