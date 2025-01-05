import 'package:amset/Widgets/otp_page.dart';
import 'package:amset/screens/DrawerPages/PrivacyPolicy/security_policy.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';

import '../DrawerPages/T and C/t_and_c.dart';

class TellUsAboutPage extends StatefulWidget {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String mobileNumber;

  const TellUsAboutPage({
    super.key,
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.mobileNumber,
  });

  @override
  State<TellUsAboutPage> createState() => _TellUsAboutPageState();
}

class _TellUsAboutPageState extends State<TellUsAboutPage> {
  String selectedLocation = "India";
  String selectedExperience = "Fresher";
  String selectedSector = "Supermarket";
  bool isLoading = false;
  bool hasAgreedToTerms = false;

  void _onNextButtonPressed() {
    if (!hasAgreedToTerms) return;

    // Show confirmation drawer for mobile number
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _buildMobileConfirmationDrawer();
      },
    );
  }

  final List<String> gccCountries = [
    "India",
    "Saudi Arabia",
    "UAE",
    "Kuwait",
    "Oman",
    "Qatar",
    "Bahrain"
  ];

  final List<String> experienceOptions = [
    "Fresher",
    "1-3 years",
    "3-5 years",
    "Above 5 years"
  ];

  final List<String> sectorOptions = [
    "Supermarket",
    "Cashier",
    "Accountant",
    "Salesman"
  ];

  void showDropdownDialog({
    required String title,
    required List<String> options,
    required String currentValue,
    required void Function(String) onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 10.h),
              ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  return ListTile(
                    title: Text(
                      option,
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        letterSpacing: -0.3,
                      ),
                    ),
                    trailing: currentValue == option
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      onChanged(option);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToOtpVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationPage(
          fullName: widget.fullName,
          username: widget.username,
          email: widget.email,
          password: widget.password,
          mobileNumber: widget.mobileNumber,
          location: selectedLocation,
          experience: selectedExperience,
          sector: selectedSector,
        ),
      ),
    );
  }

  void _navigateToPrivacyPolicy() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SecurityPolicy();
    }));
  }

  void _navigateToTermsOfService() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const TermsAndConditionsPage();
    }));
  }

  Widget _buildMobileConfirmationDrawer() {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 18.w,
        right: 18.w,
        top: 25.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Confirm Mobile Number',
            style: GoogleFonts.dmSans(
              fontSize: 18.5.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Is this your correct mobile number?",
            style: GoogleFonts.dmSans(
                fontSize: 16.sp, letterSpacing: -0.5, color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          Text(
            widget.mobileNumber,
            style: GoogleFonts.dmSans(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.3.sp),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              // Expanded(
              //   child: TextButton(
              //     onPressed: () => Navigator.pop(context),
              //     style: TextButton.styleFrom(
              //       backgroundColor: Colors.grey.shade300,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20.r),
              //       ),
              //     ),
              //     child: Text(
              //       "Cancel",
              //       style: GoogleFonts.dmSans(
              //         fontSize: 16.sp,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(width: 16.w),
              Expanded(
                child: TextButton(
                  
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                    _navigateToOtpVerification(); // Navigate to OTP Page
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget buildEditableField({
    required String label,
    required String value,
    Widget? icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 14.sp,
            color: Colors.grey,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                icon,
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(186, 233, 155, 0.965),
                    borderRadius: BorderRadius.circular(11.r),
                  ),
                  child: Text(
                    "Change",
                    style: GoogleFonts.dmSans(
                      fontSize: 14.sp,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Tell Us\nAbout Yourself",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 31.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 19.h),
                  Text(
                    "Help us personalize your experience\nby telling us your employment status",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      color: Colors.grey,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  buildEditableField(
                    label: "Current Location",
                    value: selectedLocation,
                    icon: const Icon(Icons.location_on_outlined,
                        color: Colors.black),
                    onTap: () {
                      showDropdownDialog(
                        title: "Select Location",
                        options: gccCountries,
                        currentValue: selectedLocation,
                        onChanged: (value) {
                          setState(() {
                            selectedLocation = value;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  buildEditableField(
                    label: "Experience",
                    value: selectedExperience,
                    icon: const Icon(Icons.person_outline, color: Colors.black),
                    onTap: () {
                      showDropdownDialog(
                        title: "Select Experience",
                        options: experienceOptions,
                        currentValue: selectedExperience,
                        onChanged: (value) {
                          setState(() {
                            selectedExperience = value;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  buildEditableField(
                    label: "Experienced Sector",
                    value: selectedSector,
                    icon: const Icon(Icons.storefront_outlined,
                        color: Colors.black),
                    onTap: () {
                      showDropdownDialog(
                        title: "Select Sector",
                        options: sectorOptions,
                        currentValue: selectedSector,
                        onChanged: (value) {
                          setState(() {
                            selectedSector = value;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 37.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: hasAgreedToTerms,
                        onChanged: (value) {
                          setState(() {
                            hasAgreedToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'By continuing, you agree to AMSET\'s ',
                            style: GoogleFonts.dmSans(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14.sp,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _navigateToTermsOfService,
                              ),
                              TextSpan(
                                text: ' and ',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: 'Security Policy',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14.sp,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _navigateToPrivacyPolicy,
                              ),
                              TextSpan(
                                text: '.',
                                style: GoogleFonts.dmSans(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 37.h),
                  GestureDetector(
                    onTap: (isLoading || !hasAgreedToTerms)
                        ? null
                        : _onNextButtonPressed,
                    child: Container(
                      width: 130.w,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: hasAgreedToTerms
                            ? const Color.fromRGBO(46, 53, 58, 1)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading)
                            SizedBox(
                              height: 25.w,
                              width: 25.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          else
                            Text(
                              'Next',
                              style: GoogleFonts.dmSans(
                                fontSize: 19.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
