import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CoursePlayer extends StatefulWidget {
  final String videoUrl;

  const CoursePlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _CoursePlayerState createState() => _CoursePlayerState();
}

class _CoursePlayerState extends State<CoursePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
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
      progressIndicatorColor: const Color.fromARGB(255, 255, 255, 255),
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: ProgressBarColors(
            handleColor: Color(0xFF006257),
            playedColor: Color(0xFF006257),
          ),
        ),
        
        RemainingDuration(),
        
        PlaybackSpeedButton(
            icon: Icon(
          Icons.speed,
          color: Colors.white,
        )),
        FullScreenButton(),
      ],
      onReady: () {
        print('Player is ready.');
      },
    );
  }
}
