import 'package:amset/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatefulWidget {
  final Function(String)? onNameChanged;
  //final String fullName;
  final String mobile;
  final String username;

  const ProfilePage(
      {super.key,
      this.onNameChanged,
      //required this.fullName,
      required this.mobile,
      required this.username});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late String fullName;
  late String username;
  late String mobile;
  String _email = 'example@gmail.com';
  //String mobileNumber = '';
  String _avatarPath = 'assets/images/man.png';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    //fullName = widget.fullName;
    username = widget.username;
    mobile = widget.mobile;
    _loadProfile();
    _setupAnimations();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? username;
      _email = prefs.getString('email') ?? _email;
      mobile = prefs.getString('mobileNumber') ?? mobile;
      _avatarPath = prefs.getString('avatar_path') ?? _avatarPath;
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  Future<void> _editProfile() async {
    // Capture the necessary context information before the async gap
    final navigator = Navigator.of(context);

    final result = await navigator.push(
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentName: username,
          currentEmail: _email,
          currentPhone: mobile,
          currentAvatar: _avatarPath,
        ),
      ),
    );

    // No need for mounted check here as we're not using BuildContext anymore

    if (result != null) {
      setState(() {
        fullName = result['username'];
        _email = result['email'];
        mobile = result['mobileNumber'];
        _avatarPath = result['avatar_path'];
      });
      await _saveProfile();

      if (widget.onNameChanged != null) {
        widget.onNameChanged!(username);
      }

      // Use the captured navigator instead of BuildContext
      navigator.pop({
        'username': username,
        'avatar_path': _avatarPath,
      });
    }
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('email', _email);
    await prefs.setString('mobileNumber', mobile);
    await prefs.setString('avatar_path', _avatarPath);
  }

  Future<void> _logout() async {
    // Capture the navigator before the async operations
    final navigator = Navigator.of(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('mobileNumber');
    await prefs.remove('avatar_path');

    // Use the captured navigator instead of BuildContext
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) => const LoginPage(
                fullName: '',
              )),
      (Route<dynamic> route) => false,
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: GoogleFonts.dmSans(
                fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.dmSans(
              fontSize: 14.sp,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: const Color(0xFF006257),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Logout',
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: const Color(0xFF006257),
                ),
              ),
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 35.h, horizontal: 30.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 25,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'User Profile',
                        style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 27.sp,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -1),
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      username,
                      style: TextStyle(fontSize: 22.sp),
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      _email,
                      style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      mobile,
                      style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 50.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFF006257),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                          ),
                          child: TextButton(
                            onPressed: _confirmLogout,
                            child: Center(
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        GestureDetector(
                          onTap: _editProfile,
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            height: 41.h,
                            width: 50.w,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              color: Color(0xFF006257),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _avatarPath;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _avatarPath = widget.currentAvatar;

    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
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
    // Capture the navigator before the async operations
    final navigator = Navigator.of(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _nameController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('mobileNumber', _phoneController.text);
    if (_avatarPath != null) {
      await prefs.setString('avatar_path', _avatarPath!);
    }

    // Use the captured navigator instead of BuildContext
    navigator.pop({
      'username': _nameController.text,
      'email': _emailController.text,
      'mobileNumber': _phoneController.text,
      'avatar_path': _avatarPath
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 35.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 25,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Edit Profile',
                          style: GoogleFonts.dmSans(
                              color: Colors.black,
                              fontSize: 27.sp,
                              fontWeight: FontWeight.normal,
                              letterSpacing: -1),
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
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
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: SizedBox(
                        height: 50.h,
                        width: 0.5.sw,
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF006257),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                          ),
                          onPressed: _saveProfile,
                          child: Text(
                            'Save',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
