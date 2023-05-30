import 'dart:convert';
import 'dart:io';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/custom_token_model.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/wallet/wallet_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagination_widget/pagination_widget.dart';

import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';

import 'package:overlay_support/overlay_support.dart';

class TransactionHistoryViewmodel extends FutureViewModel {
  final WalletInfo? walletInfo;
  final String success = 'success';
  final String send = 'send';
  final String pending = 'pending';
  final String withdraw = 'withdraw';
  final String deposit = 'deposit';
  final String rejected = 'rejected or failed';
  final String failed = 'failed';

  TransactionHistoryViewmodel({this.walletInfo});
  final log = getLogger('TransactionHistoryViewmodel');
  late BuildContext context;
  List<TransactionHistory> transactionsToDisplay = [];
  TransactionHistoryDatabaseService? transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  final LocalStorageService? storageService = locator<LocalStorageService>();
  final WalletService? walletService = locator<WalletService>();
  final ApiService? apiService = locator<ApiService>();
  SharedService? sharedService = locator<SharedService>();
  final NavigationService? navigationService = locator<NavigationService>();
  final UserSettingsDatabaseService? userSettingsDatabaseService =
      locator<UserSettingsDatabaseService>();
  final CoreWalletDatabaseService? coreWalletDatabaseService =
      locator<CoreWalletDatabaseService>();
  PaginationModel paginationModel = PaginationModel();
  bool isChinese = false;
  bool isDialogUp = false;
  int? decimalLimit = 6;
  bool isCustomToken = false;
  var walletUtil = WalletUtil();

  @override
  Future futureToRun() async =>
      // tickerName.isEmpty ?
      await transactionHistoryDatabaseService!
          .getByName(walletInfo!.tickerName!);

/*----------------------------------------------------------------------
                  After Future Data is ready
----------------------------------------------------------------------*/
  @override
  void onData(data) async {
    setBusy(true);
    String? tickerName = walletInfo!.tickerName;
    log.i('tx length ${data.length}');
    List<TransactionHistory> txHistoryFromDb = [];
    List<TransactionHistory> txHistoryEvents = [];
    txHistoryFromDb = data;
    String? fabAddress = await walletService!
        .getAddressFromCoreWalletDatabaseByTickerName('FAB');
    txHistoryEvents = await apiService!.getTransactionHistoryEvents(fabAddress);
    if (txHistoryEvents.isNotEmpty) {
      for (var txFromApi in txHistoryEvents) {
        if (txFromApi.tickerName == tickerName) {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'ETH_DSC' &&
            tickerName == 'DSCE') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'ETH_BST' &&
            tickerName == 'BSTE') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'ETH_FAB' &&
            tickerName == 'FABE') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'ETH_EXG' &&
            tickerName == 'EXGE') {
          // element.tickerName = 'EXG(ERC20)';
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'TRON_USDT' &&
            tickerName == 'USDTX') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'TRON_USDC' &&
            tickerName == 'USDCX') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'BNB_USDT' &&
            tickerName == 'USDTB') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'MATIC_USDT' &&
            tickerName == 'USDTM') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'BNB_FAB' &&
            tickerName == 'FABB') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'POLYGON_MATIC' &&
            tickerName == 'MATICM') {
          transactionsToDisplay.add(txFromApi);
        } else if (txFromApi.tickerName!.toUpperCase() == 'POLYGON_USDT' &&
            tickerName == 'USDTM') {
          transactionsToDisplay.add(txFromApi);
        }
      }
    }

    if (txHistoryFromDb.isNotEmpty) {
      for (var t in txHistoryFromDb) {
        if (t.tag == 'send' &&
            (t.tickerName == tickerName ||
                t.tickerName == updateTickers(tickerName!))) {
          transactionsToDisplay.add(t);
        }
      }
    }

    transactionsToDisplay.sort(
        (a, b) => DateTime.parse(b.date!).compareTo(DateTime.parse(a.date!)));

    String customTokenStringData = storageService!.customTokenData;

    try {
      if (customTokenStringData.isNotEmpty) {
        CustomTokenModel customToken =
            CustomTokenModel.fromJson(jsonDecode(customTokenStringData));

        decimalLimit = customToken.decimal;
        isCustomToken = true;
        // customToken = customToken;
      }
    } catch (err) {
      log.e('custom token CATCH $err');
    }
    if (!isCustomToken) {
      await CoinService()
          .getSingleTokenData(tickerName)
          .then((token) => decimalLimit = token!.decimal);
      if (decimalLimit == null || decimalLimit == 0) decimalLimit = 8;
    }
    setBusy(false);
  }

  reloadTransactions() async {
    clearLists();
    await futureToRun();
    onData(data);
  }

  getPaginationTransactions(int pageNumber) async {
    setBusy(true);
    paginationModel.pageNumber = pageNumber;
    await reloadTransactions();

    setBusy(false);
  }

  clearLists() {
    transactionsToDisplay = [];
  }

