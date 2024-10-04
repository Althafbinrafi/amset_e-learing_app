// ignore_for_file: use_build_context_synchronously

import 'package:amset/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Main Page',
          theme: ThemeData(
            primaryColor: const Color(0xFF006257),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF006257)),
          ),
          home: const AuthCheckPage(),
        );
      },
    );
  }
}

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({super.key});

  @override
  _AuthCheckPageState createState() => _AuthCheckPageState();
}

class _AuthCheckPageState extends State<AuthCheckPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? fullName = prefs.getString('fullName');
    String? email = prefs.getString('email');

    if (isLoggedIn && fullName != null && email != null) {
      // User is logged in, navigate to Dashboard or Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
      );
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}