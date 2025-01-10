import 'package:amset/screens/DrawerPages/More/more_ctgrs/amset_coins_page.dart';
import 'package:amset/screens/DrawerPages/More/more_ctgrs/amset_recommended.dart';
import 'package:amset/screens/DrawerPages/More/more_ctgrs/purchased_course_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MorePage extends StatefulWidget {
  final String userId;
  const MorePage({
    super.key,
    required this.userId,
  });

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'More Details',
          style: GoogleFonts.dmSans(
            fontSize: 24.sp,
            letterSpacing: -0.5.w,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SvgPicture.asset(
              'assets/images/back_btn.svg',
              width: 25,
              height: 25,
            ),
          ),
        ),
        leadingWidth: 55.0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavigationTile(
                  context,
                  title: 'Purchase History',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            PurchasedCoursesPage(
                          userId: widget.userId,
                        ),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                //const Divider(height: 1, color: Color(0xFFCCCCCC)),
                _buildNavigationTile(
                  context,
                  title: 'Amset Recommended',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const AmsetRecommendedPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
                //const Divider(height: 1, color: Color(0xFFCCCCCC)),
                _buildNavigationTile(
                  context,
                  title: 'Amset Coins',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const AmsetCoinsPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 300)); // Add delay
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(117, 192, 68, 0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: -0.3,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.sp,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
