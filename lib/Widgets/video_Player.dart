import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CoursePlayer extends StatefulWidget {
  const CoursePlayer({Key? key}) : super(key: key);

  @override
  _CoursePlayerState createState() => _CoursePlayerState();
}

class _CoursePlayerState extends State<CoursePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=BFU9eSKO_t4")!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.amber,
      onReady: () {
        _controller.addListener(() {});
      },
    );
  }
}