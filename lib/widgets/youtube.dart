// import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePage extends StatefulWidget {
  final Map? videoObj;

  const YoutubePage({required this.videoObj});

  @override
  _YoutubePageState createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoObj!["youtubeID"],
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.videoObj!["title"])),
        body: ListView(
          children: [
            SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  controller: _controller,
                  liveUIColor: Colors.amber,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.videoObj!["title"],
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.videoObj!["desc"],
                    style: const TextStyle(
                      color: Colors.white,
                    )))
          ],
        ));
  }
}
