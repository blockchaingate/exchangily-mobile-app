import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
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
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:exchangilymobileapp/models/campaign/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignService {
  final log = getLogger('CampaignService');
  final client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  final String appName = 'eXchangily';
  final String appId = '5b6a8688905612106e976a69';
  final String campaignId = '1';
  Campaign? campaign;

  static const BASE_URL = baseBlockchainGateV2Url;
  static const registerUrl = BASE_URL + 'members/create';
  static const loginUrl = BASE_URL + 'members/login';
  static const kycWithTokenUrl = BASE_URL + 'kyc/create';
  static const createOrderUrl = BASE_URL + 'campaign-order/create';
  static const updateOrderUrl = BASE_URL + 'campaign-order/update';
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

  static const resetPasswordUrl = BASE_URL + 'members/requestpwdreset';

  CampaignUserData? userData;
  CampaignUserDatabaseService? campaignUserDatabaseService =
      locator<CampaignUserDatabaseService>();

/*-------------------------------------------------------------------------------------
                          Get user data from database by token
-------------------------------------------------------------------------------------*/
  Future<CampaignUserData?> getUserDataFromDatabase({String token = ''}) async {
    var loginToken =
        token == '' ? await getSavedLoginTokenFromLocalStorage() : token;
    log.w(loginToken);
    if (loginToken != '' && loginToken != null) {
      await campaignUserDatabaseService!
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

  Future<String?> getSavedLoginTokenFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginToken = prefs.getString('loginToken');
    return loginToken;
  }

  /*-------------------------------------------------------------------------------------
                                  Password Reset
-------------------------------------------------------------------------------------*/

  Future resetPassword(String email) async {
    Map<String, dynamic> body = {"appId": appId, "email": email};
    try {
      var response = await client.post(Uri.parse(resetPasswordUrl), body: body);
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
      var response = await client.post(Uri.parse(registerUrl), body: body);
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
      log.i('login url $loginUrl');
      var response = await client.post(Uri.parse(loginUrl), body: body);
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
    String loginToken = prefs.getString('loginToken')!;
    campaignOrder.toJson();
    log.w('campaignOrder ${campaignOrder.toJson()}');
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
      var response = await client.post(Uri.parse(createOrderUrl),
          body: body, headers: headers);
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

  Future updateCampaignOrder(String? id, String desc, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginToken = prefs.getString('loginToken')!;

    Map<String, dynamic> body = {
      "_id": id,
      "paymentDesc": desc,
      "status": status
    };
    Map<String, String> headers = {'x-access-token': loginToken};
    try {
      var response = await client.post(Uri.parse(updateOrderUrl),
          body: body, headers: headers);
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

  Future<List<OrderInfo>?> getOrdersById(String memberId) async {
    try {
      var response =
          await client.get(Uri.parse(listOrdersByMemberIdUrl + memberId));
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

  Future<List<TransactionHistory>?> getOrderByWalletAddress(
      String exgWalletAddress) async {
    try {
      var response = await client
          .get(Uri.parse(listOrdersByWalletAddressUrl + exgWalletAddress));

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
    prefs.setString('loginToken', userData.token!);
    await campaignUserDatabaseService!.insert(userData);
    await campaignUserDatabaseService!
        .getUserDataByToken(userData.token)
        .then((value) => log.w(value));
  }

/*-------------------------------------------------------------------------------------
                                  Get Campaign Name
-------------------------------------------------------------------------------------*/

  Future getCampaignName() async {
    try {
      var response = await client.get(Uri.parse(campaignNameUrl));
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
    String memberId = userData.id!;

    Map<String, String> headers = {'x-access-token': userData.token!};
    try {
      var response = await client.get(Uri.parse(memberReferralsUrl + memberId),
          headers: headers);
      var json = jsonDecode(response.body) as List?;
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
    Map<String, String> headers = {'x-access-token': userData.token!};
    try {
      var response = await client.get(Uri.parse(rewardsUrl), headers: headers);
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

  Future<MemberProfile?> getMemberProfile(String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response =
          await client.get(Uri.parse(memberProfileUrl), headers: headers);
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

  Future<List<CampaignReward>?> getMemberRewardByToken(String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(Uri.parse(rewardsUrl), headers: headers);
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
      var response = await client.get(Uri.parse(rewardsUrl), headers: headers);
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

  Future<List<TeamReward>?> getTeamsRewardDetailsByToken(String token) async {
    Map<String, String> headers = {'x-access-token': token};
    try {
      var response = await client.get(Uri.parse(rewardsUrl), headers: headers);

      var json = jsonDecode(response.body)['_body']['team'];
      log.i('getTeamsRewardDetailsByToken $json');
      TeamRewardList campaignTeamRewardList = TeamRewardList.fromJson(json);
      log.w(
          'getTeamsRewardDetailsByToken ${campaignTeamRewardList.rewards!.length}');
      return campaignTeamRewardList.rewards;
    } catch (err) {
      log.e('In getTeamsRewardDetailsByToken catch $err');
      return null;
    }
  }
}
