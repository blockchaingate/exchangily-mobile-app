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

import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../environments/environment.dart';

mixin KanbanService {
  var client = new http.Client();
  final log = getLogger('KanbanService');

  getScarAddress() async {
    var url =
        environment['endpoints']['kanban'] + 'exchangily/getExchangeAddress';
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }

  // Get Decimal configuration for the coins
  Future getDepositTransactionStatus(String transactionId) async {
    var url =
        environment['endpoints']['kanban'] + 'checkstatus/' + transactionId;
    try {
      var response = await client.get(url);
      var json = jsonDecode(response.body);
      log.w(' getDepositTransactionStatus $json');
      return json;
    } catch (err) {
      log.e('In getDepositTransactionStatus catch $err');
    }
  }
}
