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
    DashboardPage(fullName: 'User Name', avatarPath: 'assets/avatar.png'),
    NotificationPage(), // Placeholder for CoursePage
    CoursePage(), // Placeholder for Favourites (Notifications)
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
            // elevation: 10,
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/home_icon.svg'),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/jobs_icon.svg'),
                label: 'Jobs',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/course_icon.svg'),
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
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 1),
              child: const Divider(
                color: Color.fromRGBO(213, 215, 216, 1),
              ),
            ),
            toolbarHeight: 85,
            leadingWidth: 123,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: false,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            leading: Padding(
              padding: EdgeInsets.only(left: 21.w),
              child: SvgPicture.asset(
                'assets/images/Dashboard_logo.svg',
                height: 25.h,
                width: 117.w,
              ),
            ),
            actions: [
              Container(
                // height: 2.h, // Increased height
                // width: 67.w, // Increased width
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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
                    SizedBox(width: 8.w), // Slightly increased spacing
                    Text(
                      '126',
                      style: TextStyle(
                        fontSize: 14.sp, // Increased font size
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: _openEndDrawer,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
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
              Navigator.pushReplacement(
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
          Icon(Icons.error_outline,
              color: const Color.fromARGB(255, 114, 113, 113), size: 100.r),
          SizedBox(height: 20.h),
          Text('Check Your Connection', style: TextStyle(fontSize: 18.sp)),
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
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  SizedBox(width: 16.w),
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
                          text: 'Muhammad Althaf',
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
                  SizedBox(width: 16.w),
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
                            color: Color.fromRGBO(70, 139, 25, 1),
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
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.only(top: 20.h),
                height: 73.h,
                width: MediaQuery.of(context).size.width - 40.w,
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
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF2D2D2D),
                              letterSpacing: -0.5.w,
                            ),
                          ),
                          Text(
                            'Provide Educational details for applying for job',
                            style: TextStyle(
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
                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                      ],
                    ),
                    SizedBox(height: 5.h),
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
                          final courses = snapshot.data!;
                          return SizedBox(
                            height: 224.h,
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
              //   SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                    SizedBox(height: 10.h),
                    // GridView
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                        Text(
                          'View More',
                          style: GoogleFonts.dmSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.5),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
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
                                  color: Color.fromRGBO(117, 192, 68, 1),
                                  fontSize: 25.sp,
                                  fontWeight:
                                      FontWeight.w400), // Make this part bold
                            ),
                          ]),
                    ),
                    SizedBox(height: 20.h), // Add some bottom padding
                    Container(
                      width: 175.w,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(46, 53, 58, 1),
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
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
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
        height: 250.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                SizedBox(height: 8.5.h),
                Container(
                  width: 180.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                SizedBox(height: 8.5.h),
                Container(
                  width: 180.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                SizedBox(height: 8.5.h),
                SizedBox(
                  width: 180.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      // Container(
                      //   width: 20.w,
                      //   height: 20.h,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(18.r),
                      //   ),
                      // ),
                    ],
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
    if (await canLaunch(url)) {
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
        width: 190.w, // Fixed width for each course card
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
                  //SizedBox(height: 5.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Icon(
                  //           Icons.label,
                  //           color: Colors.grey,
                  //           size: 20.sp,
                  //         ),
                  //         SizedBox(width: 3.w),
                  //         Text(
                  //           'Hypermarket',
                  //           style:
                  //               TextStyle(fontSize: 14.sp, color: Colors.grey),
                  //         ),
                  //       ],
                  //     ),
                  //     // const Icon(
                  //     //   Icons.favorite_outline_rounded,
                  //     //   color: Color.fromARGB(255, 90, 89, 89),
                  //     // ),
                  //   ],
                  // ),
                  // SizedBox(height: 5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
