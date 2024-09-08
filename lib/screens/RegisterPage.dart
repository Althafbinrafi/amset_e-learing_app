import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'login.dart'; // Ensure the correct path to the LoginPage is used

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Form field controllers
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  // OTP TextEditingControllers for each digit
  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(4, (index) => FocusNode());

  bool _isLoading = false; // Loading state for OTP verification

  void _nextPage() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleVerifyOtp() async {
    if (_validateOtp()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LottieSuccessPage(),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  bool _validateOtp() {
    for (var controller in otpControllers) {
      if (controller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return false;
      }
    }
    return true;
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

  // Updated method to build the mobile number input field
  Widget _buildMobileNumberField() {
    return TextFormField(
      controller: mobileNumberController,
      keyboardType: TextInputType.phone,
      decoration: _buildInputDecoration('Mobile Number'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your Mobile Number';
        }
        return null;
      },
      style: TextStyle(fontSize: 16.sp),
    );
  }

  // Method to build text form fields
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
        if (labelText == 'Confirm Password' &&
            value != passwordController.text) {
          return 'Passwords do not match';
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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildRegistrationForm(),
          _buildOtpVerificationPage(),
        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center vertically
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Center horizontally
                children: [
                  SizedBox(height: 50.h), // Add some top padding
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
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          _buildTextFormField(fullNameController, 'Full Name'),
                          SizedBox(height: 20.h),
                          _buildTextFormField(emailController, 'Email'),
                          SizedBox(height: 20.h),
                          _buildTextFormField(passwordController, 'Password',
                              obscureText: true),
                          SizedBox(height: 20.h),
                          _buildTextFormField(
                              confirmPasswordController, 'Confirm Password',
                              obscureText: true),
                          SizedBox(height: 20.h),
                          _buildMobileNumberField(),
                          SizedBox(height: 30.h),
                          GestureDetector(
                            onTap: _nextPage,
                            child: Container(
                              width: 143.w,
                              height: 45.h,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 0, 0, 0),
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Register',
                                      style: GoogleFonts.dmSans(
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
                              SizedBox(width: 10),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Register with',
                                      style: GoogleFonts.dmSans(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400)),
                                  TextSpan(
                                      text: ' Google',
                                      style: GoogleFonts.dmSans(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600)),
                                ]),
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
          Padding(
            padding: EdgeInsets.only(bottom: 30.h), // Add some bottom padding
            child: Column(
              children: [
                Divider(indent: 0, endIndent: 0),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(46, 53, 58, 0.44),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Login',
                        style: GoogleFonts.dmSans(
                            color: Colors.green, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage();
                        }));
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpVerificationPage() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Text(
                'OTP Verification',
                style: TextStyle(
                  color: const Color(0xFF006257),
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                'Enter the 4-digit code sent to your mobile number',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
              ),
              SizedBox(height: 30.h),
              _buildOtpFields(),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: _handleVerifyOtp,
                child: Container(
                  width: 133.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF006257),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verify OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return _buildOtpBox(index);
      }),
    );
  }

  Widget _buildOtpBox(int index) {
    return Row(
      children: [
        SizedBox(
          width: 50.w,
          height: 70.h,
          child: TextFormField(
            controller: otpControllers[index],
            focusNode: otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: _buildInputBorder(Colors.grey.shade300),
              focusedBorder: _buildInputBorder(const Color(0xFF006257)),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '';
              }
              return null;
            },
            style: TextStyle(fontSize: 24.sp),
          ),
        ),
        SizedBox(width: 9.w),
      ],
    );
  }
}

// Lottie Success Page with animation
class LottieSuccessPage extends StatelessWidget {
  const LottieSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/images/Animation - 1724224199479.json',
          width: 150.w,
          height: 150.h,
          repeat: false,
        ),
      ),
    );
  }
}
