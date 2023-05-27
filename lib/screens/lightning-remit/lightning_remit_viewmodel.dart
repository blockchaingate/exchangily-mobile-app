import 'dart:io';

import 'package:exchangilymobileapp/constants/api_routes.dart';
// import 'package:barcode_scan/barcode_scan.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/screens/exchange/exchange_balance_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
import 'package:exchangilymobileapp/services/db/token_info_database_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pagination_widget/pagination_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'lightning_remit_transfer_history_model.dart';

class LightningRemitViewmodel extends FutureViewModel {
  final log = getLogger('LightningRemitViewmodel');

  final amountController = TextEditingController();
  final addressController = TextEditingController();
  ApiService apiService = locator<ApiService>();
  NavigationService navigationService = locator<NavigationService>();
  TokenInfoDatabaseService tokenListDatabaseService =
      locator<TokenInfoDatabaseService>();
  SharedService sharedService = locator<SharedService>();
  DialogService dialogService = locator<DialogService>();
  LocalStorageService storageService = locator<LocalStorageService>();
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  final CoinService coinService = locator<CoinService>();
  WalletService walletService = locator<WalletService>();
  String? tickerName = '';
  BuildContext? context;
  double? quantity = 0.0;
  List<Map<String, dynamic>> coins = [];
  GlobalKey globalKey = GlobalKey();
  ScrollController? scrollController;
  bool isExchangeBalanceEmpty = false;
  String barcodeRes = '';
  String barcodeRes2 = '';
  var walletBalancesBody;
  bool isShowBottomSheet = false;
  List<ExchangeBalanceModel> exchangeBalances = [];
  PaginationModel paginationModel = PaginationModel();
  LightningRemitHistoryModel transferHistory = LightningRemitHistoryModel();
  ConfigService configService = locator<ConfigService>();
  String fabAddress = '';

/*----------------------------------------------------------------------
                    Default Future to Run
----------------------------------------------------------------------*/
  @override
  Future futureToRun() async {
    return await apiService.getAssetsBalance("");
  }

/*----------------------------------------------------------------------
                          INIT
----------------------------------------------------------------------*/

  init() async {
    sharedService.context = context;
    await setFabAddress();
  }

  setFabAddress() async {
    fabAddress = (await walletService
        .getAddressFromCoreWalletDatabaseByTickerName('FAB'))!;
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
      log.w('onData ${element.toJson().toString()}');
      try {
        if (element.ticker!.isEmpty) {
          await coinService
              .getSingleTokenData('', coinType: element.coinType)
              .then((token) {
            //storageService.tokenList.forEach((newToken){

            // var json = jsonDecode(newToken);
            // Token token = Token.fromJson(json);
            // if (token.tokenType == element.coinType){ debugPrint(token.tickerName);
            if (token == null) {
              element.ticker = element.coinType.toString();
            }
            element.ticker = token!.tickerName; //}
          });
//element.ticker =tradeService.setTickerNameByType(element.coinType);
          debugPrint('exchanageBalanceModel tickerName ${element.ticker}');
        }
      } catch (err) {
        log.e('catch while getting ticker for ${element.coinType}');
      }
    }
    setBusyForObject(exchangeBalances, false);

