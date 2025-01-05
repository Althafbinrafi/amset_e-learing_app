import 'dart:convert';
import 'dart:developer';
import 'package:amset/screens/PostPurchasePages/get_certified_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  ShippingAddressPageState createState() => ShippingAddressPageState();
}

class ShippingAddressPageState extends State<ShippingAddressPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  final bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _emailController = TextEditingController();
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
    _fetchShippingDetails();
  }

 Future<void> _fetchShippingDetails() async {
  if (!mounted) return;

  setState(() => _isLoading = true);

  final url = Uri.parse('https://amset-server.vercel.app/api/user/profile');
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    log('Error: Authentication token is missing.');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to continue.')),
      );
    }
    setState(() => _isLoading = false);
    return;
  }

  try {
    log('Fetching user profile...');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("Fetched user data: $data");

      if (mounted) {
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
          _emailController.text = data['email'] ?? '';
        });
      }
    } else {
      log('Server error: ${response.statusCode}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to fetch user profile. Server returned: ${response.statusCode}'),
          ),
        );
      }
    }
  } catch (e) {
    log('Error fetching user profile: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user profile: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
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
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 24.0),
                            child: Row(
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
                                const SizedBox(width: 13),
                                Text(
                                  'Shipping Address',
                                  style: GoogleFonts.dmSans(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: -1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " Name",
                            controller: _nameController,
                            isMultiline: true,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " Email",
                            controller: _emailController,
                            isMultiline: true,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " Address",
                            controller: _addressController,
                            isMultiline: true,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " Post Office",
                            controller: _postOfficeController,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " District",
                            controller: _districtController,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " Pincode",
                            controller: _pincodeController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " Whatsapp Number",
                            controller: _whatsappController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),
                          const SizedBox(height: 16),
                          _buildLabeledDetail(
                            label: " Secondary Mobile Number",
                            controller: _secondaryPhoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 122.w,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 0.5.w),
                                    color: const Color(0xFFEBF9E7),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Back',
                                        style: GoogleFonts.dmSans(
                                            fontSize: 17.sp,
                                            color: const Color.fromARGB(
                                                255, 23, 23, 23),
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 13.w,
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 122.w,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(46, 53, 58, 1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Continue',
                                        style: GoogleFonts.dmSans(
                                            fontSize: 17.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.5),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 300),
                                      () async { if (!context.mounted) return;
                                    final result = await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                const GetCertifiedPage(),
                                        transitionDuration: Duration
                                            .zero, // Transition duration
                                        reverseTransitionDuration: Duration
                                            .zero, // Reverse transition duration
                                      ),
                                    );

                                    // Handle result if needed
                                    if (result != null) {
                                      setState(() {
                                        // Update state if necessary
                                      });
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                height: MediaQuery.of(context).size.height / 1,
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
