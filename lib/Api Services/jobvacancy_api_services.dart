import 'package:amset/Models/Course%20Models/course_fetch_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://amset-server.vercel.app/api/course/";

  Future<CourseFetchModel> fetchCourses() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final model = courseFetchModelFromJson(response.body);

        // Filter to include only published courses
        model.courses =
            model.courses.where((course) => course.isPublished).toList();

        return model;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
