import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/environments/coins.dart' as coinList;
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/token.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class BindpayViewmodel extends FutureViewModel {
  final log = getLogger('BindpayViewmodel');

  final amountController = TextEditingController();
  final addressController = TextEditingController();
  ApiService apiService = locator<ApiService>();
  NavigationService navigationService = locator<NavigationService>();
  SharedService sharedService = locator<SharedService>();
  DialogService dialogService = locator<DialogService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  WalletService walletService = locator<WalletService>();
  String tickerName = '';
  List<String> tickerNameList = [];
  BuildContext context;
  double quantity = 0.0;
  List<Map<String, dynamic>> coins = [];
/*----------------------------------------------------------------------
                    Default Future to Run
----------------------------------------------------------------------*/
  @override
  Future futureToRun() async {
    return await walletDataBaseService.getAll();
    //apiService.getTokenList();
  }

/*----------------------------------------------------------------------
                    After Future Data is ready
----------------------------------------------------------------------*/
  @override
  void onData(data) {
    tickerNameList = [];
    List<WalletInfo> tokenList = data as List<WalletInfo>;
    tokenList.forEach((wallet) {
      // log.i('token ${token.toJson()}');
      coins.add(
          {"tickerName": wallet.tickerName, "quantity": wallet.inExchange});
      tickerNameList.add(wallet.tickerName);
    });
    print(coins);
    updateSelectedTickername('EXG');
  }

/*----------------------------------------------------------------------
                    Check password
----------------------------------------------------------------------*/

/*----------------------------------------------------------------------
                    Update Selected Tickername
----------------------------------------------------------------------*/
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
    setBusy(true);
    walletDataBaseService.getBytickerName('FAB').then((coin) {
      String kbAddress = walletService.toKbPaymentAddress(coin.address);
      print('KBADDRESS $kbAddress');
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
                        icon: Icon(Icons.copyright),
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
    setBusy(false);
  }

  transfer() async {
    setBusy(true);
    if (addressController.text.startsWith('o')) {
      int coinType = walletService.getCoinTypeIdByName(tickerName);
      print(coinType);
      await dialogService
          .showDialog(
              title: AppLocalizations.of(context).enterPassword,
              description: AppLocalizations.of(context)
                  .dialogManagerTypeSamePasswordNote,
              buttonTitle: AppLocalizations.of(context).confirm)
          .then((res) async {
        if (res.confirmed) {
          String mnemonic = res.returnedText;
          Uint8List seed = walletService.generateSeed(mnemonic);
          await walletService
              .sendCoin(seed, coinType, addressController.text,
                  double.parse(amountController.text))
              .then((res) {
            print('RES $res');
          });
        } else if (res.returnedText == 'Closed') {
          log.e('Dialog Closed By User');
          setBusy(false);
        } else {
          log.e('Wrong pass');
          setBusy(false);
          // return error =
          //     AppLocalizations.of(context).pleaseProvideTheCorrectPassword;
        }
      }).catchError((error) {
        log.e(error);
        setBusy(false);
        return false;
      });
    } else {
      sharedService.alertDialog(
          'Validation Error', 'Please enter the correct receive address');
      setBusy(false);
    }
    setBusy(false);
  }
/*----------------------------------------------------------------------
                    Content Paste
----------------------------------------------------------------------*/

  Future contentPaste() async {
    await Clipboard.getData('text/plain')
        .then((res) => addressController.text = res.text);
    // sharedService.
  }
}
