import 'package:flutter/material.dart';

import 'package:amset/screens/dashboard.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final String fullName;
  const LoginPage({super.key, required this.fullName});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://amset-server.vercel.app/api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success']) {
        // Extract the necessary data from response
        final String token = responseBody['token'];
        final String userId = responseBody['user']['_id']; // Get userId
        final String avatarPath =
            responseBody['user']['avatarPath'] ?? 'assets/images/man.png';
        final String email = responseBody['user']['email'];
        final String username = responseBody['user']['username'];
        final String mobileNumber = responseBody['user']['mobileNumber'];

        // Store user data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);
        await prefs.setString('email', email);
        await prefs.setString('avatar_path', avatarPath);
        await prefs.setString('username', username);
        await prefs.setString('mobileNumber', mobileNumber);

        if (!mounted) return;

        // Navigate to dashboard and pass userId
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(
                // fullName: widget.fullName,

                ),
          ),
        );
      } else {
        // Handle errors appropriately
        _showError(
            responseBody['message'] ?? 'Failed to login. Please try again.');
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
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
      suffixIcon: labelText == 'Password'
          ? IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 50.h),
                              SizedBox(
                                height: 37.h,
                                width: 61.w,
                                child: Image.asset(
                                  'assets/images/logo1.png',
                                  height: 100.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 21.h),
                              Text(
                                'Login to Your\n    Success',
                                style: GoogleFonts.dmSans(
                                  letterSpacing: -0.5.w,
                                  color: Colors.black,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 33.h),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: TextFormField(
                                        controller: _emailController,
                                        validator: _validateEmail,
                                        decoration:
                                            _buildInputDecoration('Email'),
                                        style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            letterSpacing: -0.5.w),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter your Password';
                                          }
                                          return null;
                                        },
                                        decoration:
                                            _buildInputDecoration('Password'),
                                        obscureText: _obscurePassword,
                                        style: GoogleFonts.dmSans(
                                            fontSize: 16.sp,
                                            letterSpacing: -0.5.w),
                                      ),
                                    ),
                                    SizedBox(height: 40.h),
                                    GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          _login();
                                        }
                                      },
                                      child: Container(
                                        width: 143.w,
                                        height: 45.h,
                                        decoration: BoxDecoration(
                                          color: _isLoading
                                              ? Colors.grey
                                              : const Color.fromRGBO(
                                                  46, 53, 58, 1),
                                          borderRadius:
                                              BorderRadius.circular(40.r),
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
                                                                Color>(
                                                            Colors.white),
                                                  ),
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Login',
                                                      style: GoogleFonts.dmSans(
                                                        letterSpacing: -0.5.w,
                                                        color: Colors.white,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 23.h),
                child: Column(
                  children: [
                    const Divider(height: 0),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.dmSans(
                            letterSpacing: -0.5.w,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: const Color.fromRGBO(46, 53, 58, 0.44),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            "Register Here",
                            style: GoogleFonts.dmSans(
                              color: Colors.green,
                              letterSpacing: -0.5.w,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          onTap: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            if (!context.mounted) return;

                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const RegisterPage(),
                                transitionDuration:
                                    Duration.zero, // No animation
                                reverseTransitionDuration:
                                    Duration.zero, // No animation on pop
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
      },
    );
  }
}
