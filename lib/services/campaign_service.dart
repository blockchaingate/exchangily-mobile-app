import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/campaign.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:http/http.dart' as http;
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignService {
  final log = getLogger('API');
  final client = new http.Client();

  final String appName = 'eXchangily';
  final String appId = '5b6a8688905612106e976a69';
  final String campaignId = '5e7e68682212d41ad0a5cf07';
  Campaign campaign;

  static const BASE_URL = 'https://test.blockchaingate.com/v2/';
  static const createAccountUrl = BASE_URL + 'members/create';
  static const loginUrl = BASE_URL + 'members/login';
  static const kycWithTokenUrl = BASE_URL + 'kyc/create';
  static const createCampaignOrderUrl = BASE_URL + 'campaign-order/create';
  static const listOrdersByWalletAddressUrl =
      BASE_URL + 'campaign-order/wallet-orders/';
  static const rewardsWithTokenUrl = BASE_URL + 'coinorders/rewards';
  static const setTokenUrl = BASE_URL + 'coinorders/rewards?token=';

  Future<User> registerAccount(User user) {}

  // Login

  Future login(User user) async {
    // You cannot add key/pair directly to user object
    Map<String, dynamic> body =
        user.toJson(); // Assign user data to Map type json variable
    body.addAll({'appId': appId}); // Add another key/pair value
    log.w(body);
    var response = await client.post(loginUrl, body: body);
    log.w(json.decode(response.body));
    return json.decode(response.body);
    // when i use then here and return the response variable it was showing output in console for service but not in the login state
  }

  // Buy coin - create order

  Future createCampaignOrder(CampaignOrder campaignOrder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken');
    Map<String, dynamic> body = campaignOrder.toJson();
    //  {
    //   "campaignId": "5e7e68682212d41ad0a5cf07",
    //   "memberId": "5e7bddcebc0b7861c2d1e2d8",
    //   "walletAdd": "0xa2a3720c00c2872397e6d98f41305066cbf0f8b3",
    //   "txId":
    //       "0x41d9b291469c7d9046e8154b04b3d6e1e76c910bba9fce6acf73298d79984cfd",
    //   "amount": "15",
    //   "paymentType": "USDT",
    //   "status": ""
    // };

    body.addAll({'campaignId': campaignId});
    log.w(body);
    Map<String, String> headers = {'x-access-token': loginToken};
    log.w(headers);
    await client
        .post(createCampaignOrderUrl, body: body, headers: headers)
        .then((value) => log.w(value.body))
        .catchError((onError) => log.e('In buy coin catch $onError'));

    //return json.decode(response.body);
  }

  // Get orders by wallet address

  Future getOrderByWalletAddress(String exgWalletAddress) async {
    var response =
        await client.get(listOrdersByWalletAddressUrl + exgWalletAddress);
    var json = jsonDecode(response.body);
    log.w(json);
    return json;
  }
}
