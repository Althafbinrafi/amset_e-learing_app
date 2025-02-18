import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditBioPage extends StatefulWidget {
  final String currentBio;
  final String userId; // Add userId to identify the user

  const EditBioPage(
      {super.key, required this.currentBio, required this.userId});

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _bioController;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.currentBio);

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _bioController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _updateBio() async {
    if (_bioController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bio cannot be empty')),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://amset-server.vercel.app/api/user/profile/${widget.userId}');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authorization token is missing')),
        );
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'bioDescription': _bioController.text.trim()}),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bio updated successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back with the updated bio
          Navigator.pop(context, _bioController.text.trim());
        }
      } else {
        throw Exception(
            'Failed to update bio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update bio: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Header section
                    Padding(
                      padding:
                          EdgeInsets.only(top: 50.h, right: 28.w, left: 25.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                              SizedBox(width: 13.w),
                              Text(
                                'Edit Bio',
                                style: GoogleFonts.dmSans(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Bio editing section
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '    My Bio',
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.dmSans(
                                      color: const Color.fromARGB(134, 0, 0, 0),
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: const Color(0x212E353A),
                                  ),
                                  color: Colors.white,
                                ),
                                child: TextField(
                                  controller: _bioController,
                                  maxLength: 300,
                                  maxLines: 15,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Write something about yourself...',
                                    hintStyle: GoogleFonts.dmSans(
                                      color: Colors.grey,
                                      fontSize: 16.sp,
                                    ),
                                    contentPadding: EdgeInsets.all(16.w),
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.dmSans(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF2E353A),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 28.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 35.w,
                                        vertical: 7.h,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: const Color.fromARGB(
                                            48, 118, 192, 68),
                                      ),
                                      child: Text(
                                        'Back',
                                        style: GoogleFonts.dmSans(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13.w,
                                  ),
                                  GestureDetector(
                                    onTap: _isLoading ? null : _updateBio,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 35,
                                        vertical: 7,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : Text(
                                              'Save',
                                              style: GoogleFonts.dmSans(
                                                color: Colors.white,
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
