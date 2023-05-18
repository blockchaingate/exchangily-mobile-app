import 'package:exchangilymobileapp/widgets/cache_image.dart';
import 'package:exchangilymobileapp/widgets/customSeparator.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class EventMainContent extends StatelessWidget {
  final List? campaignInfo;
  const EventMainContent(this.campaignInfo);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xff3d3da1),
        // border:
        //     Border.all(color: Color(0xbb3f4df1),width: 3)
      ),
      child: Column(
          children: campaignInfo!.map((e) {
        if (e["type"] == "row") {
          return ContentRow(
              e.containsKey("title2") ? e["title"] + e["title2"] : e["title"],
              e["text"]);
        } else if (e["type"] == "form") {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              ContentForm(e["content"][0]),
              const SizedBox(width: 5),
              ContentForm(e["content"][1]),
              const SizedBox(width: 5),
              ContentForm(e["content"][2])
            ]),
          );
        } else if (e["type"] == "rowList") {
          return ContentRowList(e["title"], e["text"]);
        } else if (e["type"] == "table") {
          return ContentRowTable(e["content"]);
        } else {
          return Container(
              // child: Widget(),
              );
        }
      }).toList()),
    );
  }
}

//text items
class ContentRow extends StatelessWidget {
  const ContentRow(this.title, this.text);
  final String? title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSeparator(
            color: Color(0xff131359),
          ),
          const SizedBox(height: 20),
          Offstage(
            offstage: title == "",
            child: Text(
              title!,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Offstage(
            offstage: title == "" || text == "",
            child: const SizedBox(height: 15),
          ),
          Offstage(
            offstage: text == "",
            child: Text(
              text!,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20)
        ]);
  }
}

//list items
class ContentRowList extends StatelessWidget {
  const ContentRowList(this.title, this.text);
  final String? title;
  final List? text;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSeparator(
            color: Color(0xff131359),
          ),
          const SizedBox(height: 20),
          Text(
            title!,
            style: const TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Column(
            children: text!.asMap().entries.map((e) {
              debugPrint("event runtimeType: ");
              debugPrint(e.value.runtimeType.toString());
              String type = e.value.runtimeType.toString();
              //map list under list
              if (type.startsWith("List")) {
                return Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                      children: e.value.asMap().entries.map<Widget>((l) {
                    return Container(
                      padding: EdgeInsets.only(
                          bottom: l.key + 1 == text!.length ? 0 : 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                              // width: 6,
                              // height: 6,
                              // decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     shape: BoxShape.circle)
                              child: Text(
                                (l.key + 1).toString() + ".",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                l.value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ]),
                    );
                  }).toList()),
                );
              } else if (e.value.runtimeType == String) {
                return Container(
                  padding: EdgeInsets.only(
                      bottom: e.key + 1 == text!.length ? 0 : 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.fromLTRB(0, 5, 6, 2),
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle)),
                        Flexible(
                          child: Text(
                            e.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
                  // child: DropCapText(
                  //   e.value,
                  //   style: TextStyle(color: Colors.white),
                  //   dropCapPadding: EdgeInsets.fromLTRB(0, 4, 6, 2),
                  //   dropCap: DropCap(
                  //       width: 6,
                  //       height: 6,
                  //       child: Container(
                  //           decoration: BoxDecoration(
                  //               color: Colors.white, shape: BoxShape.circle))),
                  // ),
                );
              } else {
                return Container();
              }
            }).toList(),
          ),
          // Text(
          //   text,
          //   style: TextStyle(color: Colors.white),
          // ),
          const SizedBox(height: 20)
        ]);
  }
}

//Form
class ContentForm extends StatelessWidget {
  const ContentForm(this.info);
  final Map? info;
  // final String icon;
  // final String title;
  // final String text;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xff000066),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                color: const Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info!["price"],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
              ),
              const SizedBox(height: 20),
              //icon image in form
              SizedBox(
                width: 40,
                height: 40,
                child: CacheImage(
                  info!["icon"],
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                info!["title"],
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                color: const Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info!["tier1"],
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                )),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  info!["reword1"],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 3),
              //   child: Text(
              //     info["client1"] + " referral",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                color: const Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info!["tier2"],
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                )),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  info!["reword2"],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 3),
              //   child: Text(
              //     info["client2"] + " referral",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3),
                color: const Color(0xff3d3da1).withOpacity(0.5),
                child: Center(
                    child: Text(
                  info!["tier3"],
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                )),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  info!["reword3"],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(vertical: 3),
              //   child: Text(
              //     info["client3"] + " referral",
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              const SizedBox(height: 5),
            ]),
      ),
    );
  }
}

//text items
class ContentRowTable extends StatelessWidget {
  const ContentRowTable(this.tcontent);
  final List? tcontent;

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   borderRadius:BorderRadius.circular(10)
      // ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              // color: Color(0xff000066),
              child: Table(
                  children: tcontent!.asMap().entries.map((e) {
                return TableRow(
                    children: e.value.map<Widget>((l) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    color: Color(e.key % 2 == 0 ? 0xff000066 : 0xaa000066),
                    child: Center(
                        child: Text(
                      l,
                      style: const TextStyle(color: Colors.white),
                    )),
                  );
                }).toList());
              }).toList()),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
