import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

// realtime: https://jsfiddle.net/TradingView/yozeu6k1/

class LoadHTMLFileToWEbView extends StatefulWidget {
  String pair;
  LoadHTMLFileToWEbView(this.pair);
  @override
  _LoadHTMLFileToWEbViewState createState() => _LoadHTMLFileToWEbViewState();
}

class _LoadHTMLFileToWEbViewState extends State<LoadHTMLFileToWEbView> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        height: 460,
        child:
        WebView(
          initialUrl: '',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller = webViewController;
            _loadHtmlFromAssets();
          },
        )
      );
  }


  _loadHtmlFromAssets() async {
    var pair = widget.pair.replaceAll(RegExp('/'), '');
    print('pairdddd=' + pair);
    // pair = 'index';
    String fileText = await rootBundle.loadString('assets/pages/' + pair + '.html');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }

}
