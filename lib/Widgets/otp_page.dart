import 'dart:developer';
import 'package:amset/screens/Reg%20and%20Log/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amset/Api%20Services/registration_service.dart';

import '../Models/Reg & Log Models/registration_model.dart';


class OtpVerificationPage extends StatefulWidget {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String mobileNumber;
  final String location;
  final String experience;
  final String sector;

  const OtpVerificationPage({
    super.key,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.mobileNumber,
    required this.location,
    required this.experience,
    required this.sector,
  });

  @override
  OtpVerificationPageState createState() => OtpVerificationPageState();
}

class OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _otpController = TextEditingController();
  final ApiServiceReg _apiService = ApiServiceReg();

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

  Future<void> _handleVerifyOtp() async {
    if (_currentOtp.length == 4) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate OTP verification
        await Future.delayed(const Duration(seconds: 2));

        // Hardcoded OTP for testing; replace with actual OTP verification logic
        if (_currentOtp == "1234") {
          log('OTP Verified, registering user...');

          // Call the registration API
          RegistrationModel registrationResult = await _apiService.registerUser(
            fullName: widget.fullName,
            username: widget.username,
            email: widget.email,
            password: widget.password,
            mobileNumber: widget.mobileNumber,
            experienceSector: widget.sector, // Updated to include sector
            experience: widget.experience, // Updated to include experience
            country: widget.location, // Updated to include location
          );

          if (registrationResult.success) {
            await _saveUserDataToPreferences();
            if (!mounted) return;

            // Show the success animation page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessAnimationPage(
                  onAnimationComplete: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(
                          fullName: '',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            _showSnackBar('Registration failed: ${registrationResult.message}');
          }
        } else {
          _showSnackBar('Invalid OTP. Please try again.');
        }
      } catch (e) {
        log('Error during registration: $e');
        _showSnackBar('Failed to verify OTP or register. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveUserDataToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('fullName', widget.fullName);
    await prefs.setString('username', widget.username);
    await prefs.setString('email', widget.email);
    await prefs.setString('mobileNumber', widget.mobileNumber);
    await prefs.setString('location', widget.location);
    await prefs.setString('experience', widget.experience);
    await prefs.setString('sector', widget.sector);

    log('User data saved to SharedPreferences');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
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
}

class SuccessAnimationPage extends StatelessWidget {
  final VoidCallback onAnimationComplete;

  const SuccessAnimationPage({super.key, required this.onAnimationComplete});

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
          onLoaded: (composition) {
            Future.delayed(composition.duration, onAnimationComplete);
          },
        ),
      ),
    );
  }
}
