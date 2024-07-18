import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006257),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF006257),
              child: const Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            height: 0.7.sh, // Using 70% of the screen height
            width: 1.sw, // Using the full screen width
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/Push notifications-bro.svg',
                    height: 200.h,
                    width: 200.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  const Text(
                    'No Notifications !',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
