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
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';

import 'custom_http_util.dart';

class KanbanUtils {
  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  Future<String> getScarAddress() async {
    ConfigService configService = locator<ConfigService>();

    var url = configService.getKanbanBaseUrl()! +
        kanbanApiRoute +
        getScarAddressApiRoute;

    var response = await client.get(Uri.parse(url));
    return response.body;
  }

  Future<String> getCoinPoolAddress() async {
    ConfigService configService = locator<ConfigService>();
    var url =
        configService.getKanbanBaseUrl()! + 'exchangily/getCoinPoolAddress';

    var response = await client.get(Uri.parse(url));
    return response.body;
  }

  Future<String> getExchangilyAddress() async {
    ConfigService configService = locator<ConfigService>();
    var url =
        configService.getKanbanBaseUrl()! + 'exchangily/getExchangeAddress';
    debugPrint('URL getExchangilyAddress $url');

    var response = await client.get(Uri.parse(url));
    return response.body;
  }

  Future<double> getGas(String address) async {
    ConfigService configService = locator<ConfigService>();
    var url = configService.getKanbanBaseUrl()! +
        kanbanApiRoute +
        getBalanceApiRoute +
        address;

    var response = await client.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var fab = json["balance"]["FAB"];
    return double.parse(fab);
  }

  Future<int?> getNonce(String address) async {
    ConfigService configService = locator<ConfigService>();
    var url = configService.getKanbanBaseUrl()! +
        kanbanApiRoute +
        getTransactionCountApiRoute +
        address;
    debugPrint('URL getNonce $url');

    var response = await client.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    debugPrint('getNonce json $json');
    return json["transactionCount"];
  }

  Future<Map<String, dynamic>?> submitDeposit(
      String? rawTransaction, String rawKanbanTransaction) async {
    ConfigService configService = locator<ConfigService>();
    var url = configService.getKanbanBaseUrl()! + submitDepositApiRoute;
    debugPrint('submitDeposit url $url');
    final sharedService = locator<SharedService>();
    var versionInfo = await sharedService.getLocalAppVersion();
    debugPrint('getAppVersion $versionInfo');
    String versionName = versionInfo['name']!;
    String buildNumber = versionInfo['buildNumber']!;
    String fullVersion = versionName + '+' + buildNumber;
    debugPrint('fullVersion $fullVersion');
    var body = {
      'app': Constants.appName,
      'version': fullVersion,
      'rawTransaction': rawTransaction,
      'rawKanbanTransaction': rawKanbanTransaction
    };
    debugPrint('body $body');

    try {
      var response = await client.post(Uri.parse(url), body: body);
      debugPrint("Kanban_util submitDeposit response body:");
      debugPrint(response.body.toString());
      Map<String, dynamic>? res = jsonDecode(response.body);
      return res;
    } catch (err) {
      debugPrint('Catch submitDeposit in kanban util $err');
      throw Exception(err);
    }
  }

  Future getKanbanErrDeposit(String address) async {
    ConfigService configService = locator<ConfigService>();
    var url = configService.getKanbanBaseUrl()! + depositerrApiRoute + address;
    debugPrint('kanbanUtil getKanbanErrDeposit $url');
    try {
      var response = await client.get(Uri.parse(url));
      var json = jsonDecode(response.body);
      // debugPrint('Kanban.util-getKanbanErrDeposit $json');
      return json;
    } catch (err) {
      debugPrint(
          'Catch getKanbanErrDeposit in kanban util $err'); // Error thrown here will go to onError in them view model
      throw Exception(err);
    }
  }

  Future<Map<String, dynamic>?> submitReDeposit(
      String rawKanbanTransaction) async {
    ConfigService configService = locator<ConfigService>();
    var url = configService.getKanbanBaseUrl()! + resubmitDepositApiRoute;

    final sharedService = locator<SharedService>();
    var versionInfo = await sharedService.getLocalAppVersion();
    debugPrint('getAppVersion $versionInfo');
    String versionName = versionInfo['name']!;
    String buildNumber = versionInfo['buildNumber']!;
    String fullVersion = versionName + '+' + buildNumber;
    debugPrint('fullVersion $fullVersion');
    var body = {
      'app': Constants.appName,
      'version': fullVersion,
      'rawKanbanTransaction': rawKanbanTransaction
    };
    debugPrint('URL submitReDeposit $url -- body $body');

    try {
      var response = await client.post(Uri.parse(url), body: body);
      //debugPrint('response from sendKanbanRawTransaction=');
      // debugPrint(response.body);
      Map<String, dynamic>? res = jsonDecode(response.body);
      return res;
    } catch (e) {
      //return e;
      return {'success': false, 'data': 'error'};
    }
  }

  Future<Map<String, dynamic>?> sendRawKanbanTransaction(
      String? rawKanbanTransaction) async {
    ConfigService configService = locator<ConfigService>();
    var url =
        configService.getKanbanBaseUrl()! + kanbanApiRoute + sendRawTxApiRoute;
    debugPrint('URL sendKanbanRawTransaction $url');

    final sharedService = locator<SharedService>();
    var versionInfo = await sharedService.getLocalAppVersion();
    String versionName = versionInfo['name']!;
    String buildNumber = versionInfo['buildNumber']!;
    String fullVersion = versionName + '+' + buildNumber;
    debugPrint('fullVersion $fullVersion');
    var body = {
      'app': 'exchangily',
      'version': fullVersion,
      'signedTransactionData': rawKanbanTransaction
    };

    debugPrint('body $body');
    try {
      var response = await client.post(Uri.parse(url), body: body);
      debugPrint('response from sendKanbanRawTransaction=');
      debugPrint(response.body.toString());
      if (response.body
          .contains('TS crosschain withdraw verification failed')) {
        return {'success': false, 'data': response.body};
      }
      Map<String, dynamic>? res = jsonDecode(response.body);
      return res;
    } catch (e) {
      //return e;
      return {'success': false, 'data': 'error $e'};
    }
  }
}
