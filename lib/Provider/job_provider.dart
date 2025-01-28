import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amset/Api%20Services/jobvacancy_api_services.dart';
import '../../../Models/Course Models/course_fetch_model.dart';

final courseProvider = FutureProvider<List<Course>>((ref) async {
  final apiService = ApiService();
  final data = await apiService.fetchCourses();
  return data.courses.where((course) => course.isPublished).toList();
});