import 'package:amset/screens/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobVacancyPage extends StatefulWidget {
  const JobVacancyPage({super.key});

  @override
  State<JobVacancyPage> createState() => _JobVacancyPageState();
}

class _JobVacancyPageState extends State<JobVacancyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006257),
        toolbarHeight: 80,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Top IT Field Jobs",
          style: TextStyle(
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          child: const Icon(Icons.arrow_back_ios_new),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Job Vacancy Containers
              ...List.generate(5, (index) {
                // List of titles, companies, vacancies, and SVG paths
                final titles = [
                  'Senior Flutter Developer',
                  'Swift Developer',
                  'UI/UX Designer',
                  'Senior Web Developer',
                  'Data Scientist'
                ];

                final companies = [
                  'Google Inc.',
                  'Apple Inc.',
                  'Microsoft',
                  'Amazon Inc.',
                  'Spotify'
                ];

                final vacancies = [
                  '20+ vacancies',
                  '15 vacancies',
                  '10 vacancies',
                  '5 vacancies',
                  '7 vacancies'
                ];

                final svgImages = [
                  'assets/images/google 1.svg',
                  'assets/images/Vector.svg',
                  'assets/images/microsoft 1.svg',
                  'assets/images/amazon 1.svg',
                  'assets/images/spotify 1.svg',
                ];

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      padding: EdgeInsets.all(10.w),
                      width: MediaQuery.of(context).size.width / 1,
                      height: 85.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromRGBO(150, 150, 150, 69),
                            width: 1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(7.w),
                            width: 60.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: const Color.fromRGBO(217, 217, 217, 41),
                            ),
                            child: SvgPicture.asset(
                              svgImages[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  titles[index],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp),
                                ),
                                SizedBox(height: 5.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      companies[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12.sp,
                                        color: const Color.fromRGBO(
                                            117, 115, 115, 1),
                                      ),
                                    ),
                                    Text(
                                      vacancies[index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10.sp,
                                        color: const Color.fromRGBO(
                                            255, 154, 0, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),

              // Add Text
              SizedBox(height: 5.h),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "Register Here to Receive Detailed Information About All Vacancies",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: 300.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF006257),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: GestureDetector(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return const RegisterPage();
                      }));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