    setBusyForObject(tickerName, true);
    if (exchangeBalances.isNotEmpty) {
      tickerName = exchangeBalances[0].ticker;
      quantity = exchangeBalances[0].unlockedAmount;
    }
    setBusyForObject(tickerName, false);
    log.i('onData :tickerName $tickerName');
    setBusy(false);
  }

  getPaginationData(int pageNumber) async {
    setBusy(true);
    paginationModel.pageNumber = pageNumber;
    await geTransactionstHistory();
    setBusy(false);
  }

  // get all LightningRemit transactions

  geTransactionstHistory() async {
    setBusy(true);
    transferHistory.history = [];
    await setFabAddress();
    String url =
        '${configService.getKanbanBaseUrl()}v2/$lightningRemitTxHHistoryApiRoute';
    await apiService
        .getLightningRemitHistoryEvents(url, fabAddress,
            pageNumber: paginationModel.pageNumber,
            pageSize: paginationModel.pageSize)
        .then((th) {
      transferHistory = th;
    });
    paginationModel.setTotalPages(transferHistory.totalCount);
    log.w('LightningRemit count ${transferHistory.totalCount}');
    transferHistory.history.sort((a, b) => DateTime.parse(b.date.toString())
        .compareTo(DateTime.parse(a.date.toString())));

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
          height: 200,
          // margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          Text(exchangeBalances[index].ticker!,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
                          UIHelper.horizontalSpaceSmall,
                          Text(
                              exchangeBalances[index].unlockedAmount.toString(),
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
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
      barcode =
          "await BarcodeScanner.scan().then((value) => value.rawContent);";
      addressController.text = barcode;
      setBusy(false);
    } on PlatformException catch (e) {
      if (e.code == "PERMISSION_NOT_GRANTED") {
        setBusy(true);
        sharedService.alertDialog(
            '', FlutterI18n.translate(context!, "userAccessDenied"),
            isWarning: false);
        // receiverWalletAddressTextController.text =
        //     AppLocalizations.of(context).userAccessDenied;
      } else {
        // setBusy(true);
        sharedService.alertDialog(
            '', FlutterI18n.translate(context!, "unknownError"),
            isWarning: false);
      }
    } on FormatException {
      sharedService.alertDialog(
          '', FlutterI18n.translate(context!, "scanCancelled"),
          isWarning: false);
    } catch (e) {
      sharedService.alertDialog(
          '', FlutterI18n.translate(context!, "unknownError"),
          isWarning: false);
    }

    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Update Selected Tickername
----------------------------------------------------------------------*/
  updateSelectedTickername(
    String? name,
  ) {
    setBusy(true);
    tickerName = name;

    debugPrint('tickerName $tickerName');
    setBusy(false);
    // if (isShowBottomSheet) navigationService.goBack();
    // changeBottomSheetStatus();
  }

  updateSelectedTickernameIOS(int index, double? updatedQuantity) {
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
    await apiService.getSingleCoinExchangeBalance(tickerName!).then((res) {
      exchangeBalances.firstWhere((element) {
        if (element.ticker == tickerName) {
          element.unlockedAmount = res!.unlockedAmount;
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
      context: context!,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Center(
                    child:
                        Text(FlutterI18n.translate(context, "receiveAddress"))),
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
                              style: Theme.of(context).textTheme.titleLarge),
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
                                        FlutterI18n.translate(
                                            context, "somethingWentWrong"),
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
                              FlutterI18n.translate(context, "share"),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
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
                                    file.writeAsBytes(byteData!).then((onFile) {
                                      Share.share(onFile.path,
                                          subject: kbAddress);
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
                            FlutterI18n.translate(context, "close"),
                            style: Theme.of(context).textTheme.headlineSmall,
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
                        child: Text(
                            FlutterI18n.translate(context, "receiveAddress"))),
                  ),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .headlineMedium!
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
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(
                                Icons.content_copy,
                                color: primaryColor,
                                size: 16,
                              ),
                              onPressed: () {
                                sharedService.copyAddress(context, kbAddress);
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
                                          FlutterI18n.translate(
                                              context, "somethingWentWrong"),
                                          textAlign: TextAlign.center),
                                    );
                                  }),
                            ),
                          )),
                      UIHelper.verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: outlinedButtonStyles1.copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.all(primaryColor)),
                              child: Text(
                                  FlutterI18n.translate(context, "share"),
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              onPressed: () {
                                String receiveFileName =
                                    'Lightning-remit-kanban-receive-address.png';
                                getApplicationDocumentsDirectory().then((dir) {
                                  String filePath =
                                      "${dir.path}/$receiveFileName";
                                  File file = File(filePath);

                                  Future.delayed(
                                      const Duration(milliseconds: 30), () {
                                    sharedService
                                        .capturePng(globalKey: globalKey)
                                        .then((byteData) {
                                      file
                                          .writeAsBytes(byteData!)
                                          .then((onFile) {
                                        Share.share(onFile.path,
                                            subject: kbAddress);
                                      });
                                    });
                                  });
                                });
                              }),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OutlinedButton(
                              style: outlinedButtonStyles1,
                              child: Text(
                                FlutterI18n.translate(context, "close"),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ),
                        ],
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
        sharedService.alertDialog(
            FlutterI18n.translate(context!, "validationError"),
            FlutterI18n.translate(context!, "amountMissing"));
        setBusy(false);
        return;
      }
      await refreshBalance();
      ExchangeBalanceModel selectedExchangeBal = exchangeBalances
          .firstWhere((element) => element.ticker == tickerName);
      // int coinType = getCoinTypeIdByName(tickerName);
      debugPrint(selectedExchangeBal.coinType.toString());
      double amount = double.parse(amountController.text);
      double selectedCoinBalance = selectedExchangeBal.unlockedAmount!;
      if (selectedCoinBalance <= 0.0 || amount > selectedCoinBalance) {
        sharedService.alertDialog(
            FlutterI18n.translate(context!, "validationError"),
            FlutterI18n.translate(context!, "invalidAmount"));
        setBusy(false);
        log.e('No exchange balance ${selectedExchangeBal.unlockedAmount}');
        return;
      }
      await dialogService
          .showDialog(
              title: FlutterI18n.translate(context!, "enterPassword"),
              description: FlutterI18n.translate(
                  context!, "dialogManagerTypeSamePasswordNote"),
              buttonTitle: FlutterI18n.translate(context!, "confirm"))
          .then((res) async {
        if (res.confirmed!) {
          String? mnemonic = res.returnedText;
          Uint8List seed = walletService.generateSeed(mnemonic);
          await walletService
              .sendCoin(seed, selectedExchangeBal.coinType!,
                  addressController.text, double.parse(amountController.text))
              .then((res) {
            log.w('RES $res');
            if (res['transactionHash'] != null ||
                res['transactionHash'] != '') {
              showSimpleNotification(
                  Text(FlutterI18n.translate(
                      context!, "sendTransactionComplete")),
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
                  FlutterI18n.translate(context!, "transanctionFailed"),
                  FlutterI18n.translate(context!, "pleaseTryAgainLater"));
            }
          });
        } else if (res.returnedText == 'Closed') {
          log.e('Dialog Closed By User');
          setBusy(false);
        } else {
          log.e('Wrong pass');
          sharedService.sharedSimpleNotification(
            FlutterI18n.translate(context!, "notice"),
            subtitle: FlutterI18n.translate(
                context!, "pleaseProvideTheCorrectPassword"),
          );
          setBusy(false);
        }
      }).catchError((error) {
        log.e(error);
        setBusy(false);
        return false;
      });
    } else {
      sharedService.alertDialog(
        FlutterI18n.translate(context!, "validationError"),
        FlutterI18n.translate(
            context!, "pleaseCorrectTheFormatOfReceiveAddress"),
      );
      setBusy(false);
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
              Content Paste Button in receiver address textfield
----------------------------------------------------------------------*/

  Future contentPaste() async {
    await Clipboard.getData('text/plain')
        .then((res) => addressController.text = res!.text!);
  }

  copyAddress(String? txId, BuildContext context) {
    Clipboard.setData(ClipboardData(text: txId!));
    sharedService.sharedSimpleNotification(
        FlutterI18n.translate(context, "copiedSuccessfully"));
  }
}
