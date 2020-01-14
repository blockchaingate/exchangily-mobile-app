import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class LoadHTMLFileToWEbView extends StatefulWidget {
  @override
  _LoadHTMLFileToWEbViewState createState() => _LoadHTMLFileToWEbViewState();
}

class _LoadHTMLFileToWEbViewState extends State<LoadHTMLFileToWEbView> {
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 200,
        height: 400,
        child:
        WebView(
          initialUrl: 'about:blank',
            javascriptMode:JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) async {
            _controller = webViewController;
            await loadHtmlFromAssets('assets/index.html', _controller);
          },
        )
      );
  }

  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileText = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(fileText, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')).toString());
  }
}
