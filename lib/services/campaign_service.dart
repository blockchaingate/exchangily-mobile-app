import 'dart:convert';

import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/campaign.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
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
  final String campaignId = '1';
  Campaign campaign;

  static const BASE_URL = 'https://test.blockchaingate.com/v2/';
  static const registerUrl = BASE_URL + 'members/create';
  static const loginUrl = BASE_URL + 'members/login';
  static const kycWithTokenUrl = BASE_URL + 'kyc/create';
  static const createOrderUrl = BASE_URL + 'campaign-order/create';
  static const listOrdersByWalletAddressUrl =
      BASE_URL + 'campaign-order/wallet-orders/';
  static const listOrdersByMemberIdUrl =
      BASE_URL + 'campaign-order/member-orders/';
  static const rewardsWithTokenUrl = BASE_URL + 'coinorders/rewards';
  static const setTokenUrl = BASE_URL + 'coinorders/rewards?token=';
  static const campaignNameUrl = BASE_URL + 'campaign/1';
  static const memberReferralsUrl = BASE_URL + 'campaign-referral/referrals/';
  static const memberRewardUrl = BASE_URL + 'campaign-referral/rewards/';
  static const rewardsUrl = BASE_URL + 'campaign-order/rewards';
  static const memberProfileUrl = BASE_URL + 'campaign-order/profile';

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

  Future registerAccount(
      User user, String referralCode, String exgWalletAddress) async {
    Map<String, dynamic> body =
        user.toJson(); // Assign user data to Map type json variable
    body.addAll({
      "app": appName,
      "appId": appId,
      "referralCode": referralCode,
      "campaignId": "1",
      "walletExgAddress": exgWalletAddress
    }); // Add another key/pair value
    log.w(body);
    try {
      var response = await client.post(registerUrl, body: body);
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
      "campaignId": "1",
      "price": "0.24",
      "walletAdd": campaignOrder.walletAdd,
      "txId": campaignOrder.txId,
      "quantity": campaignOrder.quantity.toString(),
      "paymentType": campaignOrder.paymentType
    };
    // body.addAll({'campaignId': campaignId});
    log.w(body);
    Map<String, String> headers = {'x-access-token': loginToken};
    try {
      var response =
          await client.post(createOrderUrl, body: body, headers: headers);
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

  Future<List<OrderInfo>> getOrdersById(String memberId) async {
    log.e(memberId);
    try {
      var response = await client.get(listOrdersByMemberIdUrl + memberId);
      var jsonList = jsonDecode(response.body) as List;
      log.w(jsonList);
      OrderInfoList orderInfoList = OrderInfoList.fromJson(jsonList);
      log.e(orderInfoList.orders[10].dateCreated);
      return orderInfoList.orders;
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

      var jsonList = jsonDecode(response.body)
          as List; // making this a list what i was missing earlier
      log.w(jsonList);
      TransactionInfoList orderList = TransactionInfoList.fromJson(jsonList);
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
                          Get saved login token
-------------------------------------------------------------------------------------*/

  Future<String> getSavedLoginToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken');
    return loginToken;
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
    Map<String, String> headers = {'x-access-token': userData.token};
    try {
      var response = await client.get(rewardsUrl, headers: headers);
      var json = jsonDecode(response.body);
      log.w(' getRewardById $json');

      return json;
    } catch (err) {
      log.e('In getRewardById catch $err');
    }
  }

/*-------------------------------------------------------------------------------------
                                Get Member Profile By Token
-------------------------------------------------------------------------------------*/

  Future getMemberProfile(CampaignUserData userData) async {
    Map<String, String> headers = {'x-access-token': userData.token};
    try {
      var response = await client.get(memberProfileUrl, headers: headers);
      var json = jsonDecode(response.body);
      log.w('getMemberProfile $json');

      return json['_body'];
    } catch (err) {
      log.e('In getMemberProfile catch $err');
    }
  }

  /*-------------------------------------------------------------------------------------
                                  Get Member Reward By Token
-------------------------------------------------------------------------------------*/

  Future getMemberRewardByToken(String token) async {
    List<CampaignReward> campaignRewardList = [];
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(rewardsUrl, headers: headers);
      log.e('${jsonDecode(response.body)['_body']}');
      var rewardList = jsonDecode(response.body)['_body'];
      return rewardList;

      // catch type 'int' is not a subtype of type 'double' if i map it like below so for now i am going to do i manually until i find the solution
      // CampaignRewardList campaignRewardList = CampaignRewardList.fromJson(json);
      // log.e(campaignRewardList.rewards.length);
    } catch (err) {
      log.e('In getRewardByToken catch $err');
    }
  }

  /*-------------------------------------------------------------------------------------
                                  Get Teams Reward By Token
-------------------------------------------------------------------------------------*/

  Future getTeamsRewardByToken(String token) async {
    List<CampaignReward> campaignRewardList = [];
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(rewardsUrl, headers: headers);
      log.e('${jsonDecode(response.body)['_body']}');

      var teamsRewardList = jsonDecode(response.body)['_body']['team'] as List;

      // if (jsonList != null || jsonList != []) {
      //   for (int i = 0; i <= jsonList.length; i++) {
      //     CampaignReward campaignReward = new CampaignReward(
      //         level: jsonList[i]['level'],
      //         totalValue: jsonList[i]['totalValue'],
      //         totalQuantities: jsonList[i]['totalQuantities'],
      //         totalRewardQuantities: jsonList[i]['totalRewardQuantities'],
      //         totalAccounts: jsonList[i]['totalAccounts'],
      //         totalRewardNextQuantities: jsonList[i]
      //             ['totalRewardNextQuantities']);

      //     log.w(campaignReward.toJson());
      //     log.w(campaignRewardList.length);
      //     campaignRewardList.add(campaignReward);
      //   }
      //   return campaignRewardList;
      // } else {
      //   return campaignRewardList = [];
      // }
      return teamsRewardList;

      // catch type 'int' is not a subtype of type 'double' if i map it like below so for now i am going to do i manually until i find the solution
      // CampaignRewardList campaignRewardList = CampaignRewardList.fromJson(json);
      // log.e(campaignRewardList.rewards.length);
    } catch (err) {
      log.e('In getRewardByToken catch $err');
    }
  }
}