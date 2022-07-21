import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';

class ERC20Util {
  final log = getLogger('MaticUtils');

  var client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();

  Future postBnbTx(String txHex) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_sendRawTransaction",
      "params": [txHex],
      "id": 1
    };
    var errMsg = '';
    String txHash;
    try {
      var response = await client.post(bnbBaseUrl,
          headers: {"responseType": "text"}, body: jsonEncode(body));
      var json = jsonDecode(response.body);
      log.w('json $json');
      txHash = json["result"];

      if (txHash.contains('txerError')) {
        errMsg = txHash;
        txHash = '';
      }
    } catch (e) {
      log.e('erc20tils - postbnb Func: Catch $e');
      errMsg = 'connection error';
    }
    return {'txHash': txHash, 'errMsg': errMsg};
  }

  Future getNonce({String smartContractAddress, String baseUrl}) async {
    var body = {
      "jsonrpc": "2.0",
      "method": "eth_getTransactionCount",
      "params": [smartContractAddress, "latest"],
      "id": 1
    };
    int nonce = 0;
    try {
      var response = await client.post(baseUrl, body: jsonEncode(body));
      log.w('getnonce func- response: ${response.body}');
      var json = jsonDecode(response.body);
      log.w('json $json');
      nonce = int.parse(json['result']);
    } catch (e) {
      log.e('getNonce func- Catch $e');
    }
    log.w('res nonce $nonce');
    return nonce;
  }
}
