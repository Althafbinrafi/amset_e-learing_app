// ignore_for_file: use_build_context_synchronously

import 'package:amset/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart'; // Import the Lottie package

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _currentPage = 0;

  // Form field controllers
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  List<String> jobCategories = [
    'Engineering',
    'Marketing',
    'Sales',
    'Design',
    'Developer',
    'UI/UX',
    'Saloon & Spa'
  ];
  List<String> selectedCategories = [];

  // Country code options
  String selectedCountryCode = '+91'; // Default country code
  List<String> countryCodes = ['+1', '+91', '+44', '+61', '+81', '+86'];

  // OTP TextEditingControllers for each digit
  List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());
  List<FocusNode> otpFocusNodes = List.generate(4, (index) => FocusNode());

  void _nextPage() {
    if (_currentPage < 3) {
      setState(() {
        _currentPage++;
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      });
    } else {
      // Final submit logic
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Submitted!')),
        );
      }
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      });
    }
  }

  OutlineInputBorder _buildInputBorder(Color borderColor) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.w),
      borderSide: BorderSide(color: borderColor, width: 2),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
      appBar: AppBar(
        toolbarHeight: 90.h,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Register',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22.sp,
          ),
        ),
        backgroundColor: const Color(0xFF37CA00),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildPrimaryDetailsPage(),
            _buildQualificationPage(),
            _buildJobCategoriesPage(),
            _buildOtpPage(), // OTP page integrated here
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _currentPage > 0
                ? ElevatedButton(
                    onPressed: _previousPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade400,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                    ),
                    child: const Text(
                      "Previous",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink(),
            ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006257),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w),
                ),
              ),
              child: Text(
                _currentPage == 3 ? "Submit" : "Next",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryDetailsPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Primary Details',
              style: TextStyle(
                color: const Color(0xFF006257),
                fontSize: 25.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30.h),
            _buildTextFormField(fullNameController, 'Full Name'),
            SizedBox(height: 20.h),
            _buildMobileNumberField(),
            SizedBox(height: 20.h),
            _buildTextFormField(emailController, 'Email'),
            SizedBox(height: 20.h),
            _buildTextFormField(passwordController, 'Password',
                obscureText: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNumberField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country code dropdown
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: DropdownButtonFormField<String>(
              value: selectedCountryCode,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
                enabledBorder: _buildInputBorder(Colors.grey.shade300),
                focusedBorder: _buildInputBorder(const Color(0xFF006257)),
              ),
              items: countryCodes.map((String code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(
                    code,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountryCode = value!;
                });
              },
            ),
          ),
        ),
        // Mobile number input field
        Expanded(
          flex: 5,
          child: TextFormField(
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
          ),
        ),
      ],
    );
  }

  Widget _buildQualificationPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Qualification & Job Details',
              style: TextStyle(
                color: const Color(0xFF006257),
                fontSize: 25.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30.h),
            _buildTextFormField(qualificationController, 'Qualification'),
            SizedBox(height: 20.h),
            _buildTextFormField(experienceController, 'Years of Experience'),
            SizedBox(height: 20.h),
            _buildTextFormField(jobTitleController, 'Last Job Title'),
            SizedBox(height: 20.h),
            _buildTextFormField(companyController, 'Last Company Name'),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCategoriesPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Job Categories',
            style: TextStyle(
              color: const Color(0xFF006257),
              fontSize: 25.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: jobCategories.map((category) {
              bool isSelected = selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedCategories.add(category);
                    } else {
                      selectedCategories.remove(category);
                    }
                  });
                },
                selectedColor: const Color(0xFF006257).withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? const Color(0xFF006257)
                      : Colors.black.withOpacity(0.6),
                  fontSize: 16.sp,
                ),
                backgroundColor: Colors.grey.shade200,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  bool _isLoading = false; // Add this to control the loading state

  Widget _buildOtpPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            // OTP input fields
            _buildOtpFields(),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : _handleVerifyOtp, // Disable button when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006257),
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.w),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Verify OTP',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVerifyOtp() async {
    // Show Lottie animation and then navigate to the login page
    if (_validateOtp()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      await Future.delayed(const Duration(
          seconds: 2)); 
      // Show Lottie animation after loading
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LottieSuccessPage(),
        ),
      );

      await Future.delayed(
          const Duration(seconds: 2)); 

      // Automatically navigate to the login page after Lottie animation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
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
              focusedBorder: _buildInputBorder(Color(0xFF006257)),
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
        SizedBox(
          width: 9.w,
        )
      ],
    );
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

  Future<void> _showLottieAndNavigate() async {
    // Show Lottie animation after successful OTP verification
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LottieSuccessPage(),
      ),
    );

    // Wait for a second and then navigate to login page
    await Future.delayed(const Duration(milliseconds: 100));

    // Navigate to login page
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String labelText,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: _buildInputDecoration(labelText),
      validator: (value) {
        if (value!.isEmpty) return 'Please enter your $labelText';
        return null;
      },
      style: TextStyle(fontSize: 16.sp),
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
          'assets/images/Animation - 1724224199479.json', // Add your Lottie animation file here
          width: 150.w,
          height: 150.h,
          repeat: false,
        ),
      ),
    );
  }
}
