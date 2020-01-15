import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

// realtime: https://jsfiddle.net/TradingView/yozeu6k1/

class LoadHTMLFileToWEbView extends StatefulWidget {
  @override
  _LoadHTMLFileToWEbViewState createState() => _LoadHTMLFileToWEbViewState();
}

class _LoadHTMLFileToWEbViewState extends State<LoadHTMLFileToWEbView> {
  Completer<WebViewController> _controller =
  Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        height: 350,
        child:
        WebView(
          initialUrl: 'assets/index.html?pairLeft=FAB&pairRight=USDT&interval=1h',
            javascriptMode:JavascriptMode.unrestricted,

          onWebViewCreated: (WebViewController webViewController)  {
            _controller.complete(webViewController);
          },


        )
      );
  }

  /*
  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileText = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }

   */
}
