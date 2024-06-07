import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Import SharedPreferences

import 'package:amset/screens/skip.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SkipPage(),
    );
  }
}
