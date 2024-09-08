import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:amset/screens/register_page.dart';
import 'package:amset/screens/dashboard.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer'; // Import the developer package for logging
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //bool _isPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        log(response.body);
        if (responseBody['success']) {
          final String token = responseBody['token'];
          final String fullName = _fullnameController.text;
          final String userId = responseBody['user']['_id'];
          final String avatarPath = responseBody['user']['avatarPath'] ??
              'assets/images/man.png'; // Assuming avatarPath is returned from the API
          final String email = responseBody['user']['email'];

          // Store the token, full name, user ID, and email
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('full_name', fullName);
          await prefs.setString('user_id', userId);
          await prefs.setString('email', email);
          await prefs.setString('avatar_path', avatarPath);

          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Dashboard(fullName: fullName, avatarPath: avatarPath),
            ),
          );
        } else {
          _showError(responseBody['message']);
          log('Login failed: ${responseBody['message']}');
        }
      } else {
        _showError('Failed to login. Please try again.');
        log('HTTP error: ${response.statusCode} - ${response.reasonPhrase}');
        log('Response body: ${response.body}');
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
      log('Exception: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Centered content
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      100.h, // Ensure no overflow
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 50.h),
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
                        'Login to Your\n     Success',
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5.w,
                          color: Colors.black,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: TextFormField(
                                controller: _fullnameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your Fullname';
                                  }
                                  return null;
                                },
                                decoration: _buildInputDecoration('Full Name'),
                                style: GoogleFonts.dmSans(
                                    fontSize: 16.sp, letterSpacing: -0.5.w),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email cannot be empty';
                                  }
                                  return null;
                                },
                                decoration: _buildInputDecoration('Email'),
                                style: GoogleFonts.dmSans(
                                    fontSize: 16.sp, letterSpacing: -0.5.w),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your Password';
                                  }
                                  return null;
                                },
                                decoration: _buildInputDecoration('Password'),
                                style: GoogleFonts.dmSans(
                                    fontSize: 16.sp, letterSpacing: -0.5.w),
                              ),
                            ),
                            SizedBox(height: 40.h),
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _login().then((_) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  });
                                }
                              },
                              child: Container(
                                width: 143.w,
                                height: 45.h,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(40.r),
                                ),
                                child: Center(
                                  child: _isLoading
                                      ? SizedBox(
                                          height: 20.h,
                                          width: 20.w,
                                          child:
                                              const CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
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
                                        'assets/images/google 1.svg')),
                                const SizedBox(width: 10),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Register with',
                                        style: GoogleFonts.dmSans(
                                            color: Colors.black,
                                            letterSpacing: -0.5.w,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400)),
                                    TextSpan(
                                        text: ' Google',
                                        style: GoogleFonts.dmSans(
                                            color: Colors.black,
                                            letterSpacing: -0.5.w,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600)),
                                  ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider and bottom text
                Column(
                  children: [
                    Divider(
                      color: Colors.grey.shade300,
                      height: 30.h,
                      thickness: 1.5,
                    ),
                    SizedBox(height: 15.h),
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account?  ",
                        style: GoogleFonts.dmSans(
                          letterSpacing: -0.5.w,
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                          color: const Color.fromRGBO(46, 53, 58, 0.44),
                        ),
                        children: [
                          TextSpan(
                            text: "Register Here",
                            style: GoogleFonts.dmSans(
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const Registerpage(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
