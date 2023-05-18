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
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'dart:convert';

mixin KanbanService {
  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  final log = getLogger('KanbanService');
  ConfigService? configService = locator<ConfigService>();

/*----------------------------------------------------------------------
                    Get scar/exchangily address
----------------------------------------------------------------------*/
  getScarAddress() async {
    var url =
        configService!.getKanbanBaseUrl()! + 'exchangily/getExchangeAddress';
    var response = await client.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    return json;
  }

/*----------------------------------------------------------------------
                    Get Decimal configuration for the coins
----------------------------------------------------------------------*/

  Future getDepositTransactionStatus(String transactionId) async {
    var url = configService!.getKanbanBaseUrl()! + 'checkstatus/' + transactionId;
    try {
      var response = await client.get(Uri.parse(url));
      var json = jsonDecode(response.body);
      log.w(' getDepositTransactionStatus $json');
      return json;
    } catch (err) {
      log.e('In getDepositTransactionStatus catch $err');
    }
  }
}
