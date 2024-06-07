import 'package:amset/Pages/course_page.dart';
import 'package:amset/Pages/notification_page.dart';
import 'package:amset/Pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0; // Initial index for the bottom navigation bar

  final List<Widget> _pages = [
    DashboardPage(),
    const CoursePage(),
    const NotificationPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Color(0xFF006257),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes',
                    style: TextStyle(
                      color: Color(0xFF006257),
                    )),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          decoration: const BoxDecoration(
            color: Color.fromARGB(
                255, 167, 144, 144), // Background color of the container
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
            child: BottomNavigationBar(
              backgroundColor: const Color.fromARGB(0, 103, 82, 82),
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: const Color(0xFF006257), // Selected item color
              unselectedItemColor: Colors.grey, // Unselected item color
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu_book_rounded,
                    size: 30,
                  ),
                  label: 'Course',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  label: 'Notification',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          height: 290,
          padding: const EdgeInsets.only(top: 70, left: 50, right: 50),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            gradient: LinearGradient(
              end: Alignment.centerLeft,
              begin: Alignment.centerRight,
              colors: <Color>[Color(0xFF00C8B2), Color(0xFF008172)],
            ),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Althaf BinRafi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Icon(
                    Icons.account_circle_sharp,
                    color: Colors.white,
                    size: 50,
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 220), // Adjust top margin as needed
                height: 130,
                width: MediaQuery.of(context).size.width - 70,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text("Special Events shows here"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF006257),
                    maxRadius: 5,
                  ),
                  SizedBox(width: 4),
                  CircleAvatar(
                    backgroundColor: Color(0xFFBDBDBD),
                    maxRadius: 5,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFBDBDBD),
                    maxRadius: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: screenWidth,
            padding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 20),
            //color: Colors.amber,
            height: 470,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //  color: Colors.amber,
                  margin: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: const Text(
                    'Our Courses',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 1.8,
                    children: [
                      _buildCourseCard(
                        context,
                        'assets/images/restaurent.png',
                        'Restaurant Operations and Management',
                        '11 Lessons',
                        '6 Hours',
                        'Rs. 999 /-',
                        0, // Index
                      ),
                      _buildCourseCard(
                        context,
                        'assets/images/mobile.png',
                        'Mobile Retail Excellence',
                        '8 Lessons',
                        '4 Hours',
                        'Rs. 799 /-',
                        1, // Index
                      ),
                      _buildCourseCard(
                        context,
                        'assets/images/market.png',
                        'Hypermarket Management Mastery',
                        '23 Lessons',
                        '12 Hours',
                        'Rs. 1299 /-',
                        2, // Index
                      ),
                      _buildCourseCard(
                        context,
                        'assets/images/fasion.png',
                        'Fashion Design Coaching',
                        '10 Lessons',
                        '5 Hours',
                        'Rs. 899 /-',
                        3, // Index
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showCourseDrawer(BuildContext context, String title, String lessons,
      String duration, String price) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            height: 600,
            width: MediaQuery.of(context).size.width / 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(
                  color: const Color.fromARGB(255, 122, 121, 121),
                  endIndent: 150,
                  indent: 150,
                  thickness: 4,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Course Description:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 5),
                const Text(
                  '''
          Unlock the secrets to excelling in the mobile retail industry with our comprehensive course, "Mobile Retail Excellence." Designed for aspiring entrepreneurs, retail managers, and sales professionals, this course offers a deep dive into the strategies and skills necessary to thrive in the fast-paced world of mobile retail.
          
          Over the span of 8 engaging lessons, you will learn how to optimize your retail operations, enhance customer experiences, and boost sales. Each lesson is crafted to provide practical insights and actionable techniques, ensuring you can apply what you learn directly to your business. By the end of the course, you'll be equipped with the knowledge and confidence to achieve excellence in mobile retail.
          
         ''',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '''
          Course Details:
          Duration: 4 hours
          Fee: Rs. 799 /-
          ''',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                    color: Color(0xFF006257),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Enroll',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 10),
                // Text(duration),
                // const SizedBox(height: 10),
                // Text(price,
                //     style: const TextStyle(
                //         color: Color(0xFF006257), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, String imagePath, String title,
      String lessons, String duration, String price, int index) {
    double screenheight = MediaQuery.of(context).size.width;

    // Define a list of background colors
    final List<Color> backgroundColors = [
      Colors.red.shade100,
      Colors.green.shade100,
      Colors.blue.shade100,
      Colors.orange.shade100,
    ];

    // Get the background color based on the index
    Color backgroundColor = backgroundColors[index % backgroundColors.length];

    return GestureDetector(
      onTap: () => _showCourseDrawer(context, title, lessons, duration, price),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              height: screenheight,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: backgroundColor, // Set the background color here
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1d1b1e),
                      letterSpacing: 0.3,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        lessons,
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        duration,
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF006257),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
