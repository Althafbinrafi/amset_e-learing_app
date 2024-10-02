import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(vertical: 35.h),
                child: Text(
                  'Jobs & Vacancies',
                  style: GoogleFonts.dmSans(
                      color: Colors.black,
                      fontSize: 27.sp,
                      fontWeight: FontWeight.normal,
                      letterSpacing: -1),
                ),
              ),
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(117, 192, 68, 0.3),
                        spreadRadius: 3,
                        blurRadius: 107.7,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 26.w, vertical: 17.h),
                      hintText: 'Search for jobs',
                      hintStyle: GoogleFonts.dmSans(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      labelStyle: GoogleFonts.dmSans(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      filled: true,
                      fillColor: Colors.white, // Fill color of the TextField
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.r),
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
              SizedBox(height: 33.h),
              // Scrollable main content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.6,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                  children: List.generate(
                    _isExpanded
                        ? 12
                        : 6, // Show 6 or 8 items based on the toggle
                    (index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: const Color.fromRGBO(117, 192, 68, 0.19),
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
                          letterSpacing: -0.5),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    _isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
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
