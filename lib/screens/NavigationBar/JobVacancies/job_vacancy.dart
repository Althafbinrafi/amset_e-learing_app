import 'package:amset/Api%20Services/jobvacancy_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../Models/Course Models/course_fetch_model.dart';
import '../../Job Apply Pages/apply_job.dart';

class JobVacancyController extends GetxController {
  var isExpanded = false.obs;
  var isSearching = false.obs;
  var filteredCourses = <Course>[].obs;
  var allCourses = <Course>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  void fetchCourses() async {
    try {
      var data = await ApiService().fetchCourses();
      allCourses.assignAll(data.courses.where((course) => course.isPublished));
      filteredCourses.assignAll(allCourses);
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  void filterCourses(String query) {
    isSearching.value = query.isNotEmpty;
    if (query.isEmpty) {
      filteredCourses.assignAll(allCourses);
    } else {
      filteredCourses.assignAll(allCourses
          .where((course) =>
              course.isPublished &&
              course.title.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }
}

class JobVacancy extends StatelessWidget {
  const JobVacancy({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobVacancyController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Jobs & Vacancies',
          style: GoogleFonts.dmSans(fontSize: 24.sp, letterSpacing: -0.5.w),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey[300], height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoadingEffect();
          }
          if (controller.errorMessage.isNotEmpty) {
            return _buildErrorState(controller.errorMessage.value, controller);
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  child: _buildSearchBar(controller),
                ),
                SizedBox(height: 25.h),
                if (controller.isSearching.value &&
                    controller.filteredCourses.isEmpty)
                  _buildNoResults()
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Obx(() => GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            mainAxisSpacing: 14.h,
                            crossAxisSpacing: 15.w,
                          ),
                          itemCount: controller.isExpanded.value
                              ? controller.filteredCourses.length
                              : (controller.filteredCourses.length > 6
                                  ? 6
                                  : controller.filteredCourses.length),
                          itemBuilder: (context, index) {
                            return _buildCourseItem(
                                controller.filteredCourses[index]);
                          },
                        )),
                  ),
                SizedBox(height: 29.h),
                if (controller.filteredCourses.length > 6)
                  _buildViewMoreToggle(controller),
                SizedBox(height: 15.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingEffect() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/loading.json',
              width: 200.w, height: 200.h, fit: BoxFit.contain),
          SizedBox(height: 20.h),
          Text('Loading Jobs...',
              style: GoogleFonts.dmSans(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                  letterSpacing: -0.5)),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, JobVacancyController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/error.json',
              width: 200.w, height: 200.h, fit: BoxFit.contain),
          SizedBox(height: 20.h),
          Text('Oops! Something went wrong',
              style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5)),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(error,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    letterSpacing: -0.5)),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => controller.fetchCourses(),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(117, 192, 68, 1)),
            child: Text('Retry',
                style: GoogleFonts.dmSans(
                    fontSize: 16.sp, color: Colors.white, letterSpacing: -0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(JobVacancyController controller) {
    return TextField(
      controller: controller.searchController,
      onChanged: controller.filterCourses,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 17.h),
        hintText: 'Search for jobs',
        hintStyle: GoogleFonts.dmSans(letterSpacing: -0.5.w, fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.r),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5))),
        suffixIcon: const Icon(Icons.search, color: Colors.grey),
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No matching jobs found',
              style: GoogleFonts.dmSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600])),
          SizedBox(height: 10.h),
          Text('Try different keywords or browse all jobs',
              style:
                  GoogleFonts.dmSans(fontSize: 14.sp, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildCourseItem(Course course) {
    return GestureDetector(
      onTap: () => Get.to(() => JobDetailPage(courseId: course.id)),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(left: 16.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22.r),
                      topRight: Radius.circular(22.r)),
                  color: Colors.green.withOpacity(0.15)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/images/job_sector1.svg',
                        height: 35.h, width: 35.w),
                    SizedBox(width: 10.w),
                    Expanded(
                        child: Text(course.title,
                            style: GoogleFonts.dmSans(
                                letterSpacing: -0.5.w, fontSize: 14.sp))),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(22.r),
                        bottomRight: Radius.circular(22.r),
                      )),
                  child: Center(
                      child: Text('${course.vacancyCount} Vacancies',
                          style: GoogleFonts.dmSans(
                              color: Colors.white, fontSize: 14.sp))))),
        ],
      ),
    );
  }

  Widget _buildViewMoreToggle(JobVacancyController controller) {
    return GestureDetector(
        onTap: () => controller.isExpanded.toggle(),
        child: Text(controller.isExpanded.value ? 'View Less' : 'View More'));
  }
}
