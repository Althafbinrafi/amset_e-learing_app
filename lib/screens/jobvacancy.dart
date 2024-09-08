import 'package:amset/Models/vacancy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'register_page.dart'; // import your register page

class JobVacancyPage extends StatefulWidget {
  const JobVacancyPage({super.key});

  @override
  State<JobVacancyPage> createState() => _JobVacancyPageState();
}

class _JobVacancyPageState extends State<JobVacancyPage> {
  bool _isLoading = false;
  bool _isFetching = true; // Loading flag for fetching data
  List<Datum> _vacancies = [];

  @override
  void initState() {
    super.initState();
    fetchVacancies(); // Call the API when the widget is initialized
  }

  Future<void> fetchVacancies() async {
    const String url =
        'https://amset-server.vercel.app/api/vacancy'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final VacancyModel vacancyModel = vacancyModelFromJson(response.body);
        setState(() {
          _vacancies = vacancyModel.data;
          _isFetching = false;
        });
      } else {
        throw Exception('Failed to load vacancies');
      }
    } catch (e) {
      setState(() {
        _isFetching = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const Registerpage();
      }));
    });
  }

  Widget buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(7, (index) {
            return Container(
              margin: EdgeInsets.only(bottom: 20.h),
              padding: EdgeInsets.all(10.w),
              width: MediaQuery.of(context).size.width / 1,
              height: 85.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60.h,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150.w,
                          height: 14.h,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: 100.w,
                          height: 12.h,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(55, 202, 0, 1),
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
      body: Stack(
        children: [
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
            child: _isFetching
                ? buildShimmerEffect() // Show shimmer effect while loading
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Job Vacancy Containers
                        ..._vacancies.map((vacancy) {
                          return Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20.h),
                                padding: EdgeInsets.all(10.w),
                                width: MediaQuery.of(context).size.width / 1,
                                height: 85.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          150, 150, 150, 69),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(7),
                                      width: 60.h,
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: const Color.fromRGBO(
                                            217, 217, 217, 41),
                                      ),
                                      child: SvgPicture.network(
                                        vacancy.imageUrl,
                                        fit: BoxFit.contain,
                                        placeholderBuilder: (context) =>
                                            const CircularProgressIndicator(),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            vacancy.title,
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
                                                "Company", // Adjust as needed
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.5.sp,
                                                  color: const Color.fromRGBO(
                                                      117, 115, 115, 1),
                                                ),
                                              ),
                                              Text(
                                                'Vacancies Info', // Adjust as needed
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.sp,
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

                        // Register Information Text
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

                        SizedBox(height: 120.h), // Add some bottom padding
                      ],
                    ),
                  ),
          ),

          // Floating Register Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(20.h),
              child: Container(
                width: 300.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF006257),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextButton(
                  onPressed: _onGetStartedPressed,
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
