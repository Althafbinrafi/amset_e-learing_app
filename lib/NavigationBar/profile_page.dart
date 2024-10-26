// import 'package:amset/screens/skip.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class ProfilePage extends StatefulWidget {
//   final Function(String)? onNameChanged;

//   const ProfilePage({super.key, this.onNameChanged});

//   @override
//   ProfilePageState createState() => ProfilePageState();
// }

// class ProfilePageState extends State<ProfilePage> {
//   String _fullName = 'Your Name';
//   String _email = 'example@gmail.com';
//   String _phone = '';
//   String _avatarPath = 'assets/images/man.png';

//   @override
//   void initState() {
//     super.initState();
//     _loadProfile();
//   }

//   Future<void> _loadProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _fullName = prefs.getString('full_name') ?? _fullName;
//       _email = prefs.getString('email') ?? _email;
//       _phone = prefs.getString('phone') ?? _phone;
//       _avatarPath = prefs.getString('avatar_path') ?? _avatarPath;
//     });
//   }

//   Future<void> _editProfile() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditProfilePage(
//           currentName: _fullName,
//           currentEmail: _email,
//           currentPhone: _phone,
//           currentAvatar: _avatarPath,
//         ),
//       ),
//     );

//     if (result != null) {
//       setState(() {
//         _fullName = result['full_name'];
//         _email = result['email'];
//         _phone = result['phone'];
//         _avatarPath = result['avatar_path'];
//       });
//       _saveProfile();

//       // Return the updated data to the Dashboard
//       Navigator.pop(context, {
//         'full_name': _fullName,
//         'avatar_path': _avatarPath,
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('full_name', _fullName);
//     await prefs.setString('email', _email);
//     await prefs.setString('phone', _phone);
//     await prefs.setString('avatar_path', _avatarPath);
//   }

//   Future<void> _logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('full_name');
//     await prefs.remove('email');
//     await prefs.remove('phone');
//     await prefs.remove('avatar_path');

//     Navigator.pushAndRemoveUntil(
//       // ignore: use_build_context_synchronously
//       context,
//       MaterialPageRoute(builder: (context) => const SkipPage()),
//       (Route<dynamic> route) => false,
//     );
//   }

//   void _confirmLogout() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Logout'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Logout'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _logout();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 30.w),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     child: const Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       size: 25,
//                     ),
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                   Text(
//                     'User Profile',
//                     style: GoogleFonts.dmSans(
//                         color: Colors.black,
//                         fontSize: 27.sp,
//                         fontWeight: FontWeight.normal,
//                         letterSpacing: -1),
//                   ),
//                   const SizedBox(
//                     width: 1,
//                   ),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   maxRadius: 90.r,
//                   backgroundColor: Colors.transparent,
//                   child: SizedBox(
//                     height: 170.h,
//                     width: 170.w,
//                     child: ClipOval(
//                       child: _avatarPath.isNotEmpty &&
//                               _avatarPath != 'assets/images/man.png'
//                           ? Image.file(
//                               File(_avatarPath),
//                               fit: BoxFit.cover,
//                             )
//                           : Image.asset('assets/images/man.png'),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Text(
//                   _fullName,
//                   style: TextStyle(fontSize: 22.sp),
//                 ),
//                 SizedBox(height: 20.h),
//                 Text(
//                   _email,
//                   style: TextStyle(fontSize: 20.sp, color: Colors.grey),
//                 ),
//                 SizedBox(height: 10.h),
//                 Text(
//                   _phone,
//                   style: TextStyle(fontSize: 20.sp, color: Colors.grey),
//                 ),
//                 SizedBox(height: 50.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 150.w,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF006257),
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             bottomLeft: Radius.circular(20)),
//                       ),
//                       child: TextButton(
//                         onPressed: _confirmLogout,
//                         child: Center(
//                           child: Text(
//                             'Log Out',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18.sp,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 7,
//                     ),
//                     GestureDetector(
//                       onTap: _editProfile,
//                       child: Container(
//                         padding: EdgeInsets.all(5.w),
//                         height: 41.h,
//                         width: 50.w,
//                         decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.only(
//                               topRight: Radius.circular(20),
//                               bottomRight: Radius.circular(20)),
//                           color: Color(0xFF006257),
//                         ),
//                         child: const Icon(
//                           Icons.edit,
//                           size: 30,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     Navigator.pop(context);
//       //   },
//       //   child: Icon(
//       //     Icons.arrow_back_ios_new_rounded,
//       //     color: const Color.fromARGB(255, 0, 0, 0),
//       //   ),
//       //   backgroundColor: Colors.transparent,
//       //   elevation: 0,
//       //   focusElevation: 0,
//       //   hoverColor: Colors.transparent,
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
//     );
//   }
// }

// class EditProfilePage extends StatefulWidget {
//   final String currentName;
//   final String currentEmail;
//   final String currentPhone;
//   final String currentAvatar;

//   const EditProfilePage({
//     super.key,
//     required this.currentName,
//     required this.currentEmail,
//     required this.currentPhone,
//     required this.currentAvatar,
//   });

//   @override
//   EditProfilePageState createState() => EditProfilePageState();
// }

// class EditProfilePageState extends State<EditProfilePage> {
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneController;
//   String? _avatarPath;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.currentName);
//     _emailController = TextEditingController(text: widget.currentEmail);
//     _phoneController = TextEditingController(text: widget.currentPhone);
//     _avatarPath = widget.currentAvatar;
//   }

//   Future<void> _pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//     if (image != null) {
//       setState(() {
//         _avatarPath = image.path;
//       });
//     }
//   }

//   Future<void> _saveProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('full_name', _nameController.text);
//     await prefs.setString('email', _emailController.text);
//     await prefs.setString('phone', _phoneController.text);
//     if (_avatarPath != null) {
//       await prefs.setString('avatar_path', _avatarPath!);
//     }

//     // ignore: use_build_context_synchronously
//     Navigator.pop(context, {
//       'full_name': _nameController.text,
//       'email': _emailController.text,
//       'phone': _phoneController.text,
//       'avatar_path': _avatarPath
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 35.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                       child: const Icon(
//                         Icons.arrow_back_ios_new_rounded,
//                         size: 25,
//                       ),
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     Text(
//                       'Edit Profile',
//                       style: GoogleFonts.dmSans(
//                           color: Colors.black,
//                           fontSize: 27.sp,
//                           fontWeight: FontWeight.normal,
//                           letterSpacing: -1),
//                     ),
//                     const SizedBox(
//                       width: 1,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30.h),
//                 Center(
//                   child: GestureDetector(
//                     onTap: _pickImage,
//                     child: CircleAvatar(
//                       radius: 60.r,
//                       backgroundImage: _avatarPath != null
//                           ? FileImage(File(_avatarPath!))
//                           : const AssetImage('assets/images/man.png')
//                               as ImageProvider,
//                     ),
//                   ),
//                 ),
//                 const Text('Add Photo'),
//                 SizedBox(height: 30.h),
//                 TextField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Full Name',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10.r)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10.r)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 TextField(
//                   controller: _phoneController,
//                   decoration: InputDecoration(
//                     labelText: 'Phone Number',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(10.r)),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 30.h),
//                 Center(
//                   child: SizedBox(
//                     height: 50.h,
//                     width: 0.5.sw,
//                     child: ElevatedButton(
//                       style: TextButton.styleFrom(
//                         backgroundColor: const Color(0xFF006257),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30.r),
//                         ),
//                       ),
//                       onPressed: _saveProfile,
//                       child: Text(
//                         'Save',
//                         style: TextStyle(color: Colors.white, fontSize: 20.sp),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
