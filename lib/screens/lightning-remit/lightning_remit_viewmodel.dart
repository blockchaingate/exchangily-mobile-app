import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';

import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exchangilymobileapp/constants/api_routes.dart';

class LightningRemitViewmodel extends FutureViewModel {
  final log = getLogger('LightningRemitViewmodel');

  final amountController = TextEditingController();
  final addressController = TextEditingController();
  ApiService apiService = locator<ApiService>();
  NavigationService navigationService = locator<NavigationService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  SharedService sharedService = locator<SharedService>();
  DialogService dialogService = locator<DialogService>();
  LocalStorageService storageService = locator<LocalStorageService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  final coinService = locator<CoinService>();
  WalletService walletService = locator<WalletService>();
  String tickerName = '';
  BuildContext context;
  double quantity = 0.0;
  List<Map<String, dynamic>> coins = [];
  GlobalKey globalKey = GlobalKey();
  ScrollController scrollController;
  bool isExchangeBalanceEmpty = false;
  String barcodeRes = '';
  String barcodeRes2 = '';
  var walletBalancesBody;
  bool isShowBottomSheet = false;
  List<ExchangeBalanceModel> exchangeBalances = [];

  List<TransactionHistory> transactionHistory = [];

  String fabAddress = '';

/*----------------------------------------------------------------------
                    Default Future to Run
----------------------------------------------------------------------*/
  @override
  Future futureToRun() async {
    return await apiService.getAssetsBalance('');

    //await walletDataBaseService.getAll();
    //apiService.getTokenList();
  }

/*----------------------------------------------------------------------
                          INIT
----------------------------------------------------------------------*/

  init() async {
    sharedService.context = context;
    fabAddress =
        await walletService.getAddressFromCoreWalletDatabaseByTickerName('FAB');
  }

/*----------------------------------------------------------------------
                  After Future Data is ready
----------------------------------------------------------------------*/
  @override
  void onData(data) async {
    setBusyForObject(exchangeBalances, true);
    setBusy(true);
    if (data == null) return;
    exchangeBalances = data;
    for (var element in exchangeBalances) {
      debugPrint(element.toJson().toString());
      if (element.ticker.isEmpty) {
        await coinService
            .getSingleTokenData('', coinType: element.coinType)
            .then((token) {
          //storageService.tokenList.forEach((newToken){
          debugPrint(token.toJson().toString());
          // var json = jsonDecode(newToken);
          // Token token = Token.fromJson(json);
          // if (token.tokenType == element.coinType){ debugPrint(token.tickerName);
          if (token == null) {
            element.ticker = element.coinType.toString();
          }
          element.ticker = token.coinName; //}
          setBusy(false);
        });
//element.ticker =tradeService.setTickerNameByType(element.coinType);
        debugPrint('exchanageBalanceModel tickerName ${element.ticker}');
      }
    }
    setBusyForObject(exchangeBalances, false);

    setBusyForObject(tickerName, true);
    if (exchangeBalances != null || exchangeBalances.isNotEmpty) {
      tickerName = exchangeBalances[0].ticker;
      quantity = exchangeBalances[0].unlockedAmount;
    }
    setBusyForObject(tickerName, false);
    log.i('onData :tickerName $tickerName');
    setBusy(false);
  }

  // get all LightningRemit transactions

