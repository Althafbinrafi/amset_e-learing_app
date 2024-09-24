import 'package:amset/Widgets/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Registerpage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form field controllers
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = false; // Loading state

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
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      // Simulate a 2-second delay before navigating to the OTP page
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false; // Remove loading indicator
        });

        // Navigate to OTP Verification Page
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                OtpVerificationPage(
              mobileNumber: mobileNumberController.text,
            ),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      });
    }
  }

  OutlineInputBorder _buildInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.w),
      borderSide: BorderSide(color: borderColor, width: 2),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      enabledBorder: _buildInputBorder(Colors.grey.shade300),
      focusedBorder: _buildInputBorder(const Color(0xFF006257)),
      errorBorder: _buildInputBorder(Colors.red),
      focusedErrorBorder: _buildInputBorder(Colors.red),
    );
  }

  Widget _buildMobileNumberField() {
    return TextFormField(
      controller: mobileNumberController,
      keyboardType: TextInputType.phone,
      decoration: _buildInputDecoration('Mobile Number'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your Mobile Number';
        } else if (value.length < 10 ||
            value.length > 12 ||
            !RegExp(r'^[0-9]+$').hasMatch(value)) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
      style: TextStyle(fontSize: 16.sp),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText, {
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: _buildInputDecoration(labelText),
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your $labelText';
        if (labelText == 'Email' &&
            !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
        if (labelText == 'Password' && value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        if (labelText == 'Confirm Password') {
          if (value != passwordController.text) {
            return 'Passwords do not match';
          }
        }
        return null;
      },
      style: TextStyle(fontSize: 16.sp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Center the animated form and content
          Expanded(
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50.h),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 38.w),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 37,
                                  width: 61,
                                  child: Image.asset(
                                    'assets/images/logo1.png',
                                    height: 100.h,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  'Create Account',
                                  style: GoogleFonts.dmSans(
                                    letterSpacing: -0.5.w,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                _buildTextFormField(
                                    fullNameController, 'Full Name'),
                                SizedBox(height: 20.h),
                                _buildTextFormField(emailController, 'Email'),
                                SizedBox(height: 20.h),
                                _buildTextFormField(
                                    passwordController, 'Password',
                                    obscureText: true),
                                SizedBox(height: 20.h),
                                _buildTextFormField(confirmPasswordController,
                                    'Confirm Password',
                                    obscureText: true),
                                SizedBox(height: 20.h),
                                _buildMobileNumberField(),
                                SizedBox(height: 30.h),
                                GestureDetector(
                                  onTap: _isLoading ? null : _handleRegister,
                                  child: Container(
                                    width: 143.w,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      color: _isLoading
                                          ? Colors.grey.shade500
                                          : const Color.fromARGB(255, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(40.r),
                                    ),
                                    child: Center(
                                      child: _isLoading
                                          ? SizedBox(
                                              height: 20.h,
                                              width: 20.w,
                                              child:
                                                  const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Register',
                                                  style: GoogleFonts.dmSans(
                                                    color: Colors.white,
                                                    letterSpacing: -0.5.w,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                SizedBox(width: 6.w),
                                                const Icon(
                                                  Icons.arrow_forward_sharp,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 23,
                                      width: 23,
                                      child: SvgPicture.asset(
                                          'assets/images/google 1.svg'),
                                    ),
                                    const SizedBox(width: 10),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Register with',
                                            style: GoogleFonts.dmSans(
                                              color: Colors.black,
                                              letterSpacing: -0.5.w,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' Google',
                                            style: GoogleFonts.dmSans(
                                              color: Colors.black,
                                              letterSpacing: -0.5.w,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Static bottom section
          Padding(
            padding: EdgeInsets.only(bottom: 23.h),
            child: Column(
              children: [
                const Divider(indent: 0, endIndent: 0),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.dmSans(
                        letterSpacing: -0.5.w,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(46, 53, 58, 0.44),
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Login Here',
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5.w,
                          fontSize: 14.sp,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const LoginPage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
