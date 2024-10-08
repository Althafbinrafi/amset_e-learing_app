import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isExpanded = false; // To track whether the grid is expanded or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        // leading: GestureDetector(
        //   child: Icon(Icons.arrow_back_ios_new_rounded),
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        // ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Jobs & Vacancies',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5.w,
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Adjust height as needed

          child: Container(
            color: Colors.grey[300], // Set desired line color
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                child: Container(
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 26.w, vertical: 17.h),
                      hintText: 'Search for jobs',
                      hintStyle: GoogleFonts.dmSans(
                        letterSpacing: -0.5.w,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: Colors.white, // Fill color of the TextField
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17.r),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17.r),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17.r),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.h),

              // Scrollable main content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 14.h,
                  crossAxisSpacing: 15.w,
                  children: List.generate(
                    _isExpanded
                        ? 10
                        : 6, // Show 6 or 12 items based on the toggle
                    (index) {
                      // List of job titles and SVGs
                      final jobTitles = [
                        'Office\nClerk',
                        'Senior\nAccountant',
                        'System\nAdmin',
                        'Cashier',
                        'HR\nManager',
                        'Software\nEngineer',
                        'Data\nAnalyst',
                        'Marketing\nSpecialist',
                        'Customer\nService',
                        'Project\nManager',
                        'Graphic\nDesigner',
                      ];
                      final jobSvg = [
                        'assets/images/job_sector.svg',
                        'assets/images/job_sector1.svg',
                        'assets/images/job_sector2.svg',
                        'assets/images/job_sector3.svg',
                        'assets/images/job_sector2.svg',
                        'assets/images/job_sector.svg',
                        'assets/images/job_sector1.svg',
                        'assets/images/job_sector2.svg',
                        'assets/images/job_sector3.svg',
                        'assets/images/job_sector2.svg',
                        'assets/images/job_sector.svg',
                        'assets/images/job_sector1.svg',
                      ];

                      return Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 23.w),
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
                                      jobSvg[index % jobSvg.length],
                                      height: 35.h,
                                      width: 35.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Text(
                                        jobTitles[index % jobTitles.length],
                                        style: GoogleFonts.dmSans(
                                          color: Colors.black,
                                          letterSpacing: -0.5,
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
                                    letterSpacing: -0.5,
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 29.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded; // Toggle the state
                      });
                    },
                    child: Text(
                      _isExpanded ? 'View Less' : 'View More', // Toggle text
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
              ),
              SizedBox(height: 15.h),
            ],
          ),
        ),
      ),
    );
  }
}
