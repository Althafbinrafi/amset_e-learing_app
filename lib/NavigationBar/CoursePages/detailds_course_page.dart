import 'package:amset/DrawerPages/Course/all_lessons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amset/Models/allCoursesModel.dart';

class CourseDetailPageHome extends StatelessWidget {
  final Course course;

  const CourseDetailPageHome({Key? key, required this.course})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        leading: GestureDetector(
          child: Icon(Icons.arrow_back_ios_new_rounded),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text('Course Details'),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            // Course Image
            Center(
              child: Container(
                height: 200.h,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        course.imageUrl ?? 'https://placeholder.com/344x201'),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(26.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Title
                  Text(
                    course.title,
                    style: GoogleFonts.dmSans(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Course Description
                  Text(
                    course.description.toString(),
                    style: GoogleFonts.dmSans(fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  // Price
                  Text(
                    'Price: \$${course.price}',
                    style: GoogleFonts.dmSans(
                      color: const Color.fromARGB(255, 232, 76, 65),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Chapters
                  Text(
                    'Chapters:',
                    style: GoogleFonts.dmSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: course.chapters.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          course.chapters[index].title,
                          style: GoogleFonts.dmSans(fontSize: 16.sp),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Color.fromRGBO(117, 192, 68, 1),
                          child: Text('${index + 1}'),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40.h),
                  // You can add more fields here if they are available in your Course model
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        child: FloatingActionButton(
          backgroundColor: Color.fromRGBO(117, 192, 68, 1),
          // splashColor: Colors.amber,
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //   return AllLessonsPage(courseId: ,)
            // }));
          },
          elevation: 0,
          child: Text(
            'Learn for Free',
            style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
