/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: ken.qiu@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:flutter/cupertino.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// realtime: https://jsfiddle.net/TradingView/yozeu6k1/

class LoadHTMLFileToWEbView extends StatefulWidget {
  final String pair;
  final String interval;
  //final bool isBusy;
  LoadHTMLFileToWEbView(
    this.pair,
    this.interval,
//  this.isBusy
  );
  @override
  _LoadHTMLFileToWEbViewState createState() => _LoadHTMLFileToWEbViewState();
}

class _LoadHTMLFileToWEbViewState extends State<LoadHTMLFileToWEbView> {
  // String interval = '1m';
  WebViewController _controller;
  ConfigService configService = locator<ConfigService>();
  String holder;
  @override
  Widget build(BuildContext context) {
    // isBusy ${widget.isBusy} --
    setState(() {
      holder = widget.interval;
    });

    print('New interval ${widget.interval}');
    return
        //  widget.isBusy ? CupertinoActivityIndicator() :
        Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            height: 280,
            child: WebView(
              initialUrl: '',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller = webViewController;
                _loadHtmlFromAssets();
              },
            ));
  }

  _loadHtmlFromAssets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('lang');
    if (lang == 'en') {
      lang = 'en-US';
    } else if (lang == 'zh') {
      lang = 'zh-CN';
    }
    print('INTERVAL STATEFUL ${holder}');
    var pairArray = widget.pair.split('/');
    String fileText = await rootBundle.loadString('assets/pages/index.html');
    fileText = fileText
        .replaceAll('BTC', pairArray[0])
        .replaceAll('USDT', pairArray[1])
        .replaceAll('en_US', lang)
        .replaceAll('30m', holder)
        .replaceAll('https://kanbantest.fabcoinapi.com/',
            configService.getKanbanBaseUrl())
        .replaceAll('wss://kanbantest.fabcoinapi.com/ws/',
            configService.getKanbanBaseWSUrl());

    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
