import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define login state
class LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginState({required this.isLoading, this.errorMessage});

  LoginState copyWith({bool? isLoading, String? errorMessage}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Define login provider
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState(isLoading: false));

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await http.post(
        Uri.parse('https://amset-server.vercel.app/api/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', responseBody['token']);
        await prefs.setString('user_id', responseBody['user']['_id']);
        await prefs.setString('avatar_path', responseBody['user']['avatarPath'] ?? 'assets/images/man.png');
        await prefs.setString('email', responseBody['user']['email']);
        await prefs.setString('username', responseBody['user']['username']);
        await prefs.setString('mobileNumber', responseBody['user']['mobileNumber']);

        state = state.copyWith(isLoading: false);
        return true; // Successful login
      } else {
        state = state.copyWith(isLoading: false, errorMessage: responseBody['message'] ?? 'Login failed.');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'An error occurred. Please try again.');
      return false;
    }
  }
}

// Create the provider instance
final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) => LoginNotifier());
