import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class CoursePlayer extends StatefulWidget {
  CoursePlayer({required Key key}) : super(key: key);

  @override
  _CoursePlayerState createState() => _CoursePlayerState();
}

class _CoursePlayerState extends State<CoursePlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
      Uri.parse("url"),
    ));
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();

    @override
    Widget build(BuildContext context) {
      return Container(
        child: FlickVideoPlayer(flickManager: flickManager),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
