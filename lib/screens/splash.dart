// import 'package:amset/screens/skip.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:package_info_plus/package_info_plus.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   String _version = '';

//   @override
//   void initState() {
//     super.initState();
//     _getVersion();
//     // Set up a timer to navigate to the SkipPage after 3 seconds
//     Timer(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => const SkipPage()),
//       );
//     });
//   }

//   Future<void> _getVersion() async {
//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     setState(() {
//       _version = 'Version ${packageInfo.version}';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF006257),
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/logo.png',
//                 height: 170,
//                 width: 170,
//                 // ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Text(
//                 //     _version,
//                 //     style: const TextStyle(
//                 //       color: Colors.white,
//                 //       fontSize: 16,
//                 //       fontWeight: FontWeight.w500,
//                 //     ),
//                 //   ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
