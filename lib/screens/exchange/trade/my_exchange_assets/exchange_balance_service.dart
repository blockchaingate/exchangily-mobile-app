import 'dart:convert';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/utils/custom_http_util.dart';
import 'package:stacked/stacked.dart';
import 'package:observable_ish/value/value.dart';

import 'locker/locker_model.dart';

class ExchangeBalanceService with ReactiveServiceMixin {
  final log = getLogger('ExchangeBalanceService');

  final client = CustomHttpUtil.createLetsEncryptUpdatedCertClient();
  ConfigService? configService = locator<ConfigService>();

  List<LockerModel> _lockers = [];
  List<LockerModel> get lockers => _lockers;

  final RxValue<bool> _refreshLockerBalances = RxValue<bool>(false);
  bool get refreshLockerBalances => _refreshLockerBalances.value;

  ExchangeBalanceService() {
    listenToReactiveValues([_refreshLockerBalances]);
  }

  void setRefreshLockerBalances(bool value) {
    log.i('setRefreshLockerBalances value ${value}');
    _refreshLockerBalances.value = value;
    log.w('setRefreshLockerBalances ${_refreshLockerBalances.value}');
  }

  Future<int?> getLockerCount(
    String exgAddress,
  ) async {
    String url = lockerApiUrl + exgAddress + totalCountTextApiRoute;
    int? referralCount = 0;
    log.i('getLockerCount url $url');
    try {
      var response = await client.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);

        // log.w('getChildrenByAddress json $json');
        if (json.isNotEmpty) {
          referralCount = json['_body'];
          log.i('getLockerCount count $referralCount');
          return referralCount;
        } else {
          return 0;
        }
      } else {
        log.e("getLockerCount error: ${response.body}");
        return 0;
      }
    } catch (err) {
      log.e('In getLockerCount catch $err');
      return 0;
    }
  }

  Future<List<LockerModel>?> getLockers(String exgAddress,
      {int pageSize = 10, int pageNumber = 0}) async {
    if (pageNumber != 0) {
      pageNumber = pageNumber - 1;
    }
    String url = lockerApiUrl + exgAddress + '/$pageSize/$pageNumber';
    log.i('getLockerInfo url $url');
    try {
      var response = await client.get(Uri.parse(url));
      log.w('response ${response.body}');
      var json = jsonDecode(response.body);

      var parsedTokenList = json as List;

      LockerModelList lockerModelList =
          LockerModelList.fromJson(parsedTokenList);
      log.w(
          'getLockerInfo func: lockerModelList length ${lockerModelList.lockers!.length}');
      setRefreshLockerBalances(true);
      return lockerModelList.lockers;
    } catch (err) {
      log.e('getLockerInfo CATCH $err');
      throw Exception(err);
    }
  }
}
