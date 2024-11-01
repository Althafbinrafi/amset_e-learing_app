import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserDetailsPage extends StatefulWidget {
  final String? userId;
  final String userName;
  final String fullName;
  final String mobile;

  const UserDetailsPage({
    super.key,
    this.userId,
    required this.userName,
    required this.fullName,
    required this.mobile,
  });

  @override
  _UserDetailsPage createState() => _UserDetailsPage();
}

class _UserDetailsPage extends State<UserDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  bool _isEditing = false;
  String? _avatarUrl;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _postOfficeController = TextEditingController();
  final _districtController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _secondaryPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _fetchUserDetails();
    _initializeFields();
    log("User ID: ${widget.userId}");
  }

  void _initializeFields() {
    _userIdController.text = widget.userName;
    _nameController.text = widget.fullName;
    _whatsappController.text = widget.mobile;
  }

  Future<void> _fetchUserDetails() async {
    setState(() => _isLoading = true);
    final url = Uri.parse('https://amset-server.vercel.app/api/user/profile');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log("Fetched user data: $data");

        setState(() {
          _addressController.text = data['address'] ?? '';
          _postOfficeController.text = data['postOffice'] ?? '';
          _districtController.text = data['district'] ?? '';
          _pincodeController.text = data['pinCode']?.toString() ?? '';
          _whatsappController.text = data['mobileNumber']?.toString() ?? '';
          _secondaryPhoneController.text =
              data['secondaryMobileNumber']?.toString() ?? '';
          _nameController.text = data['fullName'] ?? '';
          _userIdController.text = data['username'] ?? '';
          _avatarUrl = data['avatarUrl'];
        });
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      log('Error fetching data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user details: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _uploadImage();
      }
    } catch (e) {
      log('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() => _isLoading = true);
    final url =
        Uri.parse('https://amset-server.vercel.app/api/user/profile/avatar');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
        })
        ..files.add(await http.MultipartFile.fromPath(
          'avatar',
          _imageFile!.path,
          contentType:
              MediaType('image', path.extension(_imageFile!.path).substring(1)),
        ));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseData);
        setState(() {
          _avatarUrl = data['avatarUrl'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      log('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserDetails() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final url = Uri.parse(
        'https://amset-server.vercel.app/api/user/profile/${widget.userId}');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    try {
      Map<String, dynamic> updateData = {
        'fullName': _nameController.text.trim(),
        'username': _userIdController.text.trim(),
        'address': _addressController.text.trim(),
        'postOffice': _postOfficeController.text.trim(),
        'district': _districtController.text.trim(),
        'pinCode': _pincodeController.text.trim(),
        'mobileNumber': _whatsappController.text.trim(),
        'secondaryMobileNumber': _secondaryPhoneController.text.trim(),
      };

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isEditing = false;
        });
        await _fetchUserDetails();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      log('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _userIdController.dispose();
    _addressController.dispose();
    _postOfficeController.dispose();
    _districtController.dispose();
    _pincodeController.dispose();
    _whatsappController.dispose();
    _secondaryPhoneController.dispose();
    super.dispose();
  }

  Widget _buildLabeledDetail({
    required String label,
    required TextEditingController controller,
    bool isMultiline = false,
    bool enabled = true,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          _isEditing
              ? TextFormField(
                  controller: controller,
                  enabled: enabled && _isEditing,
                  maxLines: isMultiline ? null : 1,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    counterText: "",
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: _isEditing ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    controller.text.isEmpty ? 'Not specified' : controller.text,
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                    maxLines: isMultiline ? null : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ],
      ),
    );
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
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Header section with back button and edit/save button
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 30.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: const Color(0xFF75C044),
                                          width: 2,
                                        ),
                                        color: const Color(0x1A75C044),
                                      ),
                                      child: GestureDetector(
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.arrow_back_ios_new_rounded,
                                            color: Color(0xFF75C044),
                                            size: 20,
                                          ),
                                        ),
                                        onTap: () => Navigator.pop(context),
                                      ),
                                    ),
                                    const SizedBox(width: 13),
                                    Text(
                                      'User Details',
                                      style: GoogleFonts.dmSans(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0x1A75C044),
                                      borderRadius: BorderRadius.circular(17),
                                      border: Border.all(
                                          color: const Color(0xFF75C044),
                                          width: 1),
                                    ),
                                    child: Center(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.save,
                                            color: Color(0xFF75C044),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _isEditing
                                                ? 'Save Details'
                                                : 'Edit Details',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (_isEditing) {
                                        _updateUserDetails();
                                      } else {
                                        _isEditing = true;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          // User info section with avatar
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabeledDetail(
                                      label: "Name",
                                      controller: _nameController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildLabeledDetail(
                                      label: "User ID",
                                      controller: _userIdController,
                                      enabled: false,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: _imageFile != null
                                            ? Image.file(
                                                _imageFile!,
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              )
                                            : _avatarUrl != null
                                                ? Image.network(
                                                    _avatarUrl!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                        'assets/images/man.png',
                                                        width: 100,
                                                        height: 100,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  )
                                                : Image.asset(
                                                    'assets/images/man.png',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                    ),
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border:
                                                Border.all(color: Colors.green),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            onPressed: _pickImage,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // User details form
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: "Address",
                            controller: _addressController,
                            isMultiline: true,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: "Post Office",
                            controller: _postOfficeController,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: "District",
                            controller: _districtController,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: "Pincode",
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: "Whatsapp Number",
                            controller: _whatsappController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: "Secondary Mobile Number",
                            controller: _secondaryPhoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),

                          // Action buttons
                          const SizedBox(height: 30),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0x1A75C044),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      'Back',
                                      style: GoogleFonts.dmSans(
                                        color: Colors.black,
                                        fontSize: 19,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 13),
                                ElevatedButton(
                                  onPressed:
                                      _isEditing ? _updateUserDetails : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      _isEditing ? 'Save' : 'Update',
                                      style: GoogleFonts.dmSans(
                                        color: Colors.white,
                                        fontSize: 19,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Loading overlay
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Lottie.asset(
                    'assets/images/loading.json',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
