// import 'package:flutter/material.dart';

// class InfoPageService {
//   void forwardPage(Map pageInfoOgj) {
//     debugPrint("Event type: " + pageInfoOgj["type"]);

//     switch (pageInfoOgj["type"]) {
//       case "flutterPage":
//         return Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     CampaignSingle(pageInfoOgj["id"])));
//         break;
//       case "webPage":
//         return Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => WebViewPage(
//                       url: pageInfoOgj[model.lang]["url"],
//                       title: pageInfoOgj[model.lang]["title"],
//                     )));
//         break;
//       case "video":
//         return Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => VideoPage(
//                     videoObj: pageInfoOgj[model.lang])));
//         break;
//       case "youtube":
//         return Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => YoutubePage(
//                     videoObj: pageInfoOgj[model.lang])));
//         break;
//       case "youtubeList":
//         return Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => YoutubeListPage(
//                     videoObj: pageInfoOgj[model.lang])));
//         break;
//       default:
//         return null;
//     }
//   }
// }
