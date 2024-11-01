import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:amset/Models/registration_model.dart';

class ApiServiceReg {
  static const String baseUrl = 'https://amset-server.vercel.app/api';

  Future<RegistrationModel> registerUser({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String mobileNumber,
  }) async {
    final url = Uri.parse('$baseUrl/user/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "fullName": fullName,     // Added fullName field
          "username": username,
          "email": email,
          "password": password,
          "mobileNumber": mobileNumber,
        }),
      );

      if (response.statusCode == 201) {
        return registrationModelFromJson(response.body);
      } else {
        throw Exception('Failed to register user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }
}
