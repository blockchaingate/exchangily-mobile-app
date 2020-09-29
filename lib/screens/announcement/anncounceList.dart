import 'package:exchangilymobileapp/shared/globalLang.dart';
import 'package:exchangilymobileapp/widgets/html_page.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class AnnouncementList extends StatelessWidget {
  AnnouncementList(this.announceList);
  final List announceList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Announcement List'),
          centerTitle: true,
        ),
        body: Container(
          child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: announceList.length,
              itemBuilder: (context, index) {
                print("index: " + index.toString());
                print(announceList[index].toString());
                return Card(
                    color: globals.walletCardColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HtmlPage(htmlData: announceList[index])));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(announceList[index]["type"],
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(announceList[index][getlangGlobal()]["title"],
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ));
              }),
        ));
  }
}
