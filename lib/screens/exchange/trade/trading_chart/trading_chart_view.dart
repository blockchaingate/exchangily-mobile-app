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

import 'package:exchangilymobileapp/screens/exchange/trade/trading_chart/trading_chart_viewmodel.dart';
import 'package:exchangilymobileapp/shared/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// realtime: https://jsfiddle.net/TradingView/yozeu6k1/

class LoadHTMLFileToWEbView extends StatefulWidget {
  final String pair;
  // final String interval;
  //final bool isBusy;
  LoadHTMLFileToWEbView(
    this.pair,
    //   this.interval,
//  this.isBusy
  );
  @override
  _LoadHTMLFileToWEbViewState createState() => _LoadHTMLFileToWEbViewState();
}

class _LoadHTMLFileToWEbViewState extends State<LoadHTMLFileToWEbView> {
  // String interval = '1m';
//  WebViewController _controller;
  //ConfigService configService = locator<ConfigService>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme.bodyText1;
    // isBusy ${widget.isBusy} --
    // setState(() {
    //   holder = widget.interval;

    // });

    return ViewModelBuilder.reactive(
      // createNewModelOnInsert: true,
      viewModelBuilder: () => TradingChartViewModel(),
      onModelReady: (model) {
        //  model.context = context;

        model.init();
      },
      builder: (context, model, _) => Column(
        children: [
          model.isTradingChartModelBusy
              ? Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  height: 280,
                  child: Center(child: CupertinoActivityIndicator()))
              : Container(
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  height: 280,
                  child: WebView(
                    initialUrl: '',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      model.webViewController = webViewController;
                      // model.isBusy && model.isIntervalUpdated
                      //     ? _loadHtmlFromAssets(model)
                      //     :

                      _loadHtmlFromAssets(model);
                    },
                  ),
                ),
          // Text(model.tradingChartInterval),
          // Text(model.isTradingChartModelBusy.toString()),
          SizedBox(
              height: 50,
              child: Center(
                child: ListView.builder(
                    itemCount: model.intervalMap.length,
                    itemExtent: 65,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      String key = model.intervalMap.keys.elementAt(index);
                      return FlatButton(
                        textColor:
                            model.intervalMap[key] == model.tradingChartInterval
                                ? primaryColor
                                : white,
                        child: Text(key, style: model.fontTheme),
                        onPressed: () =>
                            model.updateChartInterval(model.intervalMap[key]),
                      );
                    }),
              )),
        ],
      ),
    );
  }

  _loadHtmlFromAssets(TradingChartViewModel model) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lang = prefs.getString('lang');
    if (lang == 'en') {
      lang = 'en-US';
    } else if (lang == 'zh') {
      lang = 'zh-CN';
    }
    var pairArray = widget.pair.split('/');
    String fileText = await rootBundle.loadString('assets/pages/index.html');
    fileText = fileText
        .replaceAll('BTC', pairArray[0])
        .replaceAll('USDT', pairArray[1])
        .replaceAll('en_US', lang)
        .replaceAll('30m', model.tradingChartInterval)
        .replaceAll('https://kanbantest.fabcoinapi.com/',
            model.configService.getKanbanBaseUrl())
        .replaceAll('wss://kanbantest.fabcoinapi.com/ws/',
            model.configService.getKanbanBaseWSUrl());

    model.webViewController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
