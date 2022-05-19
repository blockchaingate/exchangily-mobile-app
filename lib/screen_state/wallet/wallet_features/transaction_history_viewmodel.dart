import 'dart:convert';
import 'dart:io';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/custom_token_model.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/app_wallet_model.dart';
import 'package:exchangilymobileapp/service_locator.dart';
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';

import 'package:overlay_support/overlay_support.dart';

class TransactionHistoryViewmodel extends FutureViewModel {
  final AppWallet appWallet;
  final String success = 'success';
  final String bindpay = 'bindpay';
  final String send = 'send';
  final String pending = 'pending';
  final String withdraw = 'withdraw';
  final String deposit = 'deposit';
  final String rejected = 'rejected or failed';

  TransactionHistoryViewmodel({this.appWallet});
  final log = getLogger('TransactionHistoryViewmodel');
  BuildContext context;
  List<TransactionHistory> transactionHistoryToShowInView = [];
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  final storageService = locator<LocalStorageService>();
  final walletService = locator<WalletService>();
  final apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  final navigationService = locator<NavigationService>();
  final userSettingsDatabaseService = locator<UserSettingsDatabaseService>();
  final coreWalletDatabaseService = locator<CoreWalletDatabaseService>();

  bool isChinese = false;
  bool isDialogUp = false;
  int decimalLimit = 0;
  bool isCustomToken = false;
  var walletUtil = WalletUtil();

  @override
  Future futureToRun() async =>
      // {
      //   try {
      await transactionHistoryDatabaseService.getByName(appWallet.tickerName);
  // } catch (err) {
  //   log.e('Future to run CATCH : $err');
  // }
//  }

/*----------------------------------------------------------------------
                  After Future Data is ready
----------------------------------------------------------------------*/
  @override
  void onData(data) async {
    setBusy(true);
    String tickerName = appWallet.tickerName;
    if (data != null) {
      log.i('tx length ${data.length}');
    }
    List<TransactionHistory> txHistoryFromDb = [];
    List<TransactionHistory> txHistoryEvents = [];
    txHistoryFromDb = data;
    String fabAddress =
        await walletService.getAddressFromCoreWalletDatabaseByTickerName('FAB');
    txHistoryEvents = await apiService.getTransactionHistoryEvents(fabAddress);
    if (txHistoryEvents.isNotEmpty) {
      for (var element in txHistoryEvents) {
        if (element.tickerName == tickerName) {
          transactionHistoryToShowInView.add(element);
        } else if (element.tickerName.toUpperCase() == 'ETH_DSC' &&
            tickerName == 'DSCE') {
          transactionHistoryToShowInView.add(element);
        } else if (element.tickerName.toUpperCase() == 'ETH_BST' &&
            tickerName == 'BSTE') {
          transactionHistoryToShowInView.add(element);
        } else if (element.tickerName.toUpperCase() == 'ETH_FAB' &&
            tickerName == 'FABE') {
          transactionHistoryToShowInView.add(element);
        } else if (element.tickerName.toUpperCase() == 'ETH_EXG' &&
            tickerName == 'EXGE') {
          // element.tickerName = 'EXG(ERC20)';
          transactionHistoryToShowInView.add(element);
        } else if (element.tickerName.toUpperCase() == 'TRON_USDT' &&
            tickerName == 'USDTX') {
          transactionHistoryToShowInView.add(element);
        }
      }
    }

    if (txHistoryFromDb != null || txHistoryFromDb.isNotEmpty) {
      for (var t in txHistoryFromDb) {
        if (t.tag == 'send' && t.tickerName == tickerName) {
          transactionHistoryToShowInView.add(t);
        }
      }
    }
    transactionHistoryToShowInView.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    await userSettingsDatabaseService.getLanguage().then((value) {
      if (value == 'zh') isChinese = true;
    });

    String customTokenStringData = storageService.customTokenData;

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
      decimalLimit =
          await walletService.getSingleCoinWalletDecimalLimit(tickerName);
      if (decimalLimit == null || decimalLimit == 0) decimalLimit = 8;
    }
    // debugPrint(transactionHistoryToShowInView.first.toJson());
    setBusy(false);
  }

  reloadTransactions() async {
    clearLists();
    await futureToRun();
    onData(data);
  }

  clearLists() {
    transactionHistoryToShowInView = [];
  }

