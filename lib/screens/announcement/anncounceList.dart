import 'dart:convert';

import 'package:exchangilymobileapp/screen_state/announcement/announcement_list_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/globalLang.dart';
import 'package:exchangilymobileapp/widgets/html_page.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/globals.dart' as globals;

class AnnouncementList extends StatelessWidget {
  AnnouncementList();
  // AnnouncementList(this.model.announceList);
  // final List model.announceList;

  convertDateFormat(date) {
    var parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat('yyyy-MM-dd H:m');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen<AnnouncementListScreenState>(
        onModelReady: (model) async {
          print("announceList page!!!!!");
          model.context = context;
          await model.init();
        },
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(
               getlangGlobal()=="en"?
                'Announcement List'
               :"公告列表"
                ),
              centerTitle: true,
            ),
            body: model.busy
                ? LoadingGif()
                : Container(
                    child: model.announceList.length < 1
                        ? Center(
                            child: Text(
                            "No Announcement",
                            style: TextStyle(color: Colors.white),
                          ))
                        : ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: model.announceList.length,
                            itemBuilder: (context, index) {
                              // print("index: " + index.toString());
                              // print(model.announceList[index].toString());
                              // print("isRead: " +
                              //     model.announceList[index]['isRead']
                              //         .toString());
                              // model.announceList[index].forEach((k,v){
                              //   print("key: " +k);
                              //   print("value: " +v.toString());
                              // });
                              return Card(
                                  color: globals.walletCardColor,
                                  child: InkWell(
                                    onTap: () async {
                                      //push to new page
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HtmlPage(
                                                  htmlData: model.announceList[
                                                      index]))).then(
                                          (value) => {
                                                //update read status
                                                model.updateReadStatus(index)
                                              });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              model.announceList[index]
                                                          .containsKey(
                                                              'isRead') &&
                                                      model.announceList[index]
                                                              ['isRead'] ==
                                                          false
                                                  // &&
                                                  //         model.announceList[index]['isRead'].toString() ==
                                                  //             "false"
                                                  ? Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red),
                                                      child: Center(),
                                                    )
                                                  : Container(),
                                              Offstage(
                                                  offstage: !(model
                                                          .announceList[index]
                                                          .containsKey(
                                                              'isRead') &&
                                                      model.announceList[index]
                                                              ['isRead'] ==
                                                          false),
                                                  child: SizedBox(width: 5)),
                                              Text(
                                                  model.announceList[index]
                                                          ["category"] +
                                                      model.announceList[index]
                                                              ['isRead']
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  )),
                                              // ['isRead']
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                              model.announceList[index]
                                                  ["title"],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline2
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          Text(
                                              convertDateFormat(
                                                  model.announceList[index]
                                                      ["dateCreated"]),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5),
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                  )));
  }
}
