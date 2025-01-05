import 'package:amset/screens/DrawerPages/Profile/user_details_page.dart';
import 'package:amset/Widgets/bio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Reg and Log/login.dart';

class ProfilePage extends StatefulWidget {
  final Function(String)? onNameChanged;
  final String mobile;
  final String username;
  final String fullName;
  final String? userId;
  final String? avatar;

  const ProfilePage({
    super.key,
    this.onNameChanged,
    required this.mobile,
    required this.fullName,
    required this.username,
    this.userId,
    this.avatar,
  });

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late String fullName;
  late String username;
  late String mobile;
  String _email = 'example@gmail.com';
  String _avatarPath = 'assets/images/man.png';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _userBio = 'Add your bio here...';

  @override
  void initState() {
    super.initState();
    username = widget.username;
    fullName = widget.fullName;
    mobile = widget.mobile;
    _loadProfile();
    _setupAnimations();
    _loadBio();
  }

  Future<void> _loadBio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userBio = prefs.getString('userBio') ?? _userBio;
    });
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? username;
      fullName = prefs.getString('fullName') ?? fullName;
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

  Future<void> _logout() async {
    final navigator = Navigator.of(context);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    await prefs.remove('fullName');
    await prefs.remove('email');
    await prefs.remove('mobileNumber');
    await prefs.remove('avatar_path');

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(fullName: ''),
      ),
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
                letterSpacing: -0.3,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.dmSans(
              fontSize: 14.sp,
              letterSpacing: -0.3,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  letterSpacing: -0.3,
                  color: const Color(0xFF006257),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Logout',
                style: GoogleFonts.dmSans(
                  letterSpacing: -0.3,
                  fontSize: 14.sp,
                  color: const Color.fromARGB(255, 231, 15, 15),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 25.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: SvgPicture.asset(
                                  'assets/images/back_btn.svg',
                                  height: 35.h,
                                  width: 35.w,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 13.w,
                              ),
                              Text(
                                'My Profile',
                                style: GoogleFonts.dmSans(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: -1),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: SvgPicture.asset(
                              'assets/images/settings_profile.svg',
                              height: 20.h,
                              width: 20.w,
                            ),
                            onTap: () {
                              // Add settings functionality
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      //width: 300.w,
                      //height: 423.h,
                      padding: EdgeInsets.only(
                          right: 23.w, top: 20.h, left: 23.w, bottom: 19.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32.r),
                        border: Border.all(
                          color: const Color(0x212E353A),
                          width: 1,
                        ),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x1A75C044),
                            Color(0x1AFFFFFF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment(
                              0.0, 0.5), // End the gradient at the center
                        ),
                      ),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                //margin: const EdgeInsets.only(right: 23),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(213, 215, 216, 1),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(21),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(),
                                    SvgPicture.asset(
                                      'assets/images/amset_coin.svg',
                                      height: 22.h,
                                      width: 22.w,
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      '126',
                                      style: GoogleFonts.dmSans(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        letterSpacing: -0.5.w,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            maxRadius: 60.r,
                            backgroundColor: Colors.transparent,
                            child: SizedBox(
                              height: 75.h,
                              width: 75.w,
                              child: ClipOval(
                                child: widget.avatar != null &&
                                        widget.avatar!.isNotEmpty
                                    ? Image.network(
                                        widget.avatar!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/man.png',
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : _avatarPath.isNotEmpty &&
                                            _avatarPath !=
                                                'assets/images/man.png'
                                        ? Image.file(
                                            File(_avatarPath),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/man.png',
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),

                          //    const SizedBox(height: ),
                          Text(
                            fullName,
                            style: GoogleFonts.dmSans(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.normal,
                                letterSpacing: -0.3),
                          ),
                          //const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '@',
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  letterSpacing: -0.3,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                username,
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  letterSpacing: -0.3,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            _email,
                            style: GoogleFonts.dmSans(
                              fontSize: 16.sp,
                              letterSpacing: -0.3,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 11),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.29.w, vertical: 3.29.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(26, 192, 68, 68),
                                ),
                                child: Text(
                                  'Cashier',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 14.sp,
                                      letterSpacing: -0.3,
                                      color: const Color.fromARGB(
                                          255, 192, 68, 68)),
                                ),
                              ),
                              SizedBox(
                                width: 7.w,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.29.w, vertical: 3.29.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0x1AFFCC00),
                                ),
                                child: Text(
                                  'Accountant',
                                  style: GoogleFonts.dmSans(
                                      fontSize: 14.sp,
                                      letterSpacing: -0.3,
                                      color: const Color(0xFFFFCC00)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Text(
                                  maxLines: 5,
                                  _userBio,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14.sp,
                                    letterSpacing: -0.3,
                                    color: const Color(0xCC2E353A),
                                  ),
                                ),
                              ),
                              SizedBox(height: 9.h),
                              GestureDetector(
                                onTap: () async {
                                  await Future.delayed(
                                      const Duration(milliseconds: 300));
                                  if (!context.mounted) return;

                                  final result = await Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              EditBioPage(
                                        currentBio: _userBio,
                                      ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _userBio = result;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 11.29.w, vertical: 3.29.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0x1A75C044),
                                  ),
                                  child: Text(
                                    'edit bio',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      letterSpacing: -0.3,
                                      color: const Color(0xFF75C044),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GridView.count(
                      shrinkWrap:
                          true, // Important to prevent infinite height error
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable grid scrolling
                      crossAxisCount: 3, // Display 3 items per row
                      mainAxisSpacing: 14.h, // Vertical spacing
                      crossAxisSpacing: 12.w, // Horizontal spacing
                      padding: EdgeInsets.symmetric(
                          horizontal: 19.w), // Add padding if needed
                      children: [
                        // User Details
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0x212E353A), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/images/avatar_profile.svg'),
                                SizedBox(height: 8.h),
                                Text(
                                  'User\nDetails',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xFF006257),
                                    fontSize: 14.sp,
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 300));
                            if (!context.mounted) return;

                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        UserDetailsPage(
                                  userId: widget.userId,
                                  fullName: fullName,
                                  userName: username,
                                  mobile: mobile,
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                        ),

                        // Edit Profile
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0x212E353A), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/images/edit_profile.svg'),
                                SizedBox(height: 8.h),
                                Text(
                                  '  Share\n  Profile',
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xFF006257),
                                    fontSize: 14.sp,
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Logout
                        GestureDetector(
                          onTap: _confirmLogout,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0x212E353A), width: 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                    'assets/images/logout_profile.svg'),
                                SizedBox(height: 8.h),
                                Text(
                                  '   User\nSign Out',
                                  style: GoogleFonts.dmSans(
                                    color: const Color(0xFF006257),
                                    fontSize: 14.sp,
                                    letterSpacing: -0.3,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
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

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentfullName;
  final String currentEmail;
  final String currentPhone;
  final String currentAvatar;

  const EditProfilePage({
    super.key,
    required this.currentName,
    required this.currentfullName,
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
  late TextEditingController _fullnameContorller;
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
    _fullnameContorller = TextEditingController(text: widget.currentfullName);
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
    await prefs.setString('fullName', _fullnameContorller.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('mobileNumber', _phoneController.text);
    if (_avatarPath != null) {
      await prefs.setString('avatar_path', _avatarPath!);
    }

    // Use the captured navigator instead of BuildContext
    navigator.pop({
      'username': _nameController.text,
      'fullName': _fullnameContorller.text,
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
                      controller: _fullnameContorller,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.r)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'User ID',
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
