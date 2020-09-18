import 'dart:io';
import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
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
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
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
  BuildContext context;
  double quantity = 0.0;
  List<Map<String, dynamic>> coins = [];
  GlobalKey globalKey = new GlobalKey();

/*----------------------------------------------------------------------
                          INIT
----------------------------------------------------------------------*/

  init() {
    sharedService.context = context;
  }

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
    List<WalletInfo> tokenList = data as List<WalletInfo>;
    tokenList.forEach((wallet) {
      if (wallet.inExchange != 0.0)
        coins.add(
            {"tickerName": wallet.tickerName, "quantity": wallet.inExchange});
    });
    coins != null ? tickerName = coins[0]['tickerName'] : tickerName = '';
    print(' coins $coins');
    //  updateSelectedTickername('EXG');
  }

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
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            elevation: 5,
            backgroundColor: walletCardColor.withOpacity(0.85),
            title: Container(
              padding: EdgeInsets.all(10.0),
              color: secondaryColor.withOpacity(0.5),
              child: Center(
                  child:
                      Text('${AppLocalizations.of(context).recieveAddress}')),
            ),
            titleTextStyle: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.bold),
            contentTextStyle: TextStyle(color: grey),
            content: Column(
              children: [
                UIHelper.verticalSpaceLarge,
                Row(
                  children: [
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                      child: Center(
                        child: Text(
                            // add here cupertino widget to check in these small widgets first then the entire app
                            kbAddress,
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.content_copy,
                          color: primaryColor,
                          size: 16,
                        ),
                        onPressed: () {
                          sharedService.copyAddress(context, kbAddress)();
                        })
                  ],
                ),
                // UIHelper.verticalSpaceLarge,
                Container(
                    margin: EdgeInsets.only(top: 10.0),
                    width: 250,
                    height: 250,
                    child: Center(
                      child: Container(
                        child: RepaintBoundary(
                          key: globalKey,
                          child: QrImage(
                              backgroundColor: white,
                              data: kbAddress,
                              version: QrVersions.auto,
                              size: 300,
                              gapless: true,
                              errorStateBuilder: (context, err) {
                                return Container(
                                  child: Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .somethingWentWrong,
                                        textAlign: TextAlign.center),
                                  ),
                                );
                              }),
                        ),
                      ),
                    )),
              ],
            ),
            actions: <Widget>[
              // QR image share button

              Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                    child: Text(AppLocalizations.of(context).saveAndShareQrCode,
                        style: Theme.of(context).textTheme.headline6),
                    onPressed: () {
                      String receiveFileName =
                          'bindpay-kanban-receive-address.png';
                      getApplicationDocumentsDirectory().then((dir) {
                        String filePath = "${dir.path}/$receiveFileName";
                        File file = File(filePath);

                        Future.delayed(new Duration(milliseconds: 30), () {
                          sharedService
                              .capturePng(globalKey: globalKey)
                              .then((byteData) {
                            file.writeAsBytes(byteData).then((onFile) {
                              Share.shareFile(onFile, text: kbAddress);
                            });
                          });
                        });
                      });
                    }),
              ),
              OutlineButton(
                borderSide: BorderSide(color: primaryColor),
                color: primaryColor,
                textColor: Colors.white,
                child: Text(
                  AppLocalizations.of(context).close,
                  style: Theme.of(context).textTheme.headline6,
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

/*----------------------------------------------------------------------
                            Transfer
----------------------------------------------------------------------*/

  transfer() async {
    setBusy(true);
    print(walletService.isValidKbAddress(addressController.text));
    if (walletService.isValidKbAddress(addressController.text)) {
      if (amountController.text == '') {
        sharedService.alertDialog(AppLocalizations.of(context).validationError,
            AppLocalizations.of(context).amountMissing);
        setBusy(false);
        return;
      }
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
              Content Paste Button in receiver address textfield
----------------------------------------------------------------------*/

  Future contentPaste() async {
    await Clipboard.getData('text/plain')
        .then((res) => addressController.text = res.text);
  }
}
