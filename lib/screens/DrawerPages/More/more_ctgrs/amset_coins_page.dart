import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../../../Models/Course Models/coure_fetch_by_id.dart';

class AmsetCoinsPage extends StatefulWidget {
  const AmsetCoinsPage({super.key});

  @override
  State<AmsetCoinsPage> createState() => _AmsetCoinsPageState();
}

class _AmsetCoinsPageState extends State<AmsetCoinsPage> {
  int _totalCoins = 0;
  List<CourseCoin> _courseCoins = [];
  String? _userId;
  String? _token;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAmsetCoinsData();
  }

  Future<void> _fetchAmsetCoinsData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      _userId = prefs.getString('user_id');

      if (_token == null || _userId == null) {
        log('Error: Missing token or user ID.');
        return;
      }

      final url = Uri.parse('https://amset-server.vercel.app/api/user/profile');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final profileData = User.fromJson(json.decode(response.body));
        final totalCoins = profileData.courseCoins.fold<int>(
          0,
          (sum, coin) => sum + coin.coins,
        );

        setState(() {
          _totalCoins = totalCoins;
          _courseCoins = profileData.courseCoins;
        });
      } else {
        log('Failed to fetch profile data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching profile data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          'amset Coins',
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
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/images/loading2.json',
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchAmsetCoinsData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Total Coins Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 22, 122, 57),
                              Color.fromARGB(255, 48, 89, 37)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 45, 107, 60)
                                  .withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/images/amset_coin.svg',
                              height: 55,
                              width: 55,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '$_totalCoins',
                              style: GoogleFonts.dmSans(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Total Coins',
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                letterSpacing: -0.3,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Course Coins List
                      if (_courseCoins.isEmpty)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No coins earned yet',
                                style: GoogleFonts.dmSans(
                                  letterSpacing: -0.3,
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _courseCoins.length,
                          itemBuilder: (context, index) {
                            final coin = _courseCoins[index];
                            return CoinDetailCard(courseCoin: coin);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CoinDetailCard extends StatelessWidget {
  final CourseCoin courseCoin;

  const CoinDetailCard({super.key, required this.courseCoin});

  Future<String> fetchCourseName(String courseId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // Retrieve token

      if (token == null) {
        debugPrint('Error: Missing token.');
        return 'Unknown Course';
      }

      final url =
          Uri.parse('https://amset-server.vercel.app/api/course/$courseId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final courseData = CoureFetchById.fromJson(json.decode(response.body));
        return courseData.course.title;
      } else {
        debugPrint('Failed to fetch course data: ${response.statusCode}');
        return 'Unknown Course';
      }
    } catch (e) {
      debugPrint('Error fetching course name: $e');
      return 'Unknown Course';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchCourseName(courseCoin.courseId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show Shimmer Effect
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }

        final courseName = snapshot.data ?? 'Unknown Course';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 58, 243, 33).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: Color.fromARGB(255, 48, 89, 37),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courseName,
                        style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/amset_coin.svg',
                            height: 22.h,
                            width: 22.w,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${courseCoin.coins} coins',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              letterSpacing: -0.3,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
