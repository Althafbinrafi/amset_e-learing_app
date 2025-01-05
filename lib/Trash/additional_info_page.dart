// import 'dart:convert';
// import 'dart:developer';

// import 'package:amset/Api%20Services/registration_service.dart';
// import 'package:amset/Widgets/otp_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// class AdditionalInfoPage extends StatefulWidget {
//   final Map<String, String> basicInfo;

//   const AdditionalInfoPage({Key? key, required this.basicInfo}) : super(key: key);

//   @override
//   State<AdditionalInfoPage> createState() => _AdditionalInfoPageState();
// }

// class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
//   final _formKey = GlobalKey<FormState>();
//   final ApiServiceReg _apiService = ApiServiceReg();
//   bool _isLoading = false;

//   String country = 'India';
//   String experience = 'Fresher';
//   String experienceSector = 'Supermarket';

//   Future<void> _handleRegister() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         final registrationModel = await _apiService.registerUser(
//           fullName: widget.basicInfo['fullName']!,
//           username: widget.basicInfo['username']!,
//           email: widget.basicInfo['email']!,
//           password: widget.basicInfo['password']!,
//           mobileNumber: widget.basicInfo['mobileNumber']!,
//           // Replace these fields with the selected values
//           country: country,
//           experience: experience,
//           experienceSector: experienceSector,
//         );

//         if (registrationModel.success) {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           await prefs.setBool('isLoggedIn', true);
//           await prefs.setString('fullName', widget.basicInfo['fullName']!);
//           await prefs.setString('username', widget.basicInfo['username']!);
//           await prefs.setString('email', widget.basicInfo['email']!);
//           await prefs.setString('phone', widget.basicInfo['mobileNumber']!);

//           if (!mounted) return;
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OtpVerificationPage(
//                 mobileNumber: widget.basicInfo['mobileNumber']!,
//               ),
//             ),
//           );
//         } else {
//           _showErrorSnackBar(registrationModel.message);
//         }
//       } catch (e) {
//         _showErrorSnackBar('An error occurred during registration');
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   String _extractErrorMessage(String errorString) {
//     try {
//       // First, find the JSON part of the error string
//       const pattern = r'{"error":"(.*?)"}';
//       final regexp = RegExp(pattern);
//       final match = regexp.firstMatch(errorString);

//       if (match != null && match.groupCount >= 1) {
//         String errorMessage = match.group(1) ?? '';

//         // Check for specific error messages
//         if (errorMessage.toLowerCase().contains('email') &&
//             errorMessage.toLowerCase().contains('registered')) {
//           return 'This email is already registered';
//         }
//         if (errorMessage.toLowerCase().contains('username') &&
//             errorMessage.toLowerCase().contains('exists')) {
//           return 'This username is already taken';
//         }
//         if (errorMessage.toLowerCase().contains('phone') ||
//             errorMessage.toLowerCase().contains('mobile')) {
//           return 'This phone number is already registered';
//         }

//         return errorMessage;
//       }

//       // Fallback for other error formats
//       if (errorString.contains('{') && errorString.contains('}')) {
//         final start = errorString.lastIndexOf('{');
//         final end = errorString.lastIndexOf('}') + 1;
//         final jsonStr = errorString.substring(start, end);

//         final errorJson = json.decode(jsonStr);
//         if (errorJson.containsKey('error')) {
//           return errorJson['error'];
//         }
//         if (errorJson.containsKey('message')) {
//           return errorJson['message'];
//         }
//       }

//       return 'An error occurred during registration';
//     } catch (e) {
//       log("Error parsing error message: $e");
//       return 'An error occurred during registration';
//     }
//   }

// // Helper method to show error SnackBar
//   void _showErrorSnackBar(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 3),
//         action: SnackBarAction(
//           label: 'Dismiss',
//           textColor: Colors.white,
//           onPressed: () {
//             ScaffoldMessenger.of(context).hideCurrentSnackBar();
//           },
//         ),
//       ),
//     );
//   }

//   void _selectCountry() {
//     // Logic for country selection
//     setState(() {
//       country = 'Selected Country'; // Example selection
//     });
//   }

//   void _selectExperience() {
//     // Logic for experience selection
//     setState(() {
//       experience = 'Selected Experience'; // Example selection
//     });
//   }

//   void _selectExperienceSector() {
//     // Logic for experience sector selection
//     setState(() {
//       experienceSector = 'Selected Sector'; // Example selection
//     });
//   }

//   Widget _buildInfoTile(String label, String value, VoidCallback onChange) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10.h),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(20.w),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   label == 'Current Location'
//                       ? Icons.flag
//                       : label == 'Experience'
//                           ? Icons.person
//                           : Icons.store,
//                   color: Colors.grey.shade600,
//                 ),
//                 SizedBox(width: 10.w),
//                 Text(
//                   value,
//                   style: GoogleFonts.dmSans(
//                     fontSize: 16.sp,
//                     color: Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//             GestureDetector(
//               onTap: onChange,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
//                 decoration: BoxDecoration(
//                   color: Colors.green.shade100,
//                   borderRadius: BorderRadius.circular(20.r),
//                 ),
//                 child: Text(
//                   'Change',
//                   style: GoogleFonts.dmSans(
//                     color: Colors.green,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Tell Us About Yourself',
//                   style: GoogleFonts.dmSans(
//                     fontSize: 24.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 Text(
//                   'Help us personalize your experience by telling us your employment status',
//                   textAlign: TextAlign.center,
//                   style: GoogleFonts.dmSans(
//                     fontSize: 14.sp,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//                 SizedBox(height: 40.h),
//                 _buildInfoTile('Current Location', country, _selectCountry),
//                 _buildInfoTile('Experience', experience, _selectExperience),
//                 _buildInfoTile('Experienced Sector', experienceSector, _selectExperienceSector),
//                 SizedBox(height: 40.h),
//                 GestureDetector(
//                   onTap: _isLoading ? null : _handleRegister,
//                   child: Container(
//                     width: double.infinity,
//                     height: 50.h,
//                     decoration: BoxDecoration(
//                       color: _isLoading ? Colors.grey.shade500 : Colors.black,
//                       borderRadius: BorderRadius.circular(25.r),
//                     ),
//                     child: Center(
//                       child: _isLoading
//                           ? CircularProgressIndicator(
//                               strokeWidth: 2,
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             )
//                           : Text(
//                               'Next',
//                               style: GoogleFonts.dmSans(
//                                 color: Colors.white,
//                                 fontSize: 18.sp,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
