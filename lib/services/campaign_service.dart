import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/campaign.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/models/transaction_info.dart';
import 'package:exchangilymobileapp/models/campaign/order_info.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:http/http.dart' as http;
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignService {
  final log = getLogger('CampaignApi');
  final client = new http.Client();

  final String appName = 'eXchangily';
  final String appId = '5b6a8688905612106e976a69';
  final String campaignId = '5e7e68682212d41ad0a5cf07';
  Campaign campaign;

  static const BASE_URL = 'https://test.blockchaingate.com/v2/';
  static const registerAccountUrl = BASE_URL + 'members/create';
  static const loginUrl = BASE_URL + 'members/login';
  static const kycWithTokenUrl = BASE_URL + 'kyc/create';
  static const createCampaignOrderUrl = BASE_URL + 'campaign-order/create';
  static const listOrdersByWalletAddressUrl =
      BASE_URL + 'campaign-order/wallet-orders/';
  static const listOrdersByMemberIdUrl =
      BASE_URL + 'campaign-order/member-orders/';
  static const rewardsWithTokenUrl = BASE_URL + 'coinorders/rewards';
  static const setTokenUrl = BASE_URL + 'coinorders/rewards?token=';
  static const campaignNameUrl = BASE_URL + 'campaign/1';
  static const memberReferralsUrl = BASE_URL + 'campaign-referral/referrals/';
  static const memberRewardUrl = BASE_URL + 'campaign-referral/rewards/';
  CampaignUserData userData;
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();

// Get user data from database by token
  Future<CampaignUserData> getUserDataFromDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var loginToken = prefs.getString('loginToken');
    log.w(loginToken);
    if (loginToken != '' && loginToken != null) {
      await campaignUserDatabaseService
          .getUserDataByToken(loginToken)
          .then((res) async {
        if (res != null) {
          userData = res;
        }
      });
    } else {
      log.e('Token not found');
    }
    return userData;
  }

/*-------------------------------------------------------------------------------------
                          Register
-------------------------------------------------------------------------------------*/

  Future registerAccount(User user, String referralCode) async {
    Map<String, dynamic> body =
        user.toJson(); // Assign user data to Map type json variable
    body.addAll({
      "app": appName,
      "appId": appId,
      "referralCode": referralCode,
      "campaignId": "1"
    }); // Add another key/pair value
    log.w(body);
    try {
      var response = await client.post(registerAccountUrl, body: body);
      log.w(json.decode(response.body));
      return json.decode(response.body);
    } catch (err) {
      log.e(err);
    }
  }

/*-------------------------------------------------------------------------------------
                                Login
-------------------------------------------------------------------------------------*/

  Future login(User user) async {
    // You cannot add key/pair directly to user object
    Map<String, dynamic> body =
        user.toJson(); // Assign user data to Map type json variable
    body.addAll({'appId': appId}); // Add another key/pair value

    try {
      var response = await client.post(loginUrl, body: body);
      var json = jsonDecode(response.body);
      log.w(json);
      return json;
    }
    // when i use then here and return the response variable it was showing output in console for service but not in the login state
    catch (err) {
      log.e(err);
    }
  }

/*-------------------------------------------------------------------------------------
                          Buy coin - create order
-------------------------------------------------------------------------------------*/

  Future createCampaignOrder(CampaignOrder campaignOrder) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken');
