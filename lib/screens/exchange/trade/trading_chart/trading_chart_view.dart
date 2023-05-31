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
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:exchangilymobileapp/shared/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

// realtime: https://jsfiddle.net/TradingView/yozeu6k1/

class LoadHTMLFileToWEbView extends StatefulWidget {
  final String pair;

  const LoadHTMLFileToWEbView(
    this.pair,
  );
  @override
  LoadHTMLFileToWEbViewState createState() => LoadHTMLFileToWEbViewState();
}

class LoadHTMLFileToWEbViewState extends State<LoadHTMLFileToWEbView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => TradingChartViewModel(),
      onViewModelReady: (dynamic model) {
        model.init();
      },
      builder: (context, TradingChartViewModel model, _) => Column(
        children: [
          model.isTradingChartModelBusy
              ? Container(
                  color: grey,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(0),
                  height: 280,
                  child: const Center(child: CupertinoActivityIndicator()))
              : Container(
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.all(0),
                  height: 280,
                  child: WebView(
                    initialUrl: '',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      model.webViewController = webViewController;
                      _loadHtmlFromAssets(model);
                    },
                  ),
                ),
          SizedBox(
              height: 50,
              child: Center(
                child: ListView.builder(
                    itemCount: model.intervalMap.length,
                    itemExtent: 65,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      String key = model.intervalMap.keys.elementAt(index);
                      return TextButton(
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 0)),
                        onPressed: () =>
                            model.updateChartInterval(model.intervalMap[key]),
                        child: Text(key,
                            style: model.intervalMap[key] ==
                                    model.tradingChartInterval
                                ? model.fontTheme.copyWith(color: primaryColor)
                                : model.fontTheme.copyWith(
                                    color: Theme.of(context).hintColor)),
                      );
                    }),
              )),
        ],
      ),
    );
  }

  _loadHtmlFromAssets(TradingChartViewModel model) async {
    final userSettingsDatabaseService = locator<UserSettingsDatabaseService>();
    var lang = await userSettingsDatabaseService.getLanguage();
    // var lang = model.storageService.language;
    lang ??= 'en';
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
        .replaceAll('30m', model.tradingChartInterval!)
        .replaceAll('https://kanbantest.fabcoinapi.com/',
            model.configService!.getKanbanBaseUrl()!)
        .replaceAll('wss://kanbantest.fabcoinapi.com/ws/',
            model.configService!.getKanbanBaseWSUrl()!);

    model.webViewController.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
