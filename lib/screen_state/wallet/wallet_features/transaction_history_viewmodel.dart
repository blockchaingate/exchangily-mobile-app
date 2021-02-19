import 'dart:io';

import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:overlay_support/overlay_support.dart';

class TransactionHistoryViewmodel extends FutureViewModel {
  final String tickerName;
  final String success = 'success';
  final String bindpay = 'bindpay';
  final String send = 'send';
  final String pending = 'pending';
  final String withdraw = 'withdraw';
  final String deposit = 'deposit';
  final String rejected = 'rejected or failed';

  TransactionHistoryViewmodel({this.tickerName});
  final log = getLogger('TransactionHistoryViewmodel');
  BuildContext context;
  List<TransactionHistory> transactionHistoryToShowInView = [];
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  final walletService = locator<WalletService>();
  final apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  final navigationService = locator<NavigationService>();
  final userSettingsDatabaseService = locator<UserSettingsDatabaseService>();

  PairDecimalConfig decimalConfig = new PairDecimalConfig();
  WalletInfo walletInfo = new WalletInfo();
  bool isChinese = false;

  @override
  Future futureToRun() async =>
      // tickerName.isEmpty ?
      await transactionHistoryDatabaseService.getByName(tickerName);

/*----------------------------------------------------------------------
                  After Future Data is ready
----------------------------------------------------------------------*/
  @override
  void onData(data) async {
    setBusy(true);
    log.i('tx length ${data.length}');
    List<TransactionHistory> txHistoryFromDb = [];
    List<TransactionHistory> txHistoryEvents = [];
    txHistoryFromDb = data;
    await sharedService
        .getSinglePairDecimalConfig(tickerName)
        .then((decimalConfig) => decimalConfig = decimalConfig);
    txHistoryEvents = await getWithdrawDepositTxHistoryEvents();
    txHistoryEvents.forEach((element) {
      if (element.tickerName == tickerName)
        transactionHistoryToShowInView.add(element);
    });

    if (txHistoryFromDb != null)
      txHistoryFromDb.forEach((t) async {
        if (t.tag == 'send' && t.tickerName == tickerName)
          transactionHistoryToShowInView.add(t);
      });
    transactionHistoryToShowInView.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    await userSettingsDatabaseService.getLanguage().then((value) {
      if (value == 'zh') isChinese = true;
    });
    setBusy(false);
    // print(transactionHistoryToShowInView.first.toJson());
  }

  getWithdrawDepositTxHistoryEvents() async {
    return await apiService.getTransactionHistoryEvents();
  }

