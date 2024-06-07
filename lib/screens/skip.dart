import 'package:amset/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skip Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SkipPage(),
    );
  }
}

class SkipPage extends StatefulWidget {
  const SkipPage({super.key});

  @override
  State<SkipPage> createState() => _SkipPageState();
}

class _SkipPageState extends State<SkipPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  final List<String> images = [
    'assets/images/skip1.png',
    'assets/images/skip2.png',
    'assets/images/skip3.png',
  ];

  final List<String> titles = [
    'Find Your Goal',
    'Unlock Your Potential',
    'Achieve Your Dreams',
  ];

  final List<String> descriptions = [
    "Explore Amset to pinpoint your ideal career path in the hypermarket and supermarket industry.",
    "With Amset, unlock the doors to your full potential in the hypermarket and supermarket sectors.",
    "Let Amset be your partner in turning hypermarket and supermarket career dreams into reality.",
  ];

  void _onGetStartedPressed() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightFactor = size.height /
        812; // 812 is a common height for scaling (e.g., iPhone 11)
    final widthFactor =
        size.width / 375; // 375 is a common width for scaling (e.g., iPhone 11)

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20 * widthFactor, vertical: 30 * heightFactor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 500 * heightFactor,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          images[index],
                          fit: BoxFit.contain,
                          height: 300 * heightFactor,
                        ),
                        SizedBox(height: 20 * heightFactor),
                        Text(
                          titles[index],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 28 * heightFactor,
                          ),
                        ),
                        SizedBox(height: 10 * heightFactor),
                        Divider(
                          color: const Color(0xFF006257),
                          thickness: 3,
                          endIndent: 100 * widthFactor,
                          indent: 100 * widthFactor,
                        ),
                        SizedBox(height: 10 * heightFactor),
                        Text(
                          descriptions[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15 * heightFactor,
                            color: Colors.black.withOpacity(0.52),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20 * heightFactor),
              CircularAvatarIndicator(
                currentPage: _currentPage,
                totalPages: images.length,
              ),
              SizedBox(height: 30 * heightFactor),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: _currentPage == images.length - 1
                      ? const Color(0xFF006257)
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: _currentPage == images.length - 1
                      ? _onGetStartedPressed
                      : null,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18 * heightFactor,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5 * heightFactor),
                width: 110 * widthFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo1.png',
                      height: 30 * heightFactor,
                      width: 30 * heightFactor,
                    ),
                    SizedBox(width: 5 * widthFactor),
                    Text(
                      'amset',
                      style: GoogleFonts.prozaLibre(
                        textStyle: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18 * heightFactor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularAvatarIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const CircularAvatarIndicator({
    required this.currentPage,
    required this.totalPages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPage == index
                ? const Color(0xFF006257)
                : const Color(0xFFBDBDBD),
          ),
        );
      }),
    );
  }
}