/*----------------------------------------------------------------------
                  Update special tokens ticker
----------------------------------------------------------------------*/
  updateTickers(String ticker) {
    return walletUtil.updateSpecialTokensTickerName(ticker)['tickerName'];
  }

/*----------------------------------------------------------------------
                  Get transaction
----------------------------------------------------------------------*/
  getTransaction(String tickerName) async {
    setBusy(true);
    transactionsToDisplay = [];
    await transactionHistoryDatabaseService!
        .getByNameOrderByDate(tickerName)
        .then((data) async {
      transactionsToDisplay = data;
      await CoinService()
          .getSingleTokenData(tickerName)
          .then((token) => decimalLimit = token!.decimal);

      for (var t in transactionsToDisplay) {
        log.e(t.toJson);
        if (t.tag!.startsWith('sent')) {
          await walletService!.checkTxStatus(t);
        }
      }
      transactionsToDisplay.sort(
          (a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
      for (var t in transactionsToDisplay) {
        log.w(t.toJson);
      }
      setBusy(false);
    }).catchError((onError) {
      setBusy(false);
      log.e(onError);
    });
  }

/*----------------------------------------------------------------------
                  Copy Address
----------------------------------------------------------------------*/
  copyAddress(String? txId) {
    Clipboard.setData(ClipboardData(text: txId!));
    showSimpleNotification(
        Center(
            child: Text(FlutterI18n.translate(context, "copiedSuccessfully"),
                style: Theme.of(context).textTheme.headlineSmall)),
        position: NotificationPosition.bottom,
        background: primaryColor);
  }

/*----------------------------------------------------------------------
                Tx Detail Dialog
----------------------------------------------------------------------*/
  showTxDetailDialog(TransactionHistory transactionHistory) {
    setBusy(true);
    isDialogUp = true;
    log.i('showTxDetailDialog isDialogUp $isDialogUp');
    setBusy(false);
    if (transactionHistory.chainName!.isEmpty ||
        transactionHistory.chainName == null) {
      transactionHistory.chainName = walletInfo!.tokenType!.isEmpty
          ? updateTickers(walletInfo!.tickerName!)
          : walletInfo!.tokenType;
      log.i(
          'transactionHistory.chainName empty so showing wallet token type ${walletInfo!.tokenType}');
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? Theme(
                  data: ThemeData.dark(),
                  child: CupertinoAlertDialog(
                    title: Center(
                        child: Text(
                      '${FlutterI18n.translate(context, "transactionDetails")}....',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: primaryColor, fontWeight: FontWeight.w500),
                    )),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        UIHelper.verticalSpaceSmall,
                        transactionHistory.tag != send
                            ? Text(
                                '${FlutterI18n.translate(context, "kanban")} Txid',
                                style: Theme.of(context).textTheme.bodyLarge,
                              )
                            : Container(),
                        transactionHistory.tag != send
                            ? Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: RichText(
                                        text: TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrl(
                                                  transactionHistory.kanbanTxId,
                                                  transactionHistory.chainName,
                                                  true);
                                            },
                                          text: transactionHistory
                                                  .kanbanTxId!.isEmpty
                                              ? transactionHistory
                                                      .kanbanTxStatus!.isEmpty
                                                  ? FlutterI18n.translate(
                                                      context, "inProgress")
                                                  : firstCharToUppercase(
                                                      transactionHistory
                                                          .kanbanTxStatus!)
                                              : transactionHistory.kanbanTxId
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ),
                                  transactionHistory.kanbanTxId!.isEmpty
                                      ? Container()
                                      : CupertinoButton(
                                          child: const Icon(
                                              FontAwesomeIcons.copy,
                                              color: white,
                                              size: 16),
                                          onPressed: () => copyAddress(
                                              transactionHistory.kanbanTxId),
                                        )
                                ],
                              )
                            : Container(),
                        UIHelper.verticalSpaceMedium,
                        Text(
                          //AppLocalizations.of(context).quantity,
                          '${transactionHistory.chainName} ${FlutterI18n.translate(context, "chain")} Txid',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: RichText(
                                  text: TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchUrl(
                                            transactionHistory.tickerChainTxId,
                                            transactionHistory.chainName,
                                            false);
                                      },
                                    text: transactionHistory
                                            .tickerChainTxId!.isEmpty
                                        ? transactionHistory
                                                .tickerChainTxStatus!.isEmpty
                                            ? FlutterI18n.translate(
                                                context, "inProgress")
                                            : transactionHistory
                                                .tickerChainTxStatus
                                        : transactionHistory.tickerChainTxId
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                            transactionHistory.tickerChainTxId!.isEmpty
                                ? Container()
                                : CupertinoButton(
                                    child: const Icon(FontAwesomeIcons.copy,
                                        color: white, size: 16),
                                    onPressed: () => copyAddress(
                                        transactionHistory.tickerChainTxId),
                                  )
                          ],
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.only(left: 5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              child: Text(
                                FlutterI18n.translate(context, "close"),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : AlertDialog(
                  titlePadding: EdgeInsets.zero,
                  contentPadding: const EdgeInsets.all(5.0),
                  elevation: 5,
                  backgroundColor: walletCardColor.withOpacity(0.85),
                  title: Container(
                    padding: const EdgeInsets.all(10.0),
                    color: secondaryColor.withOpacity(0.5),
                    child: Center(
                        child: Text(FlutterI18n.translate(
                            context, "transactionDetails"))),
                  ),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  contentTextStyle: const TextStyle(color: grey),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      transactionHistory.tag != send
                          ? Text(
                              //AppLocalizations.of(context).,
                              '${FlutterI18n.translate(context, "kanban")} Txid',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          : Container(),
                      transactionHistory.tag != send
                          ? Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            launchUrl(
                                                transactionHistory.kanbanTxId,
                                                transactionHistory.chainName,
                                                true);
                                          },
                                        text: transactionHistory
                                                .kanbanTxId!.isEmpty
                                            ? transactionHistory
                                                    .kanbanTxStatus!.isEmpty
                                                ? FlutterI18n.translate(
                                                    context, "inProgress")
                                                : firstCharToUppercase(
                                                    transactionHistory
                                                        .kanbanTxStatus!)
                                            : transactionHistory.kanbanTxId
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                transactionHistory.kanbanTxId!.isEmpty
                                    ? Container()
                                    : IconButton(
                                        icon: const Icon(Icons.copy_outlined,
                                            color: white, size: 16),
                                        onPressed: () => copyAddress(
                                            transactionHistory.kanbanTxId),
                                      )
                              ],
                            )
                          : Container(),
                      UIHelper.verticalSpaceMedium,
                      Text(
                        //AppLocalizations.of(context).quantity,
                        '${transactionHistory.chainName} ${FlutterI18n.translate(context, "chain")} Txid',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(
                                          transactionHistory.tickerChainTxId,
                                          transactionHistory.chainName,
                                          false);
                                    },
                                  text: transactionHistory
                                          .tickerChainTxId!.isEmpty
                                      ? transactionHistory
                                              .tickerChainTxStatus!.isEmpty
                                          ? FlutterI18n.translate(
                                              context, "inProgress")
                                          : transactionHistory
                                              .tickerChainTxStatus
                                      : transactionHistory.tickerChainTxId
                                          .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.blue),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_outlined,
                                color: white, size: 16),
                            onPressed: () =>
                                copyAddress(transactionHistory.tickerChainTxId),
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceMedium,
                      TextButton(
                        onPressed: () {
                          setBusy(true);
                          Navigator.of(context).pop();
                          isDialogUp = false;
                          setBusy(false);
                        },
                        child: Text(
                          FlutterI18n.translate(context, "close"),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      )
                    ],
                  ));
        });
  }

