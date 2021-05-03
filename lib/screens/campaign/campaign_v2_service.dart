import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/campaign/7star/star_order_model.dart';
import 'package:exchangilymobileapp/models/campaign/campaign.dart';
import 'package:exchangilymobileapp/models/campaign/campaign_order.dart';
import 'package:exchangilymobileapp/models/campaign/member_profile.dart';
import 'package:exchangilymobileapp/models/campaign/reward.dart';
import 'package:exchangilymobileapp/models/campaign/team_reward.dart';
import 'package:exchangilymobileapp/models/campaign/user_data.dart';
import 'package:exchangilymobileapp/models/campaign/order_info.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/campaign_user_database_service.dart';
import 'package:http/http.dart' as http;
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignV2Service {
  final log = getLogger('CampaignService');
  final client = new http.Client();

  final String appName = 'eXchangily';
  final String appId = '5b6a8688905612106e976a69';
  final String campaignId = '1';
  Campaign campaign;

  static final BASE_URL = baseBlockchainGateV2Url;
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
  Future<CampaignUserData> getUserDataFromDatabase({String token = ''}) async {
    var loginToken =
        token == '' ? await getSavedLoginTokenFromLocalStorage() : token;
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
                          Get saved login token
-------------------------------------------------------------------------------------*/

  Future<String> getSavedLoginTokenFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken');
    return loginToken;
  }

/*-------------------------------------------------------------------------------------
                          Buy coin - create order
-------------------------------------------------------------------------------------*/

  Future createStarCampaignV2Order(StarOrder starOrder) async {
    log.w('createStarCampaignV2Order ${starOrder.toJson()}');
    Map<String, dynamic> body = {
      "campaignId": starOrder.campaignId,
      "walletAdd": starOrder.walletAdd,
      "amount": starOrder.amount.toString(),
      "currency": starOrder.currency,
      "referral": starOrder.referral
    };
    // Map<String, String> headers = {'x-access-token': loginToken};
    try {
      var response = await client.post(createOrderUrl, body: body);
      var json = jsonDecode(response.body)['_body'];
      log.w('createStarCampaignV2Order try response $json');
      return json;
    } catch (err) {
      log.e('In createStarCampaignV2Order catch $err');
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

  Future<List<TransactionHistory>> getOrderByWalletAddress(
      String exgWalletAddress) async {
    try {
      var response =
          await client.get(listOrdersByWalletAddressUrl + exgWalletAddress);

      var jsonList = jsonDecode(response.body)
          as List; // making this a list what i was missing earlier
      log.w('getOrderByWalletAddress $jsonList');
      TransactionHistoryList orderList =
          TransactionHistoryList.fromJson(jsonList);
      return orderList.transactions;
    } catch (err) {
      log.e('In getOrderByWalletAddress catch $err');
      return null;
    }
  }

/*-------------------------------------------------------------------------------------
                          Save user data locally
-------------------------------------------------------------------------------------*/

  Future saveCampaignUserDataInLocalDatabase(CampaignUserData userData) async {
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

  Future<MemberProfile> getMemberProfile(String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(memberProfileUrl, headers: headers);
      var json = jsonDecode(response.body)['_body'];

      MemberProfile memberProfile = MemberProfile.fromJson(json);
      log.i('getMemberProfile -- ${memberProfile.toJson()}');
      return memberProfile;
    } catch (err) {
      log.e('In getMemberProfile catch $err');
      return null;
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
      log.w('getTotalTeamsRewardByToken ${jsonDecode(response.body)['_body']}');
      var teamsRewardList = jsonDecode(response.body)['_body'];
      return teamsRewardList;
    } catch (err) {
      log.e('In getTotalTeamsRewardByToken catch $err');
    }
  }

/*-------------------------------------------------------------------------------------
                                  Get Teams Details Reward By Token
-------------------------------------------------------------------------------------*/

  Future<List<TeamReward>> getTeamsRewardDetailsByToken(String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(rewardsUrl, headers: headers);

      var json = jsonDecode(response.body)['_body']['team'];
      log.i('getTeamsRewardDetailsByToken $json');
      TeamRewardList campaignTeamRewardList = TeamRewardList.fromJson(json);
      log.w(
          'getTeamsRewardDetailsByToken ${campaignTeamRewardList.rewards.length}');
      return campaignTeamRewardList.rewards;
    } catch (err) {
      log.e('In getTeamsRewardDetailsByToken catch $err');
      return null;
    }
  }
}
