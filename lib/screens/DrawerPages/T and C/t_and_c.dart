import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Terms and Conditions', // The centered title
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
                "Terms and Conditions for AMSET App Users",
                style: GoogleFonts.dmSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Before using the AMSET app, please read and understand these terms and conditions. By using the app, you agree to comply with these terms. If you do not agree, kindly refrain from using the app.",
                style: GoogleFonts.dmSans(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.normal,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle("1. Purpose and Scope"),
              _buildBulletPoint(
                  "1.1. The AMSET app is operated and managed by AMSET Academy."),
              _buildBulletPoint(
                  "1.2. The AMSET app is not a recruitment company or agency."),
              _buildBulletPoint(
                  "1.3. The app is designed to provide training and guidance to enhance users’ employability skills."),
              const SizedBox(height: 16),
              _buildSectionTitle("2. Services Provided"),
              _buildBulletPoint(
                  "2.1. AMSET Academy offers specialized training programs to help users improve their job qualifications."),
              _buildBulletPoint(
                  "2.2. The app may provide information on job opportunities and company details; however, the final decision on employment lies solely with the companies or recruitment agencies."),
              _buildBulletPoint("2.3. AMSET does not guarantee job placement."),
              const SizedBox(height: 16),
              _buildSectionTitle("3. Usage Guidelines"),
              _buildBulletPoint(
                  "3.1. Users must use the app for lawful purposes and in accordance with AMSET’s policies."),
              _buildBulletPoint(
                  "3.2. All content within the app, including videos, course materials, and certification modules, is the exclusive property of AMSET Academy."),
              _buildBulletPoint(
                  "3.3. Unauthorized copying, sharing, or misuse of AMSET training materials is strictly prohibited and subject to legal action."),
              _buildBulletPoint(
                  "3.4. Attempts to hack, manipulate, or misuse the app will result in immediate termination of access and legal consequences."),
              const SizedBox(height: 16),
              _buildSectionTitle("4. Payment and Refund Policy"),
              _buildBulletPoint(
                  "4.1. The services provided by the AMSET app are not free."),
              _buildBulletPoint(
                  "4.2. Payments are mandatory for training, certification courses, and access to digital content."),
              _buildBulletPoint(
                  "4.3. Payments made for services are non-refundable under any circumstances."),
              _buildBulletPoint(
                  "4.4. Users are responsible for all costs associated with certifications provided by AMSET."),
              const SizedBox(height: 16),
              _buildSectionTitle("5. Disclaimer of Liability"),
              _buildBulletPoint(
                  "5.1. AMSET is not responsible for any losses incurred by users or third parties through the use of the app."),
              _buildBulletPoint(
                  "5.2. AMSET is not liable for the authenticity of job opportunities or company details provided in the app. Users are encouraged to verify these independently."),
              _buildBulletPoint(
                  "5.3. AMSET is not responsible for payments demanded by agents or external parties claiming affiliation with the app."),
              const SizedBox(height: 16),
              _buildSectionTitle("6. Legal Actions"),
              _buildBulletPoint(
                  "6.1. Sharing or distributing AMSET’s proprietary content without authorization is a violation of copyright laws and may lead to legal action."),
              _buildBulletPoint(
                  "6.2. Spreading false information or damaging AMSET’s reputation through social media or other channels will result in legal proceedings."),
              const SizedBox(height: 16),
              _buildSectionTitle("7. Privacy and Data Protection"),
              _buildBulletPoint(
                  "7.1. Users’ personal information will be protected in accordance with AMSET’s privacy policy."),
              _buildBulletPoint(
                  "7.2. AMSET will not share users’ data with third parties for unauthorized commercial purposes."),
              _buildBulletPoint(
                  "7.3. Any misuse of users’ data will result in strict legal measures."),
              const SizedBox(height: 16),
              _buildSectionTitle("8. Scope of AMSET’s Responsibility"),
              _buildBulletPoint(
                  "8.1. AMSET is a training provider and not a recruitment agency."),
              _buildBulletPoint(
                  "8.2. Employment decisions, including selection and hiring, are solely at the discretion of companies or recruitment agencies."),
              _buildBulletPoint(
                  "8.3. AMSET assists users in preparing for interviews and job opportunities but does not guarantee employment."),
              const SizedBox(height: 16),
              _buildSectionTitle("9. Ownership and Rights"),
              _buildBulletPoint(
                  "9.1. The full responsibility for the app, its content, and functionality lies with AMSET Academy."),
              _buildBulletPoint(
                  "9.2. AMSET reserves the right to modify or update app features, services, and policies at any time without prior notice."),
              const SizedBox(height: 16),
              _buildSectionTitle("10. Governing Law and Dispute Resolution"),
              _buildBulletPoint(
                  "10.1. These terms and conditions are governed by the laws of the jurisdiction where AMSET Academy is registered."),
              _buildBulletPoint(
                  "10.2. Any disputes arising from the use of the app will be resolved under the legal framework applicable to AMSET Academy’s jurisdiction."),
              const SizedBox(height: 16),
              const Text(
                "By using the AMSET app, you acknowledge and accept these terms and conditions.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
              Text(
                "Contact Us:",
                style: GoogleFonts.dmSans(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "For inquiries or further information, please reach out to AMSET Academy via [contact details].",
                style: TextStyle(fontSize: 16, height: 1.5),
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
