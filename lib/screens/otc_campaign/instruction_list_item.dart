// import 'package:exchangilymobileapp/screens/otc_campaign/campaign_single.dart';
// import 'package:flutter/material.dart';

// class InstructionListItem extends StatelessWidget {
//   InstructionListItem(this.event);
//   final dynamic event;

//   Widget flutterPage() {
//     return Container(
//         // height: 100,
//         width: double.infinity,
//         margin: EdgeInsets.only(bottom: 10),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(5),
//           child: InkWell(
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           CampaignSingle(model.campaignInfoList[index]["id"])));
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//               ),
//               child: Column(
//                 children: <Widget>[
//                   AspectRatio(
//                     aspectRatio: 2.5 / 1,
//                     child: CacheImage(
//                       model.campaignInfoList[index]["coverImage"],
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(model.campaignInfoList[index][model.lang]["title"],
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headline2
//                                 .copyWith(fontWeight: FontWeight.bold)),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                             model.campaignInfoList[index][model.lang]
//                                     ["startDate"] +
//                                 " - " +
//                                 model.campaignInfoList[index][model.lang]
//                                     ["endDate"],
//                             style: TextStyle(
//                               color: Colors.white,
//                             )),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(model.campaignInfoList[index][model.lang]["desc"],
//                             maxLines: 4,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               color: Color(0xffeeeeee),
//                             )),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch (event['type']) {
//       case "flutterPage":
//         return flutterPage();
//         break;
//       default:
//         return Container();
//         break;
//     }
//   }
// }
