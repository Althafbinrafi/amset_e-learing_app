import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CoursePlayer extends StatefulWidget {
  final String videoUrl;

  const CoursePlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _CoursePlayerState createState() => _CoursePlayerState();
}

class _CoursePlayerState extends State<CoursePlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
        _controller.play();
      }).catchError((error) {
        setState(() {
          _isInitialized = false;
          _hasError = true;
        });
        print('Error initializing video player: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(child: Text('Failed to load video'));
    }
    return _isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
