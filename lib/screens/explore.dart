import 'package:amset/screens/jobvacancy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80.h,
        backgroundColor: const Color(0xFF006257),
        title: Text(
          'Explore',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25.sp),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Container(
                width: 100.w,
                height: 40.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Center(
                    child: Text(
                  'Register',
                  style: TextStyle(color: Colors.black, fontSize: 17.sp),
                )),
              )),
          SizedBox(
            width: 5.w,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
        child: Column(
          children: [
            Container(
              height: 130.h,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 153, 149, 149),
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 9.h,
                  width: 19.w,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10.r)),
                ),
                SizedBox(width: 3.w),
                Container(
                  height: 9.h,
                  width: 19.w,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10.r)),
                ),
                SizedBox(width: 3.w),
                Container(
                  height: 9.h,
                  width: 19.w,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10.r)),
                )
              ],
            ),
            SizedBox(height: 20.h),
            Row(children: [
              Text(
                "Job Vacancies",
                style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w500),
              )
            ]),
            SizedBox(
              height: 15.h,
            ),
            Expanded(
              child: GestureDetector(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.w,
                    mainAxisSpacing: 10.h,
                  ),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text('Container ${index + 1}'),
                      ),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return JobVacancyPage();
                  }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
