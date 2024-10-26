import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPage createState() => _UserDetailsPage();
}

class _UserDetailsPage extends State<UserDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Editing mode flag and controllers
  bool _isEditing = false;
  final _nameController = TextEditingController(text: "Muhammed Althaf PK");
  final _userIdController = TextEditingController(text: "althumon");
  final _addressController = TextEditingController(
      text: "Panthayam Kunnath House\nPadinjarangadi PO\nKumaranellur Via");
  final _postOfficeController = TextEditingController(text: "Padinjarangadi");
  final _districtController = TextEditingController(text: "Palakkad");
  final _pincodeController = TextEditingController(text: "679552");
  final _whatsappController = TextEditingController(text: "8089891475");
  final _secondaryPhoneController = TextEditingController(text: "8089891475");

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _animationController.dispose();
    // Dispose controllers to free up resources
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  // Header with back button and "Edit Details"
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 30.0),
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
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
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
                                      color: const Color(0xFF75C044), width: 1),
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
                                )),
                              ),
                              onTap: () {
                                setState(() {
                                  if (_isEditing) {
                                    // Handle save logic here
                                    // You may add validation or API submission logic here
                                  }
                                  _isEditing = !_isEditing;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      // User Profile Picture with Name and ID
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
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/man.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      // Handle image change
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

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
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledDetail(
                        label: "Whatsapp Number",
                        controller: _whatsappController,
                      ),
                      const SizedBox(height: 16),
                      _buildLabeledDetail(
                        label: "Secondary Phone Number",
                        controller: _secondaryPhoneController,
                      ),

                      const SizedBox(height: 30),

                      // Back and Update buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Handle back button
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0x1A75C044),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 8),
                                child: Text('Back',
                                    style: GoogleFonts.dmSans(
                                        color: Colors.black,
                                        fontSize: 19,
                                        letterSpacing: -0.3)),
                              ),
                            ),
                            const SizedBox(width: 13),
                            ElevatedButton(
                              onPressed: () {
                                if (_isEditing) {
                                  // Save changes logic here
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 8),
                                child: Text(
                                  _isEditing ? 'Save' : 'Update',
                                  style: GoogleFonts.dmSans(
                                      color: Colors.white,
                                      fontSize: 19,
                                      letterSpacing: -0.3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for displaying or editing details with labels
  Widget _buildLabeledDetail({
    required String label,
    required TextEditingController controller,
    bool isMultiline = false,
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
                  maxLines: isMultiline ? null : 1,
                  decoration: InputDecoration(
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
                        color:
                            _isEditing ? Colors.green : Colors.grey.shade300),
                  ),
                  child: Text(
                    controller.text,
                    style: GoogleFonts.dmSans(
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                    maxLines: isMultiline ? null : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ],
      ),
    );
  }
}
