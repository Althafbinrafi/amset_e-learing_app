// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:amset/screens/skip.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io'; // Import for File

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _fullName = 'Your Name';
  String _email = '';
  String _phone = '';
  String _avatarPath = 'assets/images/man.png';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('full_name') ?? _fullName;
      _email = prefs.getString('email') ?? _email;
      _phone = prefs.getString('phone') ?? _phone;
      _avatarPath = prefs.getString('avatar_path') ?? _avatarPath;
    });
  }

  Future<void> _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentName: _fullName,
          currentEmail: _email,
          currentPhone: _phone,
          currentAvatar: _avatarPath,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _fullName = result['full_name'];
        _email = result['email'];
        _phone = result['phone'];
        _avatarPath = result['avatar_path'];
      });
      _saveProfile();
    }
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', _fullName);
    await prefs.setString('email', _email);
    await prefs.setString('phone', _phone);
    await prefs.setString('avatar_path', _avatarPath);
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('full_name');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('avatar_path');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SkipPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006257),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF006257),
              child: const Center(
                child: Text(
                  'User Profile',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            height: 0.7.sh, // Using 70% of the screen height
            width: 1.sw, // Using the full screen width
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _editProfile,
                      
                      child: Container(
                        padding: EdgeInsets.all(5.w),
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.r),
                          color: const Color(0xFF006257),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 30,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  maxRadius: 90.r,
                  backgroundColor: Colors.transparent,
                  child: SizedBox(
                    height: 170.h,
                    width: 170.w,
                    child: ClipOval(
                      child: _avatarPath.isNotEmpty &&
                              _avatarPath != 'assets/images/man.png'
                          ? Image.file(
                              File(_avatarPath),
                              fit: BoxFit.cover,
                            )
                          : Image.asset('assets/images/man.png'),
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  _fullName,
                  style: TextStyle(fontSize: 22.sp),
                ),
                SizedBox(height: 20.h),
                Text(
                  _email,
                  style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                ),
                SizedBox(height: 10.h),
                Text(
                  _phone,
                  style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                ),
                SizedBox(height: 50.h),
                Container(
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF006257),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: TextButton(
                    onPressed: _confirmLogout,
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final String currentAvatar;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    required this.currentAvatar,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _avatarPath = widget.currentAvatar;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarPath = image.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('full_name', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('phone', _phoneController.text);
    if (_avatarPath != null) {
      await prefs.setString('avatar_path', _avatarPath!);
    }

    Navigator.pop(context, {
      'full_name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'avatar_path': _avatarPath
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios_new_rounded),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 70.h,
        backgroundColor: const Color(0xFF006257),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundImage: _avatarPath != null
                        ? FileImage(File(_avatarPath!))
                        : const AssetImage('assets/images/man.png')
                            as ImageProvider,
                  ),
                ),
              ),
              const Text('Add Photo'),
              SizedBox(height: 30.h),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 50.h,
                  width: 0.5.sw, // Using 50% of the screen width
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF006257),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        )),
                    onPressed: _saveProfile,
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
