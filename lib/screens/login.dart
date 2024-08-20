// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:amset/screens/RegisterPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:amset/screens/dashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer'; // Import the developer package for logging
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 20.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(
                    'assets/images/login.png',
                    height: 250.h,
                    width: 250.w,
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      controller: _fullnameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Fullname';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        labelText: 'Full Name',
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(18.w)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.w)),
                          borderSide: const BorderSide(
                              color: Color(0xFF006257), width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(18.w)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.w)),
                          borderSide: const BorderSide(
                              color: Color(0xFF006257), width: 2),
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(18.w)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18.w)),
                          borderSide: const BorderSide(
                              color: Color(0xFF006257), width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      obscureText: !_isPasswordVisible,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      color: const Color(0xFF006257),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006257),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 80.w,
                          vertical: 15.h,
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Login',
                              style: TextStyle(fontSize: 18.sp),
                            ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  RichText(
                    text: TextSpan(
                        text: "Don't have an account?  ",
                        style: const TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Sign Up",
                              style: const TextStyle(
                                  color: Color(0xFF006257),
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const RegisterPage();
                                  }));
                                })
                        ]),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    width: 110.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Image.asset(
                    //       'assets/images/logo1.png',
                    //       height: 30.h,
                    //       width: 30.h,
                    //     ),
                    //     SizedBox(width: 5.w),
                    //     Text(
                    //       'amset',
                    //       style: GoogleFonts.prozaLibre(
                    //         textStyle: TextStyle(
                    //           color: const Color.fromARGB(255, 0, 0, 0),
                    //           fontSize: 18.sp,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
