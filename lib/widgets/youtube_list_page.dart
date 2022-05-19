import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// YoutubeListPage

class YoutubeListPage extends StatefulWidget {
  final Map videoObj;

  const YoutubeListPage({@required this.videoObj});
  @override
  _YoutubeListPageState createState() => _YoutubeListPageState();
}

class _YoutubeListPageState extends State<YoutubeListPage> {
  List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    _controllers = widget.videoObj["youtubeListID"]
        .map<YoutubePlayerController>(
          (videoId) => YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
            ),
          ),
        )
        .toList();

    super.initState();
  }

  @override
  void dispose() {
    _controllers.map((e) => e.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoObj["title"]),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return YoutubePlayer(
            key: ObjectKey(_controllers[index]),
            controller: _controllers[index],
            actionsPadding: const EdgeInsets.only(left: 16.0),
            bottomActions: [
              CurrentPosition(),
              const SizedBox(width: 10.0),
              ProgressBar(isExpanded: true),
              const SizedBox(width: 10.0),
              RemainingDuration(),
              FullScreenButton(),
            ],
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      ),
    );
  }
}
