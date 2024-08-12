import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JobVacancyPage extends StatefulWidget {
  const JobVacancyPage({super.key});

  @override
  State<JobVacancyPage> createState() => _JobVacancyPageState();
}

class _JobVacancyPageState extends State<JobVacancyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF006257),
        toolbarHeight: 130,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Top IT Field Jobs",
          style: TextStyle(
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios_new),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1,
                height: 100,
                decoration: BoxDecoration(color: Colors.amber),
              )
            ],
          ),
        ),
      ),
    );
  }
}
