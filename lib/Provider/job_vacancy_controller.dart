import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amset/Api%20Services/jobvacancy_api_services.dart';
import '../../../Models/Course Models/course_fetch_model.dart';

class JobVacancyController extends GetxController {
  final RxBool _isExpanded = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxList<Course> filteredCourses = <Course>[].obs;
  final RxList<Course> allCourses = <Course>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  bool get isExpanded => _isExpanded.value;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
    searchController.addListener(filterCourses);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleExpansion() {
    _isExpanded.toggle();
  }

  Future<void> fetchCourses() async {
    try {
      isLoading(true);
      final data = await ApiService().fetchCourses();
      allCourses.assignAll(data.courses.where((course) => course.isPublished));
      filteredCourses.assignAll(allCourses);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  void filterCourses() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredCourses.assignAll(allCourses);
    } else {
      filteredCourses.assignAll(
        allCourses.where((course) => 
          course.title.toLowerCase().contains(query)
        ).toList()
      );
    }
  }
}