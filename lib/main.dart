import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:amset/screens/skip.dart';
import 'package:amset/screens/dashboard.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent, // Set status bar color
    statusBarIconBrightness:
        Brightness.light, // Set status bar icons to dark color
    systemNavigationBarColor: Colors.black, // Set system navigation bar color
    systemNavigationBarIconBrightness:
        Brightness.dark, // Set system navigation bar icons to dark color
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF006257)),
        useMaterial3: true,
      ),
      home: const AuthCheckPage(),
    );
  }
}

class AuthCheckPage extends StatefulWidget {
  const AuthCheckPage({Key? key}) : super(key: key);

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
    String? token = prefs.getString('auth_token');
    String? fullName = prefs.getString('full_name');
    String? userId = prefs.getString('user_id');

    if (token != null && fullName != null && userId != null) {
      // Token exists, navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(fullName: fullName),
        ),
      );
    } else {
      // Token doesn't exist, navigate to SkipPage (or LoginPage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SkipPage(),
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
