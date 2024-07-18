// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  String _fullName = 'Your Name';
  String _email = 'example@gmail.com';
  String _phone = 'Add your phone number';
  String _avatarPath = 'assets/images/man.png';

  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String get avatarPath => _avatarPath;

  UserProfileProvider() {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fullName = prefs.getString('full_name') ?? _fullName;
    _email = prefs.getString('email') ?? _email;
    _phone = prefs.getString('phone') ?? _phone;
    _avatarPath = prefs.getString('avatar_path') ?? _avatarPath;
    notifyListeners();
  }

  Future<void> updateProfile(String fullName, String email, String phone, String avatarPath) async {
    _fullName = fullName;
    _email = email;
    _phone = phone;
    _avatarPath = avatarPath;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', _fullName);
    await prefs.setString('email', _email);
    await prefs.setString('phone', _phone);
    await prefs.setString('avatar_path', _avatarPath);
    notifyListeners();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _fullName = 'Your Name';
    _email = 'example@gmail.com';
    _phone = 'Add your phone number';
    _avatarPath = 'assets/images/man.png';
    notifyListeners();
  }
}
