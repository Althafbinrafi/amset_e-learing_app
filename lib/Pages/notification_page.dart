import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:percent_indicator/linear_percent_indicator.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height / 1.4;

    return Scaffold(
      backgroundColor: Color(0xFF006257),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              color: Color(0xFF006257),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Center(
                child: Text(
              'No Notifications !',
              style: TextStyle(fontSize: 16),
            )),
          ),
        ],
      ),
    );
  }
}
