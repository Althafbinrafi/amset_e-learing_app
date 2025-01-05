import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChapterPage extends StatefulWidget {
  final String chapterId;
  final String courseId;

  const ChapterPage(
      {super.key, required this.chapterId, required this.courseId});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  late Future<Map<String, dynamic>> chapterDataFuture;
  List<Map<String, dynamic>> userAnswers = [];
  int correctAnswersCount = 0;
  String message = "";
  bool isViewMore = false;
  bool isSubmitted = false;
  YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    chapterDataFuture = fetchChapterData();
  }

  Future<Map<String, dynamic>> fetchChapterData() async {
    final url =
        'https://amset-server.vercel.app/api/chapter/${widget.chapterId}?courseId=${widget.courseId}';
    log('Fetching chapter from: $url');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }
      log('Token being used: $token');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> chapterData = jsonDecode(response.body);
        log('Chapter data: ${response.body}');

        // Initialize YouTube player controller if video URL is present
        if (chapterData['videoUrl'] != null) {
          final videoId = extractVideoId(chapterData['videoUrl']);
          if (videoId != null) {
            _youtubePlayerController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(autoPlay: false),
            );
          }
        }

        // Check if already submitted
        if (chapterData['isSubmitted'] == true) {
          setState(() {
            isSubmitted = true;
          });
        }
        return chapterData;
      } else {
        throw Exception('Failed to fetch chapter data: ${response.statusCode}');
      }
    } catch (error) {
      log('Error fetching chapter: $error');
      throw Exception('An error occurred while fetching the chapter.');
    }
  }

  String? extractVideoId(String url) {
    final regex = RegExp(
        r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^/]+\/.+\/|(?:v|embed|e)\/|.*[?&]v=)|youtu\.be\/)([^"&?/\s]{11})');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chapter Page')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: chapterDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          final chapter = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter Title
                  Center(
                    child: Text(
                      chapter['title'] ?? 'No title',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chapter Description
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter['description'] ?? 'No description available.',
                          maxLines: isViewMore ? null : 5,
                          overflow: isViewMore
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => setState(() => isViewMore = !isViewMore),
                          child: Text(
                            isViewMore ? 'View Less' : 'View More',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Video Section
                  if (_youtubePlayerController != null)
                    YoutubePlayer(
                      controller: _youtubePlayerController!,
                      showVideoProgressIndicator: true,
                    )
                  else
                    const Text(
                      'Invalid or missing video URL.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 16),

                  // Questions Section
                  if (chapter['questions'] != null &&
                      chapter['questions'].isNotEmpty) ...[
                    const Text(
                      'Questions',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...chapter['questions'].map<Widget>((question) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question['questionText'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              ...question['options']
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final idx = entry.key;
                                final option = entry.value;

                                return RadioListTile<int>(
                                  value: idx,
                                  groupValue: userAnswers.firstWhere(
                                    (answer) =>
                                        answer['questionId'] == question['_id'],
                                    orElse: () => {'selectedOptionIndex': -1},
                                  )['selectedOptionIndex'],
                                  onChanged: (value) {
                                    setState(() {
                                      userAnswers.add({
                                        'questionId': question['_id'],
                                        'selectedOptionIndex': value!,
                                      });
                                    });
                                  },
                                  title: Text(option),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                  const SizedBox(height: 16),

                  // Submit Button or Already Submitted
                  if (isSubmitted)
                    const Center(
                      child: Text(
                        'Submitted',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => handleSubmit(chapter),
                      child: const Text('Submit Answers'),
                    ),

                  // Feedback Message
                  if (message.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        message,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.green),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void handleSubmit(Map<String, dynamic> chapter) async {
    try {
      if (userAnswers.isEmpty) {
        setState(() {
          message = 'Please answer all questions before submitting.';
        });
        return;
      }

      // Validate if all questions are answered
      final allQuestionsAnswered = chapter['questions'].every((question) {
        return userAnswers
            .any((answer) => answer['questionId'] == question['_id']);
      });

      if (!allQuestionsAnswered) {
        setState(() {
          message = 'Please answer all questions before submitting.';
        });
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      // Prepare request body
      final requestBody = {
        'userAnswers': userAnswers.map((answer) {
          return {
            'questionId': answer['questionId'],
            'selectedOptionIndex': answer['selectedOptionIndex'],
          };
        }).toList(),
      };

      final response = await http.post(
        Uri.parse(
            'https://amset-server.vercel.app/api/chapter/${widget.chapterId}/complete-chapter?courseId=${widget.courseId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        setState(() {
          message = "Congratulations! You've earned 100 coins.";
          isSubmitted = true;
        });
      } else {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to submit answers.');
      }
    } catch (e) {
      log('Error submitting answers: $e');
      setState(() {
        message = e.toString();
      });
    }
  }
}
