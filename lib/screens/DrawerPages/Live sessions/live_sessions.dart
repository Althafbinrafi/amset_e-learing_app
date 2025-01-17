import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveSessions extends StatefulWidget {
  const LiveSessions({super.key});

  @override
  State<LiveSessions> createState() => _LiveSessionsState();
}

class _LiveSessionsState extends State<LiveSessions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'amset Live',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5.w,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
              'assets/images/back_btn.svg',
              width: 25,
              height: 25,
            ),
          ),
        ),
        leadingWidth: 55.0,
      ),
      body: Center(
        child: Center(
          child: Text(
            'There is no any Live sessions now',
            style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                letterSpacing: -0.3),
          ),
        ),
      ),
    );
  }
}
