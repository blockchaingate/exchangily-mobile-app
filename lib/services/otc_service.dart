import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_endpoints.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;

class OtcService {
  final log = getLogger('OtcService');
  final client = new http.Client();

/*----------------------------------------------------------------------
                          KYC
----------------------------------------------------------------------*/
  Future kycCreate(Map body) async {
    log.i('kyc body $body');
    try {
      var response = await client.post(otcKycCreate, body: body);
      var json = jsonDecode(response.body);
      log.w('kycCreate $json');
      return json;
    } catch (err) {
      log.e('kycCreate $err');
    }
  }

/*----------------------------------------------------------------------
                          Get Orders
----------------------------------------------------------------------*/

}