//campaignOrder.toJson();
    Map<String, dynamic> body = {
      "campaignId": campaignId,
      "memberId": campaignOrder.memberId,
      "walletAdd": campaignOrder.walletAdd,
      "txId": campaignOrder.txId,
      "quantity": campaignOrder.quantity.toString(),
      "paymentType": campaignOrder.paymentType
    };
    body.addAll({'campaignId': campaignId});
    log.w(body);
    Map<String, String> headers = {'x-access-token': loginToken};
    try {
      var response = await client.post(createCampaignOrderUrl,
          body: body, headers: headers);
      log.w('createCampaignOrder try response ${response.body}');
      var json = jsonDecode(response.body);
      return json;
    } catch (err) {
      log.e('In createCampaignOrder catch $err');
    }
  }

  /*-------------------------------------------------------------------------------------
                                  Get orders by member id
-------------------------------------------------------------------------------------*/

  Future<List<OrderInfo>> getOrderById(String memberId) async {
    String url = listOrdersByMemberIdUrl + memberId;
    OrderInfo orderInfo;
    List<OrderInfo> orderInfoList = [];
    log.w(url);
    try {
      var response = await client.get(listOrdersByMemberIdUrl + memberId);
      var json = jsonDecode(response.body);
      var jsonList = json['_body'] as List;
      log.w(jsonList);
      log.e(jsonList.length);
      for (int i = 0; i <= jsonList.length; i++) {
        String quantity = jsonList[i]['quantity'].toString();
        double castedQuantity = double.parse(quantity);
        orderInfo = new OrderInfo(
            id: jsonList[i]['_id'],
            dateCreated: jsonList[i]['dateCreated'],
            txid: jsonList[i]['txId'],
            status: jsonList[i]['status'],
            quantity: castedQuantity);
        log.w(orderInfoList.length);
        orderInfoList.add(orderInfo);
        log.w(orderInfo.toJson());
      }
      return orderInfoList;
      // OrderInfoList orderInfoList = OrderInfoList.fromJson(jsonList);
      //TransactionInfoList orderList = TransactionInfoList.fromJson(json);
      // List<TransactionInfo> orderList =
      //     json.map((e) => TransactionInfo.fromJson(e)).toList();

      // return orderList.transactions;
    } catch (err) {
      log.e('In getOrderById catch $err');
      return null;
    }
  }

/*-------------------------------------------------------------------------------------
                                  Get orders by wallet address
-------------------------------------------------------------------------------------*/

  Future<List<TransactionInfo>> getOrderByWalletAddress(
      String exgWalletAddress) async {
    try {
      var response =
          await client.get(listOrdersByWalletAddressUrl + exgWalletAddress);

      var json = jsonDecode(response.body)
          as List; // making this a list what i was missing earlier
      log.w(json);
      TransactionInfoList orderList = TransactionInfoList.fromJson(json);
      // List<TransactionInfo> orderList =
      //     json.map((e) => TransactionInfo.fromJson(e)).toList();
      log.w(orderList.transactions[5].dateCreated);
      return orderList.transactions;
    } catch (err) {
      log.e('In getOrderByWalletAddress catch $err');
      return null;
    }
  }

/*-------------------------------------------------------------------------------------
                          Save user data locally
-------------------------------------------------------------------------------------*/

  Future saveCampaignUserDataLocally(CampaignUserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loginToken', userData.token);
    await campaignUserDatabaseService.insert(userData);
    await campaignUserDatabaseService
        .getUserDataByToken(userData.token)
        .then((value) => log.w(value));
  }

  /*-------------------------------------------------------------------------------------
                                  Get Campaign Name
-------------------------------------------------------------------------------------*/

  Future getCampaignName() async {
    try {
      var response = await client.get(campaignNameUrl);
      var json = jsonDecode(response.body);
      log.w(json);
      return json;
    } catch (err) {
      log.e('In getCampaignName catch $err');
    }
  }

  /*-------------------------------------------------------------------------------------
                                  Get Member Referrals By MemberID
-------------------------------------------------------------------------------------*/

  Future getReferralsById(CampaignUserData userData) async {
    String memberId = userData.id;
    log.e(memberId);
    Map<String, String> headers = {'x-access-token': userData.token};
    try {
      var response =
          await client.get(memberReferralsUrl + memberId, headers: headers);
      var json = jsonDecode(response.body) as List;
      log.w('getMemberReferrals $json');
      return json;
    } catch (err) {
      log.e('In getMemberReferrals catch $err');
    }
  }

/*-------------------------------------------------------------------------------------
                                  Get Member Reward By MemberID
-------------------------------------------------------------------------------------*/

  Future getRewardById(CampaignUserData userData) async {
    String memberId = userData.id;
    Map<String, String> headers = {'x-access-token': userData.token};
    try {
      var response =
          await client.get(memberRewardUrl + memberId, headers: headers);
      var json = jsonDecode(response.body);
      log.w(' getRewardById $json');

      return json;
    } catch (err) {
      log.e('In getRewardById catch $err');
    }
  }
}
