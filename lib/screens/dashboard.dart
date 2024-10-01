import 'dart:async';
import 'package:amset/Models/allCoursesModel.dart';
import 'package:amset/Pages/course_page.dart';
import 'package:amset/Pages/notification_page.dart';
import 'package:amset/Pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    const DashboardPage(fullName: 'User Name', avatarPath: 'assets/avatar.png'),
    const NotificationPage(), // Placeholder for CoursePage
    const CoursePage(), // Placeholder for Favourites (Notifications)
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
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
          children: _pages,
        ),
        bottomNavigationBar: SizedBox(
          height: 85.h,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor:
                const Color(0xFF006257), // Green color for selected item
            unselectedItemColor: const Color.fromARGB(
                255, 0, 0, 0), // Default color for unselected items
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
        ),
        endDrawer: _buildDrawer(),
      ),
    );
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
            leadingWidth: 132,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: false,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            leading: Padding(
              padding: EdgeInsets.only(left: 32.w),
              child: SvgPicture.asset(
                'assets/images/Dashboard_logo.svg',
                height: 25.h,
                width: 117.w,
              ),
            ),
            actions: [
              GestureDetector(
                onTap:
                    _showCoinDialog, // Call this function when the coin is tapped
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
                        height: 22.h, // Adjusted icon size for bigger coin
                        width: 22.w, // Adjusted icon size for bigger coin
                      ),
                      SizedBox(width: 6.w), // Slightly increased spacing
                      Text(
                        '126',
                        style: TextStyle(
                          fontSize: 14.sp, // Increased font size
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
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
                    backgroundImage: AssetImage(widget.avatarPath),
                    radius: 21.r,
                  ),
                ),
              ),
            ],
          )
        : null;
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
                // Coin SVG centered
                SvgPicture.asset(
                  'assets/images/amset_coin.svg',
                  height: 60.h, // Bigger coin size for the dialog
                  width: 60.w,
                ),
                SizedBox(height: 16.h),

                // Coin count text
                Text(
                  '126', // The number of coins (you can make this dynamic if needed)
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                SizedBox(height: 8.h),

                // Explanatory text
                Text(
                  'You can earn more coins by purchasing additional courses!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[700],
                  ),
                ),

                SizedBox(height: 20.h),

                // Close button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF006257),
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

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF006257),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(widget.avatarPath),
                  radius: 40.r,
                ),
                SizedBox(height: 10.h),
                Text(
                  widget.fullName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }
}

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
  bool _hasError = false;
  String? _fullName;

  @override
  void initState() {
    super.initState();
    _loadFullName();
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

  Future<void> _loadFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('fullName') ??
          'Guest'; // Get the full name or default to 'Guest'
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
          Icon(Icons.error_outline,
              color: const Color.fromARGB(255, 114, 113, 113), size: 100.r),
          SizedBox(height: 20.h),
          Text('Check Your Connection', style: TextStyle(fontSize: 18.sp)),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: _loadCourses,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
              backgroundColor:
                  const Color.fromRGBO(117, 192, 68, 1), // Use custom color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              elevation:
                  0, // Add some elevation to make the button more prominent
              shadowColor: Colors.black.withOpacity(0.2), // Professional look
            ),
            child: const Text('Retry'),
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
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: _fullName ??
                              'Guest', // Dynamic name from shared preferences
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(top: 20.h, left: 36.w, right: 36.w),

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
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2D2D2D),
                              letterSpacing: -0.5.w,
                            ),
                          ),
                          Text(
                            'Provide Educational details for applying for job',
                            style: GoogleFonts.dmSans(
                              fontSize: 10.sp,
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
                padding: EdgeInsets.only(left: 36.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ' Featured Jobs',
                          style: GoogleFonts.dmSans(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                    Container(
                      child: FutureBuilder<List<Course>>(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 36.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          ' Jobs & Vacancies',
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
                      childAspectRatio: 1.6,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      //padding: EdgeInsets.symmetric(horizontal: 16.w),
                      children: List.generate(4, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: const Color.fromRGBO(117, 192, 68, 0.15),
                          ),
                          child: Center(
                            child: Text(
                              'Item ${index + 1}',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
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
                                  fontWeight: FontWeight.w400, fontSize: 25.sp),
                            ),
                            TextSpan(
                              text: 'rewarding\n retail career.',
                              style: GoogleFonts.dmSans(
                                  color: const Color.fromRGBO(117, 192, 68, 1),
                                  fontSize: 25.sp,
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
    return GestureDetector(
      onTap: () =>
          _showCourseDrawer(context, title, lessons, description, price),
      child: Container(
        width: 276.w, // Set the container width to match the image width
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(18.r), // Border radius for all sides
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5.r,
              spreadRadius: 2.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Full-size image with rounded corners on all sides
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(18.r), // Rounded corners for all sides
              child: Image(
                height: 169.h, // Set the image height to 169.h
                width: 276.w, // Set the image width to 276.w
                image: imagePath.isNotEmpty
                    ? NetworkImage(imagePath)
                    : const AssetImage('assets/images/default.png')
                        as ImageProvider,
                fit: BoxFit.cover, // Cover to fill the container with the image
              ),
            ),
            // Black gradient shade from bottom to top
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      18.r), // Same rounded corners for the gradient
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
            // Title text inside the image, limited to two lines
            Positioned(
              bottom: 15.h,
              left: 15.w,
              right: 10.w, // Ensure the text stays within the bounds
              child: Text(
                title,
                maxLines: 2, // Limit the title to 2 lines
                overflow: TextOverflow
                    .ellipsis, // Show ellipsis if the text overflows
                style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 1.2, // Line height for better spacing between lines
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