  getWalletFromDb() async {
    await walletDataBaseService.getBytickerName(tickerName).then((res) {
      walletInfo = res;
    });
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

      transactionHistoryToShowInView.forEach((t) async {
        log.e(t.toJson);
        if (t.tag.startsWith('sent')) {
          await walletService.checkTxStatus(t);
        }
      });
      transactionHistoryToShowInView.sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
      transactionHistoryToShowInView.forEach((t) {
        log.w(t.toJson);
      });
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
    Clipboard.setData(new ClipboardData(text: txId));
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
    if (transactionHistory.chainName.isEmpty)
      transactionHistory.chainName = transactionHistory.tickerName;
      showDialog(
        context: context,
        builder: (BuildContext context) {
      return Platform.isIOS
              ? Theme(
            data: ThemeData.dark(),
                              child: CupertinoAlertDialog(
                    title: Container(
                    
                      child: Center(
                          child: Text(
                              '${AppLocalizations.of(context).transactionDetails}',style: Theme.of(context).textTheme.headline4.copyWith(color:primaryColor,fontWeight: FontWeight.w500),)),
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
                              padding: const EdgeInsets.only(top: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(transactionHistory.kanbanTxId,
                                          transactionHistory.chainName, true);
                                    },
                                  text: transactionHistory.kanbanTxId.isEmpty
                                      ? transactionHistory.kanbanTxStatus.isEmpty
                                          ? AppLocalizations.of(context).inProgress
                                          : firstCharToUppercase(
                                              transactionHistory.kanbanTxStatus)
                                      : transactionHistory.kanbanTxId.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(color: Colors.blue),
                                ),
                              ),
                            ),
                          ),

                          CupertinoButton(
                            child: Icon(FontAwesomeIcons.copy, color: white, size: 16),
                            onPressed: () =>
                                copyAddress(transactionHistory.kanbanTxId),
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
                                launchUrl(transactionHistory.tickerChainTxId,
                                    transactionHistory.chainName, false);
                              },
                            text: transactionHistory.tickerChainTxId.isEmpty
                                ? transactionHistory.tickerChainTxStatus.isEmpty
                                    ? AppLocalizations.of(context).inProgress
                                    : transactionHistory.tickerChainTxStatus
                                : transactionHistory.tickerChainTxId.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.blue),
                          ),
                        ),
                      ),
                  ),
                  CupertinoButton(
                      child: Icon(FontAwesomeIcons.copy, color: white, size: 16),
                      onPressed: () =>
                          copyAddress(transactionHistory.tickerChainTxId),
                  )
                ],
            ),
          ],
        ),
                    ),
                    actions: <Widget>[
                      
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            CupertinoButton(
                              padding: EdgeInsets.only(left: 5),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              child: Text(
                                AppLocalizations.of(context).close,
                                style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight:FontWeight.bold),
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
              ):
    AlertDialog(
           titlePadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.all(5.0),
                 
                  elevation: 5,
                  backgroundColor: walletCardColor.withOpacity(0.85),
                  title: Container(
                    padding: EdgeInsets.all(10.0),
                    color: secondaryColor.withOpacity(0.5),
                    child: Center(
                        child: Text(
                            '${AppLocalizations.of(context).transactionDetails}')),
                  ),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.bold),
                  contentTextStyle: TextStyle(color: grey),

        content: Column(mainAxisSize: MainAxisSize.min,
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
                          padding: const EdgeInsets.only(top: 8.0,left:8.0),
                          child: RichText(
                            text: TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  launchUrl(transactionHistory.kanbanTxId,
                                      transactionHistory.chainName, true);
                                },
                              text: transactionHistory.kanbanTxId.isEmpty
                                  ? transactionHistory.kanbanTxStatus.isEmpty
                                      ? AppLocalizations.of(context).inProgress
                                      : firstCharToUppercase(
                                          transactionHistory.kanbanTxStatus)
                                  : transactionHistory.kanbanTxId.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy_outlined, color: white, size: 16),
                        onPressed: () =>
                            copyAddress(transactionHistory.kanbanTxId),
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
                    padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                    child: RichText(
                      text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launchUrl(transactionHistory.tickerChainTxId,
                                transactionHistory.chainName, false);
                          },
                        text: transactionHistory.tickerChainTxId.isEmpty
                            ? transactionHistory.tickerChainTxStatus.isEmpty
                                ? AppLocalizations.of(context).inProgress
                                : transactionHistory.tickerChainTxStatus
                            : transactionHistory.tickerChainTxId.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy_outlined, color: white, size: 16),
                  onPressed: () =>
                      copyAddress(transactionHistory.tickerChainTxId),
                )
              ],
            ),
            UIHelper.verticalSpaceMedium
          ],
        ));
        });
  }

/*----------------------------------------------------------------------
                  Launch URL
----------------------------------------------------------------------*/
  launchUrl(String txId, String chain, bool isKanban) async {
    copyAddress(txId);
    if (isKanban) {
      String exchangilyExplorerUrl = ExchangilyExplorerUrl + txId;
      log.i('Kanban - explorer url - $exchangilyExplorerUrl');
      openExplorer(exchangilyExplorerUrl);
    } else if (chain.toUpperCase() == 'FAB') {
      String fabExplorerUrl = FabExplorerUrl + txId;
      log.i('FAB - chainame $chain explorer url - $fabExplorerUrl');
      openExplorer(fabExplorerUrl);
    } else if (chain.toUpperCase() == 'BTC') {
      String bitcoinExplorerUrl = BitcoinExplorerUrl + txId;
      log.i('BTC - chainame $chain explorer url - $bitcoinExplorerUrl');
      openExplorer(bitcoinExplorerUrl);
    } else if (chain.toUpperCase() == 'ETH') {
      String ethereumExplorerUrl = isProduction
          ? EthereumExplorerUrl + txId
          : TestnetEthereumExplorerUrl + txId;
      log.i('ETH - chainame $chain explorer url - $ethereumExplorerUrl');
      openExplorer(ethereumExplorerUrl);
    } else if (chain.toUpperCase() == 'LTC') {
      String litecoinExplorerUrl = LitecoinExplorerUrl + txId;
      log.i('LTC - chainame $chain explorer url - $litecoinExplorerUrl');
      openExplorer(litecoinExplorerUrl);
    } else if (chain.toUpperCase() == 'DOGE') {
      String dogeExplorerUrl = DogeExplorerUrl + txId;
      log.i('doge - chainame $chain explorer url - $dogeExplorerUrl');
      openExplorer(dogeExplorerUrl);
    } else if (chain.toUpperCase() == 'TRON') {
      String tronExplorerUrl = TronExplorerUrl + txId;
      log.i('tron - chainame $chain explorer url - $tronExplorerUrl');
      openExplorer(tronExplorerUrl);
    } else if (chain.toUpperCase() == 'BCH') {
      String bitcoinCashExplorerUrl = BitcoinCashExplorerUrl + txId;
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
