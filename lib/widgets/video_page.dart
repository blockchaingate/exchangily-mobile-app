import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final Map videoObj;

  VideoPage({@required this.videoObj});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final FijkPlayer player = FijkPlayer();

  _VideoPageState();

  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.videoObj["url"], autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.videoObj["title"])),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: FijkView(
                  color: Colors.black,
                  player: player,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.videoObj["title"],
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.videoObj["desc"],
                    style: TextStyle(
                      color: Colors.white,
                    )))
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}

// class VideoPage extends StatefulWidget {
//   VideoPage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _VideoPageState createState() => _VideoPageState();
// }

// class _VideoPageState extends State<VideoPage> {
//   CachedVideoPlayerController controller;
//   @override
//   void initState() {
//     controller = CachedVideoPlayerController.network(
//         "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
//     controller.initialize().then((_) {
//       setState(() {});
//       controller.play();
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: controller.value != null && controller.value.initialized
//               ? AspectRatio(
//                   child: CachedVideoPlayer(controller),
//                   aspectRatio: controller.value.aspectRatio,
//                 )
//               : Center(
//                   child: CircularProgressIndicator(),
//                 )),
//     );
//   }
// }
