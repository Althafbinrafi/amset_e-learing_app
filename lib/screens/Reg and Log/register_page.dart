import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../Pre Dashboard Pages/tell_us_about_page.dart';
import 'login.dart';

class PhoneNumberController extends TextEditingController {
  String? completeNumber;
  String? countryCode;
  String? number;

  void updatePhoneNumber({
    required String completeNumber,
    required String countryCode,
    required String number,
  }) {
    this.completeNumber = completeNumber;
    this.countryCode = countryCode;
    this.number = number;
    // Update the text field to show only the number
    text = number;
    notifyListeners();
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form field controllers
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  PhoneNumberController mobileNumberController = PhoneNumberController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  void _navigateToMoreDetails() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TellUsAboutPage(
            fullName: fullNameController.text,
            username: usernameController.text,
            email: emailController.text,
            password: passwordController.text,
            mobileNumber: mobileNumberController.completeNumber ?? '',
          ),
        ),
      );
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
    return IntlPhoneField(
      controller: mobileNumberController,
      decoration: _buildInputDecoration('Mobile Number'),
      initialCountryCode: 'IN',
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.number.isEmpty) {
          return 'Enter your Mobile Number';
        } else if (value.number.length < 10 || value.number.length > 12) {
          return 'Please enter a valid mobile number';
        }
        return null;
      },
      style: TextStyle(fontSize: 16.sp),
      onChanged: (phone) {
        // Update the controller with phone details but show only the number
        mobileNumberController.updatePhoneNumber(
          completeNumber: phone.completeNumber,
          countryCode: phone.countryCode,
          number: phone.number,
        );

        log('Complete Number: ${mobileNumberController.completeNumber}');
        log('Country Code: ${mobileNumberController.countryCode}');
        log('Number: ${mobileNumberController.number}');
      },
      disableLengthCheck:
          true, // This prevents length validation by the field itself
      flagsButtonPadding: EdgeInsets.symmetric(horizontal: 10.w),
    );
  }

  Widget _buildTextFormField(
    TextEditingController controller,
    String labelText, {
    bool isPasswordField = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPasswordField
          ? (labelText == 'Password'
              ? _obscurePassword
              : _obscureConfirmPassword)
          : false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        enabledBorder: _buildInputBorder(Colors.grey.shade300),
        focusedBorder: _buildInputBorder(const Color(0xFF006257)),
        errorBorder: _buildInputBorder(Colors.red),
        focusedErrorBorder: _buildInputBorder(Colors.red),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  (labelText == 'Password'
                          ? _obscurePassword
                          : _obscureConfirmPassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (labelText == 'Password') {
                      _obscurePassword = !_obscurePassword;
                    } else {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    }
                  });
                },
              )
            : null,
      ),
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
                                _buildTextFormField(
                                    usernameController, 'Username'),
                                SizedBox(height: 20.h),
                                _buildTextFormField(emailController, 'Email'),
                                SizedBox(height: 20.h),
                                _buildTextFormField(
                                    passwordController, 'Password',
                                    isPasswordField: true),
                                SizedBox(height: 20.h),
                                _buildTextFormField(confirmPasswordController,
                                    'Confirm Password',
                                    isPasswordField: true),
                                SizedBox(height: 20.h),
                                _buildMobileNumberField(),
                                SizedBox(height: 30.h),
                                GestureDetector(
                                  onTap: _navigateToMoreDetails,
                                  child: Container(
                                    width: 143.w,
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(40.r),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Next',
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
                      onTap: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
                        if (!context.mounted) return;
                        {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const LoginPage(
                                fullName: '',
                              ),
                              transitionDuration: Duration.zero, // No animation
                              reverseTransitionDuration:
                                  Duration.zero, // No animation on pop
                            ),
                          );
                        }
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
