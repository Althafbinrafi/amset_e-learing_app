import 'package:amset/screens/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
              //key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  Text(
                    'Register Here',
                    style: TextStyle(
                        color: Color(0xFF006257),
                        fontWeight: FontWeight.w700,
                        fontSize: 40.sp),
                  ),
                  SizedBox(
                    height: 90.h,
                  ),
// Fullname........................................//
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      // controller: _fullnameController,
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
// Mobile Number........................................//
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      // controller: _fullnameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Mobile Number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 20.h,
                        ),
                        labelText: 'Mobile Number',
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
// Email........................................//
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      // controller: _emailController,
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
// password ........................................//
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      //   controller: _passwordController,
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
                            // _isPasswordVisible
                            //     ? Icons.visibility
                            //     :
                            Icons.visibility_off,
                            // color: Colors.grey,
                          ),
                          onPressed: () {
                            // setState(() {
                            //   _isPasswordVisible = !_isPasswordVisible;
                            // });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      //    obscureText: !_isPasswordVisible,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: TextFormField(
                      //   controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirm your Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        labelText: 'Confirm Password',
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
                            // _isPasswordVisible
                            //     ? Icons.visibility
                            //     :
                            Icons.visibility_off,
                            // color: Colors.grey,
                          ),
                          onPressed: () {
                            // setState(() {
                            //   _isPasswordVisible = !_isPasswordVisible;
                            // });
                          },
                        ),
                      ),
                      style: const TextStyle(color: Colors.black),
                      //    obscureText: !_isPasswordVisible,
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
                        // if (_formKey.currentState!.validate()) {
                        //   setState(() {
                        //     _isLoading = true;
                        //   });
                        //   _login().then((_) {
                        //     setState(() {
                        //       _isLoading = false;
                        //     });
                        //   });
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006257),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 80.w,
                          vertical: 15.h,
                        ),
                      ),
                      child:
                          // _isLoading
                          //   ?
                          //     SizedBox(
                          //   height: 20.h,
                          //   width: 20.w,
                          //   child: const CircularProgressIndicator(
                          //     valueColor:
                          //         AlwaysStoppedAnimation<Color>(Colors.white),
                          //   ),
                          // ),
                          // :
                          Text(
                        'Create Account',
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  RichText(
                    text: TextSpan(
                        text: "Already have an account?  ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                              text: "Log In",
                              style: TextStyle(
                                  color: const Color(0xFF006257),
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return LoginPage();
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo1.png',
                          height: 30.h,
                          width: 30.h,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'amset',
                          style: GoogleFonts.prozaLibre(
                            textStyle: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
    );
  }
}
