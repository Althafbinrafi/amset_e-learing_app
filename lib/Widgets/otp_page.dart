import 'dart:developer';
import 'package:amset/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationPage extends StatefulWidget {
  final String mobileNumber;

  const OtpVerificationPage({Key? key, required this.mobileNumber})
      : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _otpController = TextEditingController();
  String _currentOtp = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildOtpVerificationPage(),
      ),
    );
  }

  Widget _buildOtpVerificationPage() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  _buildTitle(),
                  SizedBox(height: 30.h),
                  _buildInstructions(),
                  SizedBox(height: 30.h),
                  _buildOtpFields(),
                  SizedBox(height: 30.h),
                  _buildVerifyButton(),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'OTP Verification',
      style: GoogleFonts.dmSans(
        letterSpacing: -0.5.w,
        color: const Color(0xFF006257),
        fontSize: 25.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInstructions() {
    return Text(
      'Enter the 4-digit code sent to\n  ${widget.mobileNumber}',
      textAlign: TextAlign.center,
      style: GoogleFonts.dmSans(
        color: Colors.grey.shade600,
        fontSize: 16.sp,
        letterSpacing: -0.5.w,
      ),
    );
  }

  Widget _buildOtpFields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: PinCodeTextField(
        appContext: context,
        length: 4,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(10),
          fieldHeight: 50,
          fieldWidth: 50,
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.grey[100],
          selectedFillColor: Colors.white,
          activeColor: const Color(0xFF006257),
          inactiveColor: Colors.grey[300],
          selectedColor: const Color(0xFF006257),
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.transparent,
        enableActiveFill: true,
        controller: _otpController,
        onCompleted: (v) {
          log("Completed");
        },
        onChanged: (value) {
          setState(() {
            _currentOtp = value;
          });
        },
        beforeTextPaste: (text) {
          log("Allowing to paste $text");
          return true;
        },
        mainAxisAlignment: MainAxisAlignment.center,
        keyboardType: TextInputType.number,
        autoDisposeControllers: false,
      ),
    );
  }

  Widget _buildVerifyButton() {
    return GestureDetector(
      onTap: _handleVerifyOtp,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 133.w,
        height: 45.h,
        decoration: BoxDecoration(
          color: _isLoading
              ? Colors.grey
              : _currentOtp.length == 4
                  ? const Color(0xFF006257)
                  : Colors.grey,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Verify OTP',
                  style: GoogleFonts.dmSans(
                    letterSpacing: -0.5.w,
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ),
      ),
    );
  }

  void _handleVerifyOtp() async {
    if (_currentOtp.length == 4) {
      setState(() {
        _isLoading = true;
      });
      log('Verifying OTP: $_currentOtp');
      // Simulate OTP verification delay
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });

      // Navigate to SuccessAnimationPage
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SuccessAnimationPage()),
      );
    }
  }
}

class SuccessAnimationPage extends StatefulWidget {
  const SuccessAnimationPage({Key? key}) : super(key: key);

  @override
  _SuccessAnimationPageState createState() => _SuccessAnimationPageState();
}

class _SuccessAnimationPageState extends State<SuccessAnimationPage> {
  @override
  void initState() {
    super.initState();
    _navigateToDashboardAfterDelay();
  }

  void _navigateToDashboardAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Retrieve user information
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('fullName');
    String? email = prefs.getString('email');
    String? mobileNumber = prefs.getString('mobileNumber');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Dashboard(
          fullName: fullName ?? '',
          email: email, // Now optional
          mobileNumber: mobileNumber, // Now optional
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/images/Animation - 1724224199479.json',
          width: 200,
          height: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
