import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/Pre Dashboard Pages/splash.dart';

// Create an AuthNotifier to manage authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.loading()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? fullName = prefs.getString('fullName');
    String? email = prefs.getString('email');

    if (isLoggedIn && fullName != null && email != null) {
      state = AuthState.authenticated();
    } else {
      state = AuthState.unauthenticated();
    }
  }
}

// Define AuthState class to represent different states
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;

  AuthState._({required this.isLoading, required this.isAuthenticated});

  factory AuthState.loading() => AuthState._(isLoading: true, isAuthenticated: false);
  factory AuthState.authenticated() => AuthState._(isLoading: false, isAuthenticated: true);
  factory AuthState.unauthenticated() => AuthState._(isLoading: false, isAuthenticated: false);
}

// Create an AuthProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Main Page',
          theme: ThemeData(
            primaryColor: const Color(0xFF006257),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006257)),
          ),
          home: const AuthCheckPage(),
        );
      },
    );
  }
}

class AuthCheckPage extends ConsumerWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return authState.isAuthenticated 
      ? const SplashScreen()  // Navigate to dashboard/home
      : const SplashScreen(); // Navigate to login page
  }
}
