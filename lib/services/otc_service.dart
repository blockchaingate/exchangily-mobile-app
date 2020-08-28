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
  Future kycCreate(Map<String, dynamic> body) async {
    log.w('otcKycCreateUrl $otcKycCreateUrl');
    var jsonBody = jsonEncode(body);
    log.i('kyc body $jsonBody');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken');
    log.w('login token $loginToken');

    Map<String, String> headers = {
      'x-access-token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlODdiODY2Yjc1NTFkMzNlNjE3MGNmYSIsImVtYWlsIjoiYmFycnkxMDBAZXhnLmNvbSIsImlhdCI6MTU5Nzg2NDI3OSwiZXhwIjoxNTk3OTUwNjc5LCJpc3MiOiJmYS5iaXoiLCJzdWIiOiI1ZTg3Yjg2NmI3NTUxZDMzZTYxNzBjZmEifQ.l1_Y9WTORizJavt_DyTRJe7UIPhDjXqJ4c_NzHdBZqU'
    };
    try {
      var response =
          await client.post(otcKycCreateUrl, body: jsonBody, headers: headers);
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
