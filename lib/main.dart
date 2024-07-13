import 'package:amset/screens/dashboard.dart';
import 'package:amset/screens/skip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent, // Set status bar color
    statusBarIconBrightness:
        Brightness.light, // Set status bar icons to dark color
    systemNavigationBarColor: Colors.black, // Set system navigation bar color
    systemNavigationBarIconBrightness:
        Brightness.dark, // Set system navigation bar icons to dark color
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
          title: 'Skip Page',
          theme: ThemeData(
              //primarySwatch: Colors.blue,
              primaryColor: Color(0xFF006257),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Color(0xFF006257),
              )),
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
    String? token = prefs.getString('auth_token');
    String? fullName = prefs.getString('full_name');
    String? userId = prefs.getString('user_id');
    String? avatarPath = prefs.getString('avatar_path');

    if (token != null &&
        fullName != null &&
        userId != null &&
        avatarPath != null) {
      // Token exists, navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Dashboard(fullName: fullName, avatarPath: avatarPath),
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
