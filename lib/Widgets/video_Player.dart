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
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId == null || videoId.isEmpty) {
      log('Invalid YouTube video URL: ${widget.videoUrl}');
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
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
    try {
      widget.isFullScreen.value = _controller.value.isFullScreen;
    } catch (e) {
      log('Error in _onPlayerStateChange: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.white,
      bottomActions: const [
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
