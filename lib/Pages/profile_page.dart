import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:percent_indicator/linear_percent_indicator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
                  'User Profile',
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
              color: Color(0xFF006257),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Color(0xFF006257),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 30,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                    maxRadius: 90,
                    backgroundColor: Colors.transparent,
                    child: SizedBox(
                        // width: 100,
                        // height: 100,
                        child: ClipOval(
                      child: Image.asset(
                        "assets/images/man.png",
                      ),
                    ))),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Muhammad Althaf PK',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '+91 8089891475',
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Color(0xFF006257),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
