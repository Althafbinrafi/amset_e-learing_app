import 'package:flutter/material.dart';
import 'package:amset/screens/dashboard.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightFactor = size.height / 812; // Common height for scaling
    final widthFactor = size.width / 375; // Common width for scaling

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 10 * widthFactor, vertical: 20 * heightFactor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50 * heightFactor),
                Image.asset(
                  'assets/images/login.png',
                  height: 250 * heightFactor,
                  width: 250 * widthFactor,
                ),
                SizedBox(height: 50 * heightFactor),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0 * widthFactor),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20 * widthFactor,
                          vertical: 20 * heightFactor),
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius:
                            BorderRadius.all(Radius.circular(18 * widthFactor)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(18 * widthFactor)),
                        borderSide:
                            BorderSide(color: Color(0xFF006257), width: 2),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 30 * heightFactor),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0 * widthFactor),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20 * widthFactor,
                          vertical: 20 * heightFactor),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius:
                            BorderRadius.all(Radius.circular(18 * widthFactor)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(18 * widthFactor)),
                        borderSide:
                            BorderSide(color: Color(0xFF006257), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    obscureText: !_isPasswordVisible,
                  ),
                ),
                SizedBox(height: 60 * heightFactor),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20 * widthFactor),
                    color: Color(0xFF006257),
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });

                      await Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          _isLoading = false;
                        });

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return const Dashboard();
                        }));
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006257),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 80 * widthFactor,
                          vertical: 15 * heightFactor),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 20 * heightFactor,
                            width: 20 * widthFactor,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(fontSize: 18 * heightFactor),
                          ),
                  ),
                ),
                SizedBox(height: 30 * heightFactor),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5 * heightFactor),
                  width: 110 * widthFactor,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    //color: const Color(0xFF006257),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo1.png',
                        height: 30 * heightFactor,
                        width: 30 * heightFactor,
                      ),
                      SizedBox(
                        width: 5 * widthFactor,
                      ),
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
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      //   child: Text('Back'),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
}
