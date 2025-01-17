import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  bool isLoading = false;
  YoutubePlayerController? _youtubePlayerController;
  final PanelController _panelController = PanelController();
  bool showSuccessPanel = false;
  bool showErrorPanel = false;
  String errorMessage = '';
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    chapterDataFuture = fetchChapterData();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _youtubePlayerController?.dispose();
    super.dispose();
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

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> chapterData = jsonDecode(response.body);

        if (chapterData['videoUrl'] != null) {
          final videoId = extractVideoId(chapterData['videoUrl']);
          if (videoId != null) {
            _youtubePlayerController = YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
                disableDragSeek: false,
                loop: false,
                isLive: false,
                forceHD: false,
                enableCaption: true,
              ),
            );
          }
        }

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

  Widget _buildYoutubePlayer() {
    if (_youtubePlayerController == null) return const SizedBox.shrink();

    return OrientationBuilder(
      builder: (context, orientation) {
        return YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _youtubePlayerController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: const Color.fromARGB(255, 0, 183, 82),
            progressColors: const ProgressBarColors(
              playedColor: Colors.green,
              handleColor: Colors.green,
            ),
            actionsPadding: const EdgeInsets.all(8),
          ),
          onEnterFullScreen: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]);
            setState(() {
              _isFullScreen = true;
            });
          },
          onExitFullScreen: () {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ]);
            setState(() {
              _isFullScreen = false;
            });
          },
          builder: (context, player) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: player,
            );
          },
        );
      },
    );
  }

  Widget _buildDescriptionSection(Map<String, dynamic> chapter) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32)),
          color: Color(0xFFF1F9EC),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapter['description'] ?? 'No description available.',
                maxLines: isViewMore ? null : 5,
                overflow:
                    isViewMore ? TextOverflow.visible : TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                    fontSize: 16, color: Colors.black, letterSpacing: -0.3),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() => isViewMore = !isViewMore),
                child: Text(
                  isViewMore ? 'View Less' : 'View More',
                  style: const TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 15),
              _buildStudyNotesButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudyNotesButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(32)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Study Notes',
            style: GoogleFonts.dmSans(fontSize: 16.0, letterSpacing: -0.3),
          ),
          Container(
            width: 66,
            height: 25,
            decoration: BoxDecoration(
              color: const Color(0xFF75C044),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                'View',
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 16.0,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsSection(Map<String, dynamic> chapter) {
    if (chapter['questions'] == null || chapter['questions'].isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions',
            style: GoogleFonts.dmSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          ...chapter['questions'].map<Widget>((question) {
            return _buildQuestionCard(question);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(32)),
        color: Color(0xFFF1F9EC),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question['questionText'],
              style:
                  GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...question['options'].asMap().entries.map<Widget>((entry) {
              final idx = entry.key;
              final option = entry.value;
              final isCorrect =
                  isSubmitted && idx == question['correctOptionIndex'];
              final isSelected = userAnswers.any((answer) =>
                  answer['questionId'] == question['_id'] &&
                  answer['selectedOptionIndex'] == idx);
              final isWrong = isSubmitted && isSelected && !isCorrect;

              return RadioListTile<int>(
                value: idx,
                groupValue: userAnswers.firstWhere(
                  (answer) => answer['questionId'] == question['_id'],
                  orElse: () => {'selectedOptionIndex': -1},
                )['selectedOptionIndex'],
                onChanged: isSubmitted
                    ? null
                    : (value) {
                        setState(() {
                          userAnswers.removeWhere((answer) =>
                              answer['questionId'] == question['_id']);
                          userAnswers.add({
                            'questionId': question['_id'],
                            'selectedOptionIndex': value!,
                          });
                        });
                      },
                title: Text(
                  option,
                  style: GoogleFonts.dmSans(fontSize: 14),
                ),
                secondary: isSubmitted
                    ? Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCorrect
                              ? Colors.green
                              : (isWrong ? Colors.red : Colors.transparent),
                        ),
                        child: Icon(
                          isCorrect
                              ? Icons.check
                              : (isWrong ? Icons.close : null),
                          color: Colors.white,
                          size: 16,
                        ),
                      )
                    : null,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Map<String, dynamic> chapter) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: isSubmitted
          ? Center(
              child: Text(
                'Submitted',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : () => handleSubmit(chapter),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF75C044),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 0, 0, 0),
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      'Submit Answers',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
            ),
    );
  }

  Widget _buildSuccessPanel() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 60% of screen height
      padding: EdgeInsets.symmetric(
        horizontal:
            MediaQuery.of(context).size.width * 0.05, // 5% of screen width
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // Drawer handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Lottie animation
          Lottie.asset(
            'assets/images/claimCoin.json',
            width:
                MediaQuery.of(context).size.width * 0.35, // 35% of screen width
            height: MediaQuery.of(context).size.width * 0.35, // Keep it square
            repeat: false,
          ),
          const SizedBox(height: 12),
          Text(
            'Congratulations!',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: MediaQuery.of(context).size.width *
                  0.05, // 5% of screen width
              fontWeight: FontWeight.bold,
              color: const Color(0xFF75C044),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You've earned 100 coins",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: MediaQuery.of(context).size.width *
                  0.04, // 4% of screen width
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _panelController.close();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75C044),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Claim Reward',
                style: GoogleFonts.dmSans(
                  fontSize: MediaQuery.of(context).size.width *
                      0.04, // 4% of screen width
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  'Error',
                  style: GoogleFonts.dmSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    errorMessage,
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showErrorPanel = false;
                    });
                    _panelController.close();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  void handleSubmit(Map<String, dynamic> chapter) async {
    if (!mounted) return;

    try {
      setState(() {
        isLoading = true;
      });

      // Initial validation
      if (userAnswers.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please answer all questions before submitting.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final allQuestionsAnswered = chapter['questions'].every((question) {
        return userAnswers
            .any((answer) => answer['questionId'] == question['_id']);
      });

      if (!allQuestionsAnswered) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please answer all questions before submitting.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Authentication token not found.');
      }

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

      if (!mounted) return;

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Server successfully processed the submission
        if (mounted) {
          setState(() {
            isSubmitted = true;
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Answers successfully submitted!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );

          setState(() {
            showSuccessPanel = true;
            _panelController.open();
          });
        }
      } else if (response.statusCode == 400 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Invalid submission'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (response.statusCode == 409 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This chapter has already been submitted'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit answers. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      log('Error submitting answers: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Network error. Please check your connection and try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          _youtubePlayerController?.toggleFullScreenMode();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SlidingUpPanel(
          controller: _panelController,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height * 0.4,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          panel: showSuccessPanel
              ? _buildSuccessPanel()
              : showErrorPanel
                  ? _buildErrorPanel()
                  : Container(),
          backdropEnabled: true,
          backdropOpacity: 0.5,
          onPanelClosed: () {
            setState(() {
              showSuccessPanel = false;
              showErrorPanel = false;
            });
          },
          body: FutureBuilder<Map<String, dynamic>>(
            future: chapterDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    'assets/images/loading2.json',
                    
                  ),
                );
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
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: _isFullScreen
                    ? null
                    : AppBar(
                        title: Text(
                          chapter['title'] ?? "Chapter",
                          style: GoogleFonts.dmSans(
                              fontSize: 20.0, letterSpacing: -0.3),
                        ),
                        centerTitle: true,
                        surfaceTintColor: Colors.transparent,
                        backgroundColor: Colors.white,
                        leading: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: SvgPicture.asset(
                              'assets/images/back_btn.svg',
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                        leadingWidth: 55.0,
                      ),
                body: Column(
                  children: [
                    // Video section with fixed height
                    SizedBox(
                      height: _isFullScreen
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.width *
                              9 /
                              16, // 16:9 aspect ratio
                      child: _buildYoutubePlayer(),
                    ),
                    // Scrollable content section
                    if (!_isFullScreen)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _buildDescriptionSection(chapter),
                                _buildQuestionsSection(chapter),
                                _buildSubmitButton(chapter),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