/*----------------------------------------------------------------------
                  Update special tokens ticker
----------------------------------------------------------------------*/
  updateTickers(String ticker) {
    return walletUtil
        .updateSpecialTokensTickerNameForTxHistory(ticker)['tickerName'];
  }

/*----------------------------------------------------------------------
                  Get transaction
----------------------------------------------------------------------*/
  getTransaction(String tickerName) async {
    setBusy(true);
    transactionHistoryToShowInView = [];
    await transactionHistoryDatabaseService
        .getByNameOrderByDate(tickerName)
        .then((data) async {
      transactionHistoryToShowInView = data;
      await sharedService
          .getSinglePairDecimalConfig(tickerName)
          .then((decimalConfig) => decimalConfig = decimalConfig);

      for (var t in transactionHistoryToShowInView) {
        log.e(t.toJson);
        if (t.tag.startsWith('sent')) {
          await walletService.checkTxStatus(t);
        }
      }
      transactionHistoryToShowInView.sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
      for (var t in transactionHistoryToShowInView) {
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
  copyAddress(String txId) {
    Clipboard.setData(ClipboardData(text: txId));
    showSimpleNotification(
        Center(
            child: Text(AppLocalizations.of(context).copiedSuccessfully,
                style: Theme.of(context).textTheme.headline5)),
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
    if (transactionHistory.chainName.isEmpty ||
        transactionHistory.chainName == null) {
      transactionHistory.chainName = appWallet.tokenType.isEmpty
          ? appWallet.tickerName
          : appWallet.tokenType;
      log.i(
          'transactionHistory.chainName empty so showing wallet token type ${appWallet.tokenType}');
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? Theme(
                  data: ThemeData.dark(),
                  child: CupertinoAlertDialog(
                    title: Container(
                      child: Center(
                          child: Text(
                        '${AppLocalizations.of(context).transactionDetails}....',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: primaryColor, fontWeight: FontWeight.w500),
                      )),
                    ),
                    content: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          UIHelper.verticalSpaceSmall,
                          transactionHistory.tag != send
                              ? Text(
                                  '${AppLocalizations.of(context).kanban} Txid',
                                  style: Theme.of(context).textTheme.bodyText1,
                                )
                              : Container(),
                          transactionHistory.tag != send
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                launchUrl(
                                                    transactionHistory
                                                        .kanbanTxId,
                                                    transactionHistory
                                                        .chainName,
                                                    true);
                                              },
                                            text: transactionHistory
                                                    .kanbanTxId.isEmpty
                                                ? transactionHistory
                                                        .kanbanTxStatus.isEmpty
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .inProgress
                                                    : firstCharToUppercase(
                                                        transactionHistory
                                                            .kanbanTxStatus)
                                                : transactionHistory.kanbanTxId
                                                    .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ),
                                    transactionHistory.kanbanTxId.isEmpty
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
                            '${transactionHistory.chainName} ${AppLocalizations.of(context).chain} Txid',
                            style: Theme.of(context).textTheme.bodyText1,
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
                                              transactionHistory
                                                  .tickerChainTxId,
                                              transactionHistory.chainName,
                                              false);
                                        },
                                      text: transactionHistory
                                              .tickerChainTxId.isEmpty
                                          ? transactionHistory
                                                  .tickerChainTxStatus.isEmpty
                                              ? AppLocalizations.of(context)
                                                  .inProgress
                                              : transactionHistory
                                                  .tickerChainTxStatus
                                          : transactionHistory.tickerChainTxId
                                              .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                              transactionHistory.tickerChainTxId.isEmpty
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
                                AppLocalizations.of(context).close,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
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
                        child: Text(
                            AppLocalizations.of(context).transactionDetails)),
                  ),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.bold),
                  contentTextStyle: const TextStyle(color: grey),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      transactionHistory.tag != send
                          ? Text(
                              //AppLocalizations.of(context).,
                              '${AppLocalizations.of(context).kanban} Txid',
                              style: Theme.of(context).textTheme.bodyText1,
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
                                                .kanbanTxId.isEmpty
                                            ? transactionHistory
                                                    .kanbanTxStatus.isEmpty
                                                ? AppLocalizations.of(context)
                                                    .inProgress
                                                : firstCharToUppercase(
                                                    transactionHistory
                                                        .kanbanTxStatus)
                                            : transactionHistory.kanbanTxId
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                transactionHistory.kanbanTxId.isEmpty
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
                        '${transactionHistory.chainName} ${AppLocalizations.of(context).chain} Txid',
                        style: Theme.of(context).textTheme.bodyText1,
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
                                  text:
                                      transactionHistory.tickerChainTxId.isEmpty
                                          ? transactionHistory
                                                  .tickerChainTxStatus.isEmpty
                                              ? AppLocalizations.of(context)
                                                  .inProgress
                                              : transactionHistory
                                                  .tickerChainTxStatus
                                          : transactionHistory.tickerChainTxId
                                              .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
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
                          AppLocalizations.of(context).close,
                          style: Theme.of(context).textTheme.button,
                        ),
                      )
                    ],
                  ));
        });
  }

