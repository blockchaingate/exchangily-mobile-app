import 'dart:convert';

import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/campaign.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:exchangilymobileapp/models/campaign/team_reward.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/models/transaction_info.dart';
import 'package:exchangilymobileapp/models/campaign/order_info.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:http/http.dart' as http;
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignService {
  final log = getLogger('CampaignService');
  final client = new http.Client();

  final String appName = 'eXchangily';
  final String appId = '5b6a8688905612106e976a69';
  final String campaignId = '1';
  Campaign campaign;

  static final BASE_URL = isProduction
      ? EnvironmentConfig.CAMPAIGN_PROD_URL
      : EnvironmentConfig.CAMPAIGN_TEST_URL;
  static final registerUrl = BASE_URL + 'members/create';
  static final loginUrl = BASE_URL + 'members/login';
  static final kycWithTokenUrl = BASE_URL + 'kyc/create';
  static final createOrderUrl = BASE_URL + 'campaign-order/create';
  static final updateOrderUrl = BASE_URL + 'campaign-order/update';
  static final listOrdersByWalletAddressUrl =
      BASE_URL + 'campaign-order/wallet-orders/';
  static final listOrdersByMemberIdUrl =
      BASE_URL + 'campaign-order/member-orders/';
  static final rewardsWithTokenUrl = BASE_URL + 'coinorders/rewards';
  static final setTokenUrl = BASE_URL + 'coinorders/rewards?token=';
  static final campaignNameUrl = BASE_URL + 'campaign/1';
  static final memberReferralsUrl = BASE_URL + 'campaign-referral/referrals/';
  static final memberRewardUrl = BASE_URL + 'campaign-referral/rewards/';
  static final rewardsUrl = BASE_URL + 'campaign-order/rewards';
  static final memberProfileUrl = BASE_URL + 'campaign-order/profile';

  static final resetPasswordUrl = BASE_URL + 'members/requestpwdreset';

  CampaignUserData userData;
  CampaignUserDatabaseService campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();

/*-------------------------------------------------------------------------------------
                          Get user data from database by token
-------------------------------------------------------------------------------------*/
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
                                  Password Reset
-------------------------------------------------------------------------------------*/

  Future resetPassword(String email) async {
    Map<String, dynamic> body = {"appId": appId, "email": email};
    try {
      var response = await client.post(resetPasswordUrl, body: body);
      var json = jsonDecode(response.body);
      log.w('resetPasswordUrl $json');
      return json;
    } catch (err) {
      log.e('resetPasswordUrl $err');
    }
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
    try {
      var response = await client.post(registerUrl, body: body);
      var json = jsonDecode(response.body);
      log.w('registerAccount $json');
      return json;
    } catch (err) {
      log.e('registerAccount $err');
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
      log.e(loginUrl);
      var response = await client.post(loginUrl, body: body);
      var json = jsonDecode(response.body);
      log.w('login $json');
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
    campaignOrder.toJson();
    Map<String, dynamic> body = {
      "campaignId": "1",
      "price": campaignOrder.price.toString(),
      "walletAdd": campaignOrder.walletAdd,
      "txId": campaignOrder.txId,
      "quantity": campaignOrder.quantity.toString(),
      "paymentType": campaignOrder.paymentType
    };
    Map<String, String> headers = {'x-access-token': loginToken};
    try {
      var response =
          await client.post(createOrderUrl, body: body, headers: headers);
      var json = jsonDecode(response.body)['_body'];
      log.w('createCampaignOrder try response $json');
      return json;
    } catch (err) {
      log.e('In createCampaignOrder catch $err');
    }
  }

/*-------------------------------------------------------------------------------------
                          Update Order
-------------------------------------------------------------------------------------*/

  Future updateCampaignOrder(String id, String desc, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken');

    Map<String, dynamic> body = {
      "_id": id,
      "paymentDesc": desc,
      "status": status
    };
    Map<String, String> headers = {'x-access-token': loginToken};
    try {
      var response =
          await client.post(updateOrderUrl, body: body, headers: headers);
      var json = jsonDecode(response.body)['_body'];
      log.w('updateCampaignOrder try response $json');
      return json;
    } catch (err) {
      log.e('In updateCampaignOrder catch $err');
    }
  }
  /*-------------------------------------------------------------------------------------
                                  Get orders by member id
-------------------------------------------------------------------------------------*/

  Future<List<OrderInfo>> getOrdersById(String memberId) async {
    try {
      var response = await client.get(listOrdersByMemberIdUrl + memberId);
      var jsonList = jsonDecode(response.body) as List;
      log.w('In getOrderByMemberId $jsonList');
      OrderInfoList orderInfoList = OrderInfoList.fromJson(jsonList);
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
      log.w('getOrderByWalletAddress $jsonList');
      TransactionInfoList orderList = TransactionInfoList.fromJson(jsonList);
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
      log.w('getCampaignName $json');
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
      log.w('getRewardById $json');

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
      var json = jsonDecode(response.body)['_body'];
      log.w('getMemberProfile $json');

      return json;
    } catch (err) {
      log.e('In getMemberProfile catch $err');
    }
  }

  /*-------------------------------------------------------------------------------------
                                  Get Member Reward By Token
-------------------------------------------------------------------------------------*/

  Future<List<CampaignReward>> getMemberRewardByToken(String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(rewardsUrl, headers: headers);
      log.w('getMemberRewardByToken ${jsonDecode(response.body)['_body']}');
      var json = jsonDecode(response.body)['_body']['personal'];
      CampaignRewardList campaignRewardList = CampaignRewardList.fromJson(json);
      log.e('getMemberRewardByToken ${campaignRewardList.rewards.length}');
      return campaignRewardList.rewards;
    } catch (err) {
      log.e('In getRewardByToken catch $err');
      return null;
    }
  }

/*-------------------------------------------------------------------------------------
                                  Get Total Teams Reward By Token
-------------------------------------------------------------------------------------*/

  Future getTotalTeamsRewardByToken(String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(rewardsUrl, headers: headers);
      log.e('getTotalTeamsRewardByToken ${jsonDecode(response.body)['_body']}');
      var teamsRewardList = jsonDecode(response.body)['_body'];
      return teamsRewardList;
    } catch (err) {
      log.e('In getTotalTeamsRewardByToken catch $err');
    }
  }

/*-------------------------------------------------------------------------------------
                                  Get Teams Details Reward By Token
-------------------------------------------------------------------------------------*/

  Future<List<CampaignTeamReward>> getTeamsRewardDetailsByToken(
      String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(rewardsUrl, headers: headers);
      log.e(
          'getTeamsRewardDetailsByToken ${jsonDecode(response.body)['_body']['team']}');
      var json = jsonDecode(response.body)['_body']['team'];
      CampaignTeamRewardList campaignTeamRewardList =
          CampaignTeamRewardList.fromJson(json);
      log.w(
          'getTeamsRewardDetailsByToken ${campaignTeamRewardList.rewards.length}');
      return campaignTeamRewardList.rewards;
    } catch (err) {
      log.e('In getTeamsRewardDetailsByToken catch $err');
      return null;
    }
  }
}
