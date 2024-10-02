import 'dart:developer';

import 'package:amset/Models/vacany_model.dart';
import 'package:http/http.dart' as http;

class ApiServiceJob {
  Future<JobVacancyModel?> fetchJobVacancies() async {
    const String apiUrl =
        'https://amset-server.vercel.app/api/vacancy'; // Replace with your actual API URL

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return jobVacancyModelFromJson(response.body);
      } else {
        log('Failed to load job vacancies');
        return null;
      }
    } catch (e) {
      log('Error: $e');
      return null;
    }
  }
}
