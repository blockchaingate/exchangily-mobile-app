import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BindpayViewmodel extends FutureViewModel {
  final log = getLogger('BindpayViewmodel');

  final amountController = TextEditingController();
  final addressController = TextEditingController();
  ApiService apiService = locator<ApiService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  WalletService walletService = locator<WalletService>();
  String tickerName = '';
  List<String> tickerNameList = [];
  BuildContext context;
/*----------------------------------------------------------------------
                    Default Future to Run
----------------------------------------------------------------------*/
  @override
  Future futureToRun() async {
    return await apiService.getTokenList();
  }

/*----------------------------------------------------------------------
                    After Future Data is ready
----------------------------------------------------------------------*/
  @override
  void onData(data) {
    tickerNameList = [];
    List<Token> tokenList = data as List<Token>;
    tokenList.forEach((token) {
      // log.i('token ${token.toJson()}');
      tickerNameList.add(token.tickerName);
    });
    updateSelectedTickername('EXG');
  }

/*----------------------------------------------------------------------
                    Check password
----------------------------------------------------------------------*/

  checkPass() {
    log.i('check Pass');
  }

  updateSelectedTickername(String name) {
    setBusy(true);
    tickerName = name;
    print('tickerName $tickerName');
    setBusy(false);
  }

/*----------------------------------------------------------------------
              Show dialog popup for receive address and barcode
----------------------------------------------------------------------*/
  showBarcode() {
    walletDataBaseService.getBytickerName(tickerName).then((coin) {
      String kbAddress = walletService.toKbPaymentAddress(coin.address);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor: walletCardColor.withOpacity(0.85),
            title: Text('${AppLocalizations.of(context).recieveAddress}'),
            titleTextStyle: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
            contentTextStyle: TextStyle(color: grey),
            content: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        // add here cupertino widget to check in these small widgets first then the entire app
                        kbAddress,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          sharedService.copyAddress(context, kbAddress)();
                        })
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  AppLocalizations.of(context).close,
                  style: TextStyle(color: white, fontSize: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
    });
  }
}
