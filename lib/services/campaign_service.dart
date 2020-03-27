import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:http/http.dart' as http;
import 'package:exchangilymobileapp/models/campaign/user.dart';

class CampaignService {
  final log = getLogger('API');
  final client = new http.Client();

  final String appName = 'eXchangily';
  final String appId = '5b6a8688905612106e976a69';

  static const BASE_URL = 'https://test.blockchaingate.com/v2/';
  static const createAccountUrl = BASE_URL + 'members/create';
  static const loginUrl = BASE_URL + 'members/login';
  static const kycWithTokenUrl = BASE_URL + 'kyc/create';
  static const buyCoinWithTokenUrl = BASE_URL + 'coinorders/create';
  static const listOrdersWithTokenUrl = BASE_URL + 'coinorders';
  static const rewardsWithTokenUrl = BASE_URL + 'coinorders/rewards';
  static const setTokenUrl = BASE_URL + 'coinorders/rewards?token=';

  Future<User> createAccount(String email, String password) {
    var body = {};
  }

  Future login(User user) async {
    // You cannot add key/pair directly to user object
    Map<String, dynamic> body =
        user.toJson(); // Assign user data to Map type json variable
    body.addAll({'appId': appId}); // Add another key/pair value
    log.w(body);
    var response = await client.post(loginUrl, body: body);
    log.w(response.body);
    return json.decode(response.body);
    // when i use then here and return the response variable it was showing output in console for service but not in the login state
  }
}
