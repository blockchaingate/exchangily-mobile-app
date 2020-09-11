import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class BindpayViewmodel extends FutureViewModel {
  final log = getLogger('BindpayViewmodel');

  final amountController = TextEditingController();
  ApiService apiService = locator<ApiService>();
  NavigationService navigationService = locator<NavigationService>();
  String tickerName = '';
  List<String> tickerNameList = [];

  @override
  Future futureToRun() async {
    return await apiService.getTokenList();
  }

  @override
  void onData(data) {
    log.e(data);
    List<Token> tokenList = data as List<Token>;
    tokenList.forEach((token) {
      log.i('token ${token.toJson()}');
      tickerNameList.add(token.tickerName);
    });
    log.w('tickerNameList $tickerNameList');
    tickerName = tickerNameList[0];
  }

  checkPass() {}

  updateSelectedTickername(String tickerName) {
    setBusy(true);
    tickerName = tickerName;
    setBusy(false);
  }
}