/*----------------------------------------------------------------------
                  Launch URL
----------------------------------------------------------------------*/
  launchUrl(String? txId, String? chain, bool isKanban) async {
    // copyAddress(txId);
    if (isKanban) {
      String exchangilyExplorerUrl = ExchangilyExplorerUrl + txId!;
      log.i('Kanban - explorer url - $exchangilyExplorerUrl');
      openExplorer(exchangilyExplorerUrl);
    } else if (chain!.toUpperCase() == 'FAB') {
      String fabExplorerUrl = FabExplorerUrl + txId!;
      log.i('FAB - chainame $chain explorer url - $fabExplorerUrl');
      openExplorer(fabExplorerUrl);
    } else if (chain.toUpperCase() == 'BTC') {
      String bitcoinExplorerUrl = BitcoinExplorerUrl + txId!;
      log.i('BTC - chainame $chain explorer url - $bitcoinExplorerUrl');
      openExplorer(bitcoinExplorerUrl);
    } else if (chain.toUpperCase() == 'ETH') {
      String ethereumExplorerUrl = isProduction
          ? EthereumExplorerUrl + txId!
          : TestnetEthereumExplorerUrl + txId!;
      log.i('ETH - chainame $chain explorer url - $ethereumExplorerUrl');
      openExplorer(ethereumExplorerUrl);
    } else if (chain.toUpperCase() == 'BNB') {
      log.i('chainame $chain explorer url - ${bnbExplorerUrl + txId!}');
      openExplorer(bnbExplorerUrl + txId);
    } else if (chain.toUpperCase() == 'MATICM' ||
        chain.toUpperCase() == 'POLYGON') {
      log.i('chainame $chain explorer url - ${maticmExplorerUrl + txId!}');
      openExplorer(maticmExplorerUrl + txId);
    } else if (chain.toUpperCase() == 'LTC') {
      String litecoinExplorerUrl = LitecoinExplorerUrl + txId!;
      log.i('LTC - chainame $chain explorer url - $litecoinExplorerUrl');
      openExplorer(litecoinExplorerUrl);
    } else if (chain.toUpperCase() == 'DOGE') {
      String dogeExplorerUrl = DogeExplorerUrl + txId!;
      log.i('doge - chainame $chain explorer url - $dogeExplorerUrl');
      openExplorer(dogeExplorerUrl);
    } else if (chain.toUpperCase() == 'TRON' || chain.toUpperCase() == 'TRX') {
      if (txId!.startsWith('0x')) {
        txId = txId.substring(2);
      }
      String tronExplorerUrl = TronExplorerUrl + txId;
      log.i('tron - chainame $chain explorer url - $tronExplorerUrl');
      openExplorer(tronExplorerUrl);
    } else if (chain.toUpperCase() == 'BCH') {
      String bitcoinCashExplorerUrl = BitcoinCashExplorerUrl + txId!;
      log.i('BCH - chainame $chain explorer url - $bitcoinCashExplorerUrl');
      openExplorer(bitcoinCashExplorerUrl);
    } else {
      throw 'Could not launch';
    }
  }

  // launch url
  openExplorer(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
