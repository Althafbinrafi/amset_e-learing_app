import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityPolicy extends StatelessWidget {
  const SecurityPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Security Policy', // The centered title
          style: TextStyle(
            fontSize: 23.sp, // Font size for the title
            fontWeight: FontWeight.normal, // Slightly bold
            letterSpacing: -0.5, // Adjust letter spacing
            color: Colors.black, // Title color
          ),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
              'assets/images/back_btn.svg', // Path to your SVG file
              width: 25,
              height: 25,
            ),
          ),
        ),
        leadingWidth: 55.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Security Policy for AMSET App",
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Effective Date: [Insert Date]\nLast Updated: [Insert Date]",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                "At AMSET, we are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and share your information.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle("1. Information We Collect"),
              _buildBulletPoint(
                  " Personal Information: Name, email address, phone number, location (if provided)."),
              _buildBulletPoint(
                  " Usage Data: App usage patterns, device information, and log data."),
              _buildBulletPoint(
                  " Optional Information: Profile details, uploaded documents, and preferences."),
              const SizedBox(height: 16),
              _buildSectionTitle("2. How We Use Your Information"),
              _buildBulletPoint(" To provide and improve our services."),
              _buildBulletPoint(
                  " To communicate with you regarding updates, offers, or support."),
              _buildBulletPoint(
                  " To match job seekers with employers and training programs."),
              _buildBulletPoint(" For legal compliance and fraud prevention."),
              const SizedBox(height: 16),
              _buildSectionTitle("3. Sharing of Information"),
              _buildBulletPoint(
                  " Your information may be shared with employers and training providers when necessary for service delivery."),
              _buildBulletPoint(" We do not sell your data to third parties."),
              _buildBulletPoint(
                  " Information may be shared with legal authorities if required by law."),
              const SizedBox(height: 16),
              _buildSectionTitle("4. User Rights"),
              _buildBulletPoint(
                  " You can access, update, or delete your personal data anytime through the app’s settings."),
              _buildBulletPoint(
                  " You have the right to withdraw consent for data processing where applicable."),
              const SizedBox(height: 16),
              _buildSectionTitle("5. Data Retention"),
              _buildBulletPoint(
                  " We retain your information as long as necessary to fulfill our services or comply with legal obligations."),
              const SizedBox(height: 16),
              _buildSectionTitle("6. Children’s Privacy"),
              _buildBulletPoint(
                  " The app is not intended for individuals under the age of 18 without parental consent."),
              const SizedBox(height: 16),
              _buildSectionTitle("7. Cookies and Tracking"),
              _buildBulletPoint(
                  " We may use cookies to enhance the user experience. You can manage cookie preferences through your device settings."),
              const SizedBox(height: 16),
              _buildSectionTitle("8. Changes to the Policy"),
              _buildBulletPoint(
                  " Updates to this policy will be communicated through the app or email notifications."),
              const SizedBox(height: 16),
              _buildSectionTitle("9. Contact Us"),
              _buildBulletPoint(
                  " For privacy-related inquiries, contact us at [Insert Email Address] or [Insert Phone Number]."),
              const SizedBox(height: 24),
              Text(
                "Note: By using the AMSET app, you agree to this Security and Privacy Policy.",
                style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.5,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dmSans(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: GoogleFonts.dmSans(
              fontSize: 17.sp,
              fontWeight: FontWeight.normal,
              letterSpacing: -0.3,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