/*----------------------------------------------------------------------
                  Launch URL
----------------------------------------------------------------------*/
  launchUrl(String txId, String chain, bool isKanban) async {
    // copyAddress(txId);
    String baseUrl = '';
    if (isKanban) {
      String baseUrl = exchangilyExplorerUrl;
      log.i('Kanban - explorer url - $baseUrl');
    } else if (chain.toUpperCase() == 'FAB') {
      baseUrl = fabExplorerUrl + txId;
      log.i('FAB - chainame $chain explorer url - $fabExplorerUrl');
    } else if (chain.toUpperCase() == 'BTC') {
      baseUrl = bitcoinExplorerUrl + txId;
      log.i('BTC - chainame $chain explorer url - $bitcoinExplorerUrl');
    } else if (chain.toUpperCase() == 'ETH') {
      baseUrl = isProduction
          ? ethereumExplorerUrl + txId
          : testnetEthereumExplorerUrl + txId;
      log.i('ETH - chainame $chain explorer url - $ethereumExplorerUrl');
    } else if (chain.toUpperCase() == 'LTC') {
      baseUrl = litecoinExplorerUrl + txId;
      log.i('LTC - chainame $chain explorer url - $litecoinExplorerUrl');
    } else if (chain.toUpperCase() == 'DOGE') {
      baseUrl = dogeExplorerUrl + txId;
      log.i('doge - chainame $chain explorer url - $dogeExplorerUrl');
    } else if (chain.toUpperCase() == 'TRON' || chain.toUpperCase() == 'TRX') {
      if (txId.startsWith('0x')) {
        txId = txId.substring(2);
      }
      baseUrl = tronExplorerUrl + txId;
      log.i('tron - chainame $chain explorer url - $tronExplorerUrl');
    } else if (chain.toUpperCase() == 'BCH') {
      baseUrl = bitcoinCashExplorerUrl + txId;
      log.i('BCH - chainame $chain explorer url - $bitcoinCashExplorerUrl');
    } else {
      throw 'Could not launch';
    }

    if (await canLaunch(baseUrl)) {
      await launch(baseUrl);
    } else {
      log.e('open explorer func: can not open URL');
    }
  }
}
