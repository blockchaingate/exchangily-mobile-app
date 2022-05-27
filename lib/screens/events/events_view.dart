import 'package:exchangilymobileapp/widgets/web_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventsView extends StatelessWidget {
  const EventsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            child: Card(
              child: Text('Blog'),
            ),
            onTap: () => const WebViewPage(
              url: "https://www.exchangily.com",
              title: "Exchangily Blog",
            ),
          )
        ],
      ),
    );
  }
}
