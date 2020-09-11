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
  final addressController = TextEditingController();
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
    tickerNameList = [];
    List<Token> tokenList = data as List<Token>;
    tokenList.forEach((token) {
      log.i('token ${token.toJson()}');
      tickerNameList.add(token.tickerName);
    });
    updateSelectedTickername('EXG');

    log.w('tickerNameList $tickerNameList ---- tickerName $tickerName');
  }

  checkPass() {}

  updateSelectedTickername(String name) {
    setBusy(true);
    tickerName = name;
    print('tickerName $tickerName');
    setBusy(false);
  }
}
