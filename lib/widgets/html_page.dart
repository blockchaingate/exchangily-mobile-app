import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlPage extends StatelessWidget {
  const HtmlPage({Key? key, this.htmlData}) : super(key: key);
  final Map? htmlData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          htmlData!["title"],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: htmlData!["content"],
          //Optional parameters:
          style: {
            "html": Style(
                backgroundColor: Colors.black12,
                color: const Color(0xfff2f2f2)),
//            "h1": Style(
//              textAlign: TextAlign.center,
//            ),
            "table": Style(
              backgroundColor: const Color.fromARGB(0x50, 0xee, 0xee, 0xee),
            ),
            "tr": Style(
              border: const Border(bottom: BorderSide(color: Colors.grey)),
            ),
            "th": Style(
              padding: const EdgeInsets.all(6),
              backgroundColor: Colors.grey,
            ),
            "td": Style(
              padding: const EdgeInsets.all(6),
            ),
            "var": Style(fontFamily: 'serif'),
          },

          onImageError: (exception, stackTrace) {
            debugPrint(exception as String?);
          },
        ),
      ),
    );
  }
}
