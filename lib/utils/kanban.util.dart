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

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getScarAddress() async {
  ConfigService configService = locator<ConfigService>();

  var url = configService.getKanbanBaseUrl() +
      KanbanApiRoute +
      GetScarAddressApiRoute;
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<String> getCoinPoolAddress() async {
  ConfigService configService = locator<ConfigService>();
  var url = configService.getKanbanBaseUrl() + 'exchangily/getCoinPoolAddress';
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<String> getExchangilyAddress() async {
  ConfigService configService = locator<ConfigService>();
  var url = configService.getKanbanBaseUrl() + 'exchangily/getExchangeAddress';
  print('URL getExchangilyAddress $url');
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<double> getGas(String address) async {
  ConfigService configService = locator<ConfigService>();
  var url = configService.getKanbanBaseUrl() +
      KanbanApiRoute +
      GetBalanceApiRoute +
      address;
  var client = new http.Client();
  var response = await client.get(url);
  var json = jsonDecode(response.body);
  var fab = json["balance"]["FAB"];
  return double.parse(fab);
}

Future<int> getNonce(String address) async {
  ConfigService configService = locator<ConfigService>();
  var url = configService.getKanbanBaseUrl() +
      KanbanApiRoute +
      GetTransactionCountApiRoute +
      address;
  print('URL getNonce $url');
  var client = new http.Client();
  var response = await client.get(url);
  var json = jsonDecode(response.body);
  print('getNonce json $json');
  return json["transactionCount"];
}

Future<Map<String, dynamic>> submitDeposit(
    String rawTransaction, String rawKanbanTransaction) async {
  ConfigService configService = locator<ConfigService>();
  var url = configService.getKanbanBaseUrl() + SubmitDepositApiRoute;
  print('submitDeposit url $url');
  var body = {
    'rawTransaction': rawTransaction,
    'rawKanbanTransaction': rawKanbanTransaction
  };
  print('body $body');

  try {
    var client = new http.Client();
    var response = await client.post(url, body: body);
    print("Kanban_util submitDeposit response body:");
    print(response.body.toString());
    Map<String, dynamic> res = jsonDecode(response.body);
    return res;
  } catch (err) {
    print('Catch submitDeposit in kanban util $err');
    throw Exception(err);
  }
}

Future getKanbanErrDeposit(String address) async {
  ConfigService configService = locator<ConfigService>();
  var url = configService.getKanbanBaseUrl() + DepositerrApiRoute + address;
  print('kanbanUtil getKanbanErrDeposit $url');
  try {
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    // print('Kanban.util-getKanbanErrDeposit $json');
    return json;
  } catch (err) {
    print(
        'Catch getKanbanErrDeposit in kanban util $err'); // Error thrown here will go to onError in them view model
    throw Exception(err);
  }
}

Future<Map<String, dynamic>> submitReDeposit(
    String rawKanbanTransaction) async {
  ConfigService configService = locator<ConfigService>();
  var url = configService.getKanbanBaseUrl() + ResubmitDepositApiRoute;
  var data = {'rawKanbanTransaction': rawKanbanTransaction};
  print('URL submitReDeposit $url/$data');

  try {
    var client = new http.Client();
    var response = await client.post(url, body: data);
    //print('response from sendKanbanRawTransaction=');
    // print(response.body);
    Map<String, dynamic> res = jsonDecode(response.body);
    return res;
  } catch (e) {
    //return e;
    return {'success': false, 'data': 'error'};
  }
}

Future<Map<String, dynamic>> sendKanbanRawTransaction(
    String rawKanbanTransaction) async {
  ConfigService configService = locator<ConfigService>();
  var url =
      configService.getKanbanBaseUrl() + KanbanApiRoute + SendRawTxApiRoute;
  print('URL sendKanbanRawTransaction $url');
  var data = {'signedTransactionData': rawKanbanTransaction};

  try {
    var client = new http.Client();
    var response = await client.post(url, body: data);
    print('response from sendKanbanRawTransaction=');
    print(response.body);
    if (response.body.contains('TS crosschain withdraw verification failed'))
      return {'success': false, 'data': response.body};
    Map<String, dynamic> res = jsonDecode(response.body);
    return res;
  } catch (e) {
    //return e;
    return {'success': false, 'data': 'error $e'};
  }
}
