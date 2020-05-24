/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'dart:async';
import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/trade/price.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:exchangilymobileapp/utils/decoder.dart';
import 'package:stacked/stacked.dart';

class MarketsViewModal extends StreamViewModel<dynamic> {
  final log = getLogger('MarketsViewModal');
  bool isError = false;
  String errorMessage = '';
  List<Price> coinPriceDetails = [];
  @override
  Stream<dynamic> get stream =>
      locator<TradeService>().getAllCoinPriceByWebSocket();

  @override
  void onData(data) {
    for (var i = 0; i < coinPriceDetails.length; i++) {
      print('$i ${coinPriceDetails[i].price}');
    }
  }

  @override
  transformData(data) {
    // coinPriceDetails = Decoder.fromJsonArray(data);
    // setBusy(true);
    try {
      List<dynamic> jsonDynamicList = jsonDecode(data) as List;
      log.i(jsonDynamicList.length);
      PriceList priceList = PriceList.fromJson(jsonDynamicList);
      print('price list ${priceList.prices.length}');

      coinPriceDetails = priceList.prices;
      coinPriceDetails.forEach((element) {
        log.w("Price ${element.toJson()}");
      });
      isError = false;
      // setBusy(false);
    } catch (err) {
      log.e('Catch error $err');
      print('Cancelling Stream Subsciption');
      streamSubscription.cancel();
      isError = true;
      error != null
          ? errorMessage = error.message
          : errorMessage = err.toString();
      //  setBusy(false);
      // throw Exception('$err');
    }
  }

  @override
  void onError(error) {
    log.e('In onError $error');
  }

  @override
  void onCancel() {
    log.e('Stream closed');
  }
}
