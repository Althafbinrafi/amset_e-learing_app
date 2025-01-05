import 'package:amset/Api%20Services/jobvacancy_api_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../Models/Course Models/course_fetch_model.dart';
import '../../Job Apply Pages/apply_job.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  bool _isExpanded = false;
  late Future _courseData;
  final TextEditingController _searchController = TextEditingController();
  List<Course> _filteredCourses = [];
  List<Course> _allCourses = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _courseData = ApiService().fetchCourses().then((data) {
      _allCourses = data.courses;
      _filteredCourses = _allCourses;
      return data;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        _filteredCourses = _allCourses;
      } else {
        _filteredCourses = _allCourses
            .where((course) =>
                course.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Jobs & Vacancies',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5.w,
          ),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _courseData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingEffect();
            } else if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 20.h),
                      child: _buildSearchBar(),
                    ),
                    SizedBox(height: 25.h),
                    if (_isSearching && _filteredCourses.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Lottie.asset(
                            //   'assets/images/no_data.json',
                            //   width: 300.w,
                            //   height: 100.h,
                            //   fit: BoxFit.contain,
                            // ),
                            Text(
                              'No matching jobs found',
                              style: GoogleFonts.dmSans(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                  letterSpacing: -0.3.sp),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Try different keywords or browse all jobs',
                              style: GoogleFonts.dmSans(
                                  fontSize: 14.sp,
                                  color: Colors.grey[500],
                                  letterSpacing: -0.3.sp),
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            mainAxisSpacing: 14.h,
                            crossAxisSpacing: 15.w,
                          ),
                          itemCount: _isExpanded
                              ? _filteredCourses.length
                              : (_filteredCourses.length > 6
                                  ? 6
                                  : _filteredCourses.length),
                          itemBuilder: (context, index) {
                            final course = _filteredCourses[index];
                            return _buildCourseItem(course);
                          },
                        ),
                      ),
                    SizedBox(height: 29.h),
                    if (_filteredCourses.length > 6) _buildViewMoreToggle(),
                    SizedBox(height: 15.h),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingEffect() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: _buildSearchBar(),
          ),
          SizedBox(height: 25.h),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/images/loading.json',
                  width: 200.w,
                  height: 200.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Loading Jobs...',
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/error.json',
            width: 200.w,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          Text(
            'Oops! Something went wrong',
            style: GoogleFonts.dmSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 14.sp,
                color: Colors.grey[600],
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _courseData = ApiService().fetchCourses();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(117, 192, 68, 1),
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(117, 192, 68, 0.3),
            spreadRadius: 3,
            blurRadius: 107.7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterCourses,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 26.w, vertical: 17.h),
          hintText: 'Search for jobs',
          hintStyle: GoogleFonts.dmSans(
            letterSpacing: -0.5.w,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.r),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCourseItem(Course course) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return JobDetailPage(courseId: course.id);
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.only(left: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.r),
                  topRight: Radius.circular(22.r),
                ),
                color: const Color.fromRGBO(117, 192, 68, 0.15),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        course.title,
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5.w,
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
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
                '${course.vacancyCount} Vacancies',
                style: GoogleFonts.dmSans(
                  letterSpacing: -0.5,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewMoreToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'View Less' : 'View More',
            style: GoogleFonts.dmSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Icon(
          _isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
          size: 19,
          color: Colors.green,
        ),
      ],
    );
  }
}
