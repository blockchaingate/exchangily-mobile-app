import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_endpoints.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtcService {
  final log = getLogger('OtcService');
  final client = new http.Client();

/*----------------------------------------------------------------------
                          KYC
----------------------------------------------------------------------*/
  Future kycCreate(Map<String, dynamic> body, String loginToken) async {
    log.w('otcKycCreateUrl $otcKycCreateUrl');

    Map<String, String> headers = {'x-access-token': loginToken};
    try {
      var response =
          await client.post(otcKycCreateUrl, body: body, headers: headers);
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
