// import 'package:amset/DrawerPages/Course/all_lessons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:amset/Models/allCoursesModel.dart';

// class CourseDetailPageHome extends StatelessWidget {
//   final Course course;

//   const CourseDetailPageHome({Key? key, required this.course})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         toolbarHeight: 60,
//         leading: GestureDetector(
//           child: Icon(Icons.arrow_back_ios_new_rounded),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//         surfaceTintColor: Colors.transparent,
//         centerTitle: true,
//         title: Text('Course Details'),
//         backgroundColor: Color.fromRGBO(255, 255, 255, 1),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             // Course Image
//             Center(
//               child: Container(
//                 height: 200.h,
//                 width: MediaQuery.of(context).size.width / 1.1,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image: NetworkImage(
//                         course.imageUrl ?? 'https://placeholder.com/344x201'),
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(26.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Course Title
//                   Text(
//                     course.title,
//                     style: GoogleFonts.dmSans(
//                       fontSize: 24.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(8),
//                     // decoration: BoxDecoration(
//                     //     border: Border.all(color: Colors.amber, width: 1),
//                     //     borderRadius: BorderRadius.circular(30)),
//                     child: SvgPicture.asset(
//                       'assets/images/premium_label.svg',
//                       width: 20.w,
//                       height: 20.h,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   // Course Description
//                   Text(
//                     course.description.toString(),
//                     style: GoogleFonts.dmSans(fontSize: 16.sp),
//                   ),
//                   SizedBox(height: 16.h),
//                   // Price
//                   Text(
//                     'Price: \$${course.price}',
//                     style: GoogleFonts.dmSans(
//                       color: const Color.fromARGB(255, 232, 76, 65),
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   // Chapters
//                   Text(
//                     'Chapters:',
//                     style: GoogleFonts.dmSans(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: course.chapters.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(
//                           course.chapters[index].title,
//                           style: GoogleFonts.dmSans(fontSize: 16.sp),
//                         ),
//                         leading: CircleAvatar(
//                           backgroundColor: Color.fromRGBO(117, 192, 68, 1),
//                           child: Text('${index + 1}'),
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 40.h),
//                   // You can add more fields here if they are available in your Course model
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Container(
//         width: MediaQuery.of(context).size.width / 1.1,
//         child: FloatingActionButton(
//           backgroundColor: Color.fromRGBO(255, 204, 0, 1),
//           // splashColor: Colors.amber,
//           onPressed: () {
//             // Navigator.push(context, MaterialPageRoute(builder: (context){
//             //   return AllLessonsPage(courseId: ,)
//             // }));
//           },
//           elevation: 0,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Puchase Premium',
//                 style: GoogleFonts.dmSans(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Container(
//                 padding: EdgeInsets.all(8),
//                 // decoration: BoxDecoration(
//                 //     border: Border.all(
//                 //         color: const Color.fromARGB(255, 255, 255, 255),
//                 //         width: 1),
//                 //     borderRadius: BorderRadius.circular(30)),
//                 child: SvgPicture.asset(
//                   'assets/images/premium.svg',
//                   width: 20.w,
//                   height: 20.h,
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amset/Models/allCoursesModel.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CourseDetailPageHome extends StatefulWidget {
  final Course course;

  const CourseDetailPageHome({Key? key, required this.course})
      : super(key: key);

  @override
  _CourseDetailPageHomeState createState() => _CourseDetailPageHomeState();
}

class _CourseDetailPageHomeState extends State<CourseDetailPageHome> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print("Payment Successful");
    // You can add your logic here, such as updating the user's subscription status
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print("Payment Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print("External Wallet");
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_KBl96fHCU3zqGI',
      'amount': widget.course.price * 100, // Amount in paise
      'name': 'Amset Course Purchase',
      'description': widget.course.title,
      'prefill': {'contact': '', 'email': ''},
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _showConfirmationDrawer() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width / 1,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm Purchase',
                style: GoogleFonts.dmSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Are you sure you want to purchase \n ${widget.course.title} for \$${widget.course.price}?',
                style: GoogleFonts.dmSans(fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical:
                          10.h), // Optional: Add padding for better button size
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        20.r), // Optional: Add rounded corners
                  ),
                ),
                child: Text(
                  'Continue to Payment',
                  style: GoogleFonts.dmSans(
                      fontSize: 18.sp, color: Colors.white), // Set text color
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the drawer
                  openCheckout(); // Open RazorPay
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        leading: Padding(
          padding:
              const EdgeInsets.only(left: 30), // Adjust the padding as needed
          child: GestureDetector(
            behavior:
                HitTestBehavior.translucent, // Ensures taps are registered
            child: const Icon(Icons.arrow_back_ios_new_rounded),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Course Details'),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Course Image
            Center(
              child: Container(
                height: 200.h,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.course.imageUrl ??
                        'https://placeholder.com/344x201'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(26.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    widget.course.title,
                    style: GoogleFonts.dmSans(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/images/premium_label.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Course Description
                  Text(
                    widget.course.description.toString(),
                    style: GoogleFonts.dmSans(fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  // Price
                  Text(
                    'Price: \$${widget.course.price}',
                    style: GoogleFonts.dmSans(
                      color: const Color.fromARGB(255, 232, 76, 65),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Chapters
                  Text(
                    'Chapters:',
                    style: GoogleFonts.dmSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.course.chapters.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          widget.course.chapters[index].title,
                          style: GoogleFonts.dmSans(fontSize: 16.sp),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: const Color.fromRGBO(117, 192, 68, 1),
                          child: Text('${index + 1}'),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
          onPressed: _showConfirmationDrawer,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Purchase Premium',
                style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/images/premium.svg',
                  width: 20.w,
                  height: 20.h,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