  getLightningRemitTransactionHistory() async {
    setBusy(true);
    transactionHistory = [];

    await apiService.getLightningRemitHistoryEvents(fabAddress).then((res) {
      res.forEach((tx) {
        transactionHistory.add(tx);
      });
      log.w('LightningRemi txs ${transactionHistory.length}');
      transactionHistory.sort(
          (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    });
    setBusy(false);
  }

  // launch url
  openExplorer(String txId) async {
    String exchangilyExplorerUrl = ExchangilyExplorerUrl + txId;
    log.i(
        'LightningRemi open explorer - explorer url - $exchangilyExplorerUrl');
    if (await canLaunch(exchangilyExplorerUrl)) {
      await launch(exchangilyExplorerUrl);
    }
  }

/*----------------------------------------------------------------------
                    Pay order
----------------------------------------------------------------------*/
  Future payOrder() async {}

/*----------------------------------------------------------------------
                    Change bottom sheet hide/show status
----------------------------------------------------------------------*/
  changeBottomSheetStatus() {
    setBusy(true);
    isShowBottomSheet = !isShowBottomSheet;
    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Show bottom sheet for coin list
----------------------------------------------------------------------*/
  coinListBottomSheet(BuildContext context1) {
    if (isShowBottomSheet) {
      debugPrint('Bottom Sheet already visible');

      navigationService.goBack();
    } else {
      showBottomSheet(
        context: context1,
        builder: (context1) => Container(
          width: double.infinity,
          height: 140,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: grey.withAlpha(300),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            // boxShadow: [
            //   BoxShadow(
            //       blurRadius: 3, color: Colors.grey[600], spreadRadius: 2)
            // ]
          ),
          child: ListView.separated(
              separatorBuilder: (context, _) => UIHelper.divider,
              itemCount: exchangeBalances.length,
              itemBuilder: (BuildContext context, int index) {
                //  mainAxisSize: MainAxisSize.max,
                //mainAxisAlignment: MainAxisAlignment.center,
                // children: [

                return Container(
                  decoration: BoxDecoration(
                    // color: grey.withAlpha(300),
                    borderRadius: index == 0
                        ? const BorderRadius.vertical(top: Radius.circular(10))
                        : const BorderRadius.all(Radius.zero),
                    // boxShadow: [
                    //   BoxShadow(
                    //       blurRadius: 3, color: Colors.grey[600], spreadRadius: 2)
                    // ]
                    color: tickerName == exchangeBalances[index].ticker
                        ? primaryColor
                        : Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      //  Platform.isIOS
                      updateSelectedTickernameIOS(
                          index, exchangeBalances[index].unlockedAmount);
                      // : updateSelectedTickername(coins[index]['tickerName'],
                      //     coins[index]['quantity'].toDouble());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(exchangeBalances[index].ticker,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline4),
                          UIHelper.horizontalSpaceSmall,
                          Text(
                              exchangeBalances[index].unlockedAmount.toString(),
                              style: Theme.of(context).textTheme.headline4),
                          const Divider(
                            color: Colors.white,
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }

              // TextField(
              //   decoration: InputDecoration.collapsed(
              //     hintText: 'Enter your reference number',
              //   ),
              // )
              //   ]
              ),
        ),
      );
    }
    changeBottomSheetStatus();
  }

/*----------------------------------------------------------------------
                    onBackButtonPressed
----------------------------------------------------------------------*/
  onBackButtonPressed() async {
    await sharedService.onBackButtonPressed('/dashboard');
  }
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------
                                    Barcode Scan
--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  void scanBarcode() async {
    try {
      setBusy(true);
      String barcode = '';
      storageService.isCameraOpen = true;
      barcode = await BarcodeScanner.scan().then((value) => value.rawContent);
      addressController.text = barcode;
      setBusy(false);
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_NOT_GRANTED") {
        setBusy(true);
        sharedService.alertDialog(
            '', AppLocalizations.of(context).userAccessDenied,
            isWarning: false);
        // receiverWalletAddressTextController.text =
        //     AppLocalizations.of(context).userAccessDenied;
      } else {
        // setBusy(true);
        sharedService.alertDialog('', AppLocalizations.of(context).unknownError,
            isWarning: false);
      }
    } on FormatException {
      sharedService.alertDialog('', AppLocalizations.of(context).scanCancelled,
          isWarning: false);
    } catch (e) {
      sharedService.alertDialog('', AppLocalizations.of(context).unknownError,
          isWarning: false);
    }

    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Update Selected Tickername
----------------------------------------------------------------------*/
  updateSelectedTickername(
    String name,
  ) {
    setBusy(true);
    tickerName = name;

    debugPrint('tickerName $tickerName');
    setBusy(false);
    // if (isShowBottomSheet) navigationService.goBack();
    // changeBottomSheetStatus();
  }

  updateSelectedTickernameIOS(int index, double updatedQuantity) {
    setBusy(true);
    debugPrint(
        'INDEX ${index + 1} ---- coins length ${exchangeBalances.length}');
    if (index + 1 <= exchangeBalances.length) {
      tickerName = exchangeBalances.elementAt(index).ticker;
    }
    quantity = updatedQuantity;
    debugPrint('IOS tickerName $tickerName --- quantity $quantity');
    setBusy(false);
    if (isShowBottomSheet) navigationService.goBack();
    changeBottomSheetStatus();
  }

/*----------------------------------------------------------------------
                    Refresh Balance
----------------------------------------------------------------------*/
  refreshBalance() async {
    setBusyForObject(exchangeBalances, true);
    await apiService.getSingleCoinExchangeBalance(tickerName).then((res) {
      exchangeBalances.firstWhere((element) {
        if (element.ticker == tickerName) {
          element.unlockedAmount = res.unlockedAmount;
        }
        log.w('udpated balance check ${element.unlockedAmount}');
        return true;
      });
    });
    setBusyForObject(exchangeBalances, false);
  }

/*----------------------------------------------------------------------
                      Show barcode
----------------------------------------------------------------------*/

  showBarcode() async {
    setBusy(true);

    String kbAddress = walletService.toKbPaymentAddress(fabAddress);
    debugPrint('KBADDRESS $kbAddress');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Center(
                    child: Text(AppLocalizations.of(context).receiveAddress)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        UIHelper.horizontalSpaceSmall,
                        Expanded(
                          child: Text(
                              // add here cupertino widget to check in these small widgets first then the entire app
                              kbAddress,
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.headline6),
                        ),
                        CupertinoButton(
                            child: const Icon(
                              FontAwesomeIcons.copy,
                              //  CupertinoIcons.,
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
                        margin: const EdgeInsets.only(top: 10.0),
                        width: 250,
                        height: 250,
                        child: Center(
                          child: RepaintBoundary(
                            key: globalKey,
                            child: QrImage(
                                backgroundColor: white,
                                data: kbAddress,
                                version: QrVersions.auto,
                                size: 300,
                                gapless: true,
                                errorStateBuilder: (context, err) {
                                  return Center(
                                    child: Text(
                                        AppLocalizations.of(context)
                                            .somethingWentWrong,
                                        textAlign: TextAlign.center),
                                  );
                                }),
                          ),
                        )),
                  ],
                ),
                actions: <Widget>[
                  // QR image share button
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CupertinoButton(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context).share,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(color: primaryColor),
                            )),
                            onPressed: () {
                              String receiveFileName =
                                  'Lightning-remit-kanban-receive-address.png';
                              getApplicationDocumentsDirectory().then((dir) {
                                String filePath =
                                    "${dir.path}/$receiveFileName";
                                File file = File(filePath);
                                Future.delayed(const Duration(milliseconds: 30),
                                    () {
                                  sharedService
                                      .capturePng(globalKey: globalKey)
                                      .then((byteData) {
                                    file.writeAsBytes(byteData).then((onFile) {
                                      Share.shareFiles([onFile.path],
                                          text: kbAddress);
                                    });
                                  });
                                });
                              });
                            }),
                        CupertinoButton(
                          padding: const EdgeInsets.only(left: 5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          child: Text(
                            AppLocalizations.of(context).close,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            // Android Alert Dialog
            : Center(
                child: AlertDialog(
                  alignment: Alignment.center,
                  buttonPadding: const EdgeInsets.all(0),
                  titlePadding: const EdgeInsets.symmetric(vertical: 0),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  elevation: 5,
                  backgroundColor: walletCardColor.withOpacity(0.85),
                  title: Container(
                    padding: const EdgeInsets.all(10.0),
                    color: secondaryColor.withOpacity(0.5),
                    child: Center(
                        child:
                            Text(AppLocalizations.of(context).receiveAddress)),
                  ),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.bold),
                  contentTextStyle: const TextStyle(color: grey),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                              icon: const Icon(
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
                          margin: const EdgeInsets.only(top: 10.0),
                          width: 250,
                          height: 250,
                          child: Center(
                            child: RepaintBoundary(
                              key: globalKey,
                              child: QrImage(
                                  backgroundColor: white,
                                  data: kbAddress,
                                  version: QrVersions.auto,
                                  size: 250,
                                  gapless: true,
                                  errorStateBuilder: (context, err) {
                                    return Center(
                                      child: Text(
                                          AppLocalizations.of(context)
                                              .somethingWentWrong,
                                          textAlign: TextAlign.center),
                                    );
                                  }),
                            ),
                          )),
                      UIHelper.verticalSpaceSmall,
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: RaisedButton(
                            child: Text(AppLocalizations.of(context).share,
                                style: Theme.of(context).textTheme.headline6),
                            onPressed: () {
                              String receiveFileName =
                                  'Lightning-remit-kanban-receive-address.png';
                              getApplicationDocumentsDirectory().then((dir) {
                                String filePath =
                                    "${dir.path}/$receiveFileName";
                                File file = File(filePath);

                                Future.delayed(const Duration(milliseconds: 30),
                                    () {
                                  sharedService
                                      .capturePng(globalKey: globalKey)
                                      .then((byteData) {
                                    file.writeAsBytes(byteData).then((onFile) {
                                      Share.shareFiles([onFile.path],
                                          text: kbAddress);
                                    });
                                  });
                                });
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: OutlineButton(
                          borderSide: const BorderSide(color: primaryColor),
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
                      ),
                      UIHelper.verticalSpaceSmall,
                    ],
                  ),
                ),
              );
      },
    );

    setBusy(false);
  }

/*----------------------------------------------------------------------
                            Transfer
----------------------------------------------------------------------*/

  transfer() async {
    setBusy(true);
    if (walletService.isValidKbAddress(addressController.text)) {
      if (amountController.text == '') {
        sharedService.alertDialog(AppLocalizations.of(context).validationError,
            AppLocalizations.of(context).amountMissing);
        setBusy(false);
        return;
      }
      await refreshBalance();
      ExchangeBalanceModel _selectedExchangeBal = exchangeBalances
          .firstWhere((element) => element.ticker == tickerName);
      // int coinType = getCoinTypeIdByName(tickerName);
      debugPrint(_selectedExchangeBal.coinType.toString());
      double amount = double.parse(amountController.text);
      double selectedCoinBalance = _selectedExchangeBal.unlockedAmount;
      if (selectedCoinBalance <= 0.0 || amount > selectedCoinBalance) {
        sharedService.alertDialog(AppLocalizations.of(context).validationError,
            AppLocalizations.of(context).invalidAmount);
        setBusy(false);
        log.e('No exchange balance ${_selectedExchangeBal.unlockedAmount}');
        return;
      }
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
              .sendCoin(seed, _selectedExchangeBal.coinType,
                  addressController.text, double.parse(amountController.text))
              .then((res) {
            log.w('RES $res');
            if (res['transactionHash'] != null ||
                res['transactionHash'] != '') {
              showSimpleNotification(
                  Text(AppLocalizations.of(context).sendTransactionComplete),
                  position: NotificationPosition.bottom,
                  background: primaryColor);
              String date = DateTime.now().toString();
              TransactionHistory transactionHistory = TransactionHistory(
                  id: null,
                  tickerName: tickerName,
                  address: '',
                  amount: 0.0,
                  date: date.toString(),
                  tickerChainTxId: res['transactionHash'],
                  tickerChainTxStatus: '',
                  quantity: amount,
                  tag: 'bindpay');
              walletService.insertTransactionInDatabase(transactionHistory);
              Future.delayed(const Duration(seconds: 3), () async {
                await refreshBalance();
                log.i('balance updated');
              });
            } else {
              sharedService.alertDialog(
                  AppLocalizations.of(context).transanctionFailed,
                  AppLocalizations.of(context).pleaseTryAgainLater);
            }
          });
        } else if (res.returnedText == 'Closed') {
          log.e('Dialog Closed By User');
          setBusy(false);
        } else {
          log.e('Wrong pass');
          sharedService.showInfoFlushbar(
              AppLocalizations.of(context).notice,
              AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
              Icons.cancel,
              red,
              context);
          setBusy(false);
        }
      }).catchError((error) {
        log.e(error);
        setBusy(false);
        return false;
      });
    } else {
      sharedService.alertDialog(AppLocalizations.of(context).validationError,
          AppLocalizations.of(context).pleaseCorrectTheFormatOfReceiveAddress);
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

  copyAddress(String txId) {
    Clipboard.setData(ClipboardData(text: txId));
    showSimpleNotification(
        Center(
            child: Text(AppLocalizations.of(context).copiedSuccessfully,
                style: Theme.of(context).textTheme.headline5)),
        position: NotificationPosition.bottom,
        background: primaryColor);
  }
}
