// ignore_for_file: file_names, depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/Course Models/all_course_model.dart';



class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<List<Course>> _searchResults;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]); // Initialize with an empty list
  }

  Future<List<Course>> _fetchSearchResults(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://amset-server.vercel.app/api/course/search?query=$query'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        AllCoursesModel coursesModel = AllCoursesModel.fromJson(data);
        return coursesModel.courses
            .where((course) => course.isPublished)
            .toList();
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Error fetching search results: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008172),
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search courses...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: const TextStyle(color: Colors.white),
          onSubmitted: (query) {
            setState(() {
              _searchResults = _fetchSearchResults(query);
            });
          },
        ),
      ),
      body: FutureBuilder<List<Course>>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No courses found'));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return ListTile(
                  title: Text(course.title),
                  onTap: () {
                    // Navigate to course details page if necessary
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
