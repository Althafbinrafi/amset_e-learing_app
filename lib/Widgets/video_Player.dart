// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CoursePlayer extends StatefulWidget {
  final String videoUrl;
  final ValueNotifier<bool> isFullScreen;

  const CoursePlayer(
      {super.key, required this.videoUrl, required this.isFullScreen});

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
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        forceHD: true,
      ),
    );

    _controller.addListener(_onPlayerStateChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPlayerStateChange() {
    if (_controller.value.isFullScreen) {
      widget.isFullScreen.value = true;
    } else {
      widget.isFullScreen.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.white,
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: const ProgressBarColors(
            handleColor: Color(0xFF006257),
            playedColor: Color(0xFF006257),
          ),
        ),
        RemainingDuration(),
        const PlaybackSpeedButton(
          icon: Icon(
            Icons.speed,
            color: Colors.white,
          ),
        ),
        FullScreenButton(),
      ],
      onReady: () {
        log('Player is ready.');
      },
    );
  }
}
