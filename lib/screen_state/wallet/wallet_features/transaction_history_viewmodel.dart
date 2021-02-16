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
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:exchangilymobileapp/services/db/user_settings_database_service.dart';

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
    print(txHistoryEvents.length);
    if (txHistoryFromDb != null)
      txHistoryFromDb.forEach((t) async {
        if (t.tag == 'send' && t.tickerName == tickerName)
          transactionHistoryToShowInView.add(t);

        // if (t.tickerChainTxStatus == 'pending' &&
        //     t.tag != 'send' &&
        //     t.tag != 'bindpay') {
        //   print('pending tx found ${t.toJson}');
        //   await walletService.checkTxStatus(t);
        //   log.w('called wallet service to check tx');
        // } else {
        //   log.e('no tranaction with pending tag');
        // }
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
    sharedService.alertDialog(AppLocalizations.of(context).transactionId,
        AppLocalizations.of(context).copiedSuccessfully,
        isWarning: false);
  }

/*----------------------------------------------------------------------
                Tx Detail Dialog
----------------------------------------------------------------------*/
  showTxDetailDialog(TransactionHistory transactionHistory) {
    Alert(
        style: AlertStyle(
            isButtonVisible: false,
            isCloseButton: false,
            animationType: AnimationType.grow,
            isOverlayTapDismiss: true,
            backgroundColor: walletCardColor,
            descStyle: Theme.of(context).textTheme.bodyText1,
            titleStyle: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(decoration: TextDecoration.underline)),
        context: context,
        title: AppLocalizations.of(context).transactionDetails,
        // closeFunction: () {
        //   Navigator.of(context).pop();
        // },
        content: Column(
          children: <Widget>[
            transactionHistory.tag != send
                ? Text(
                    //AppLocalizations.of(context).,
                    '${AppLocalizations.of(context).kanban} Txid',
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                : Container(),
            transactionHistory.tag != send
                ? Padding(
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
                  )
                : Container(),
            UIHelper.verticalSpaceMedium,
            Text(
              //AppLocalizations.of(context).quantity,
              '${transactionHistory.chainName} ${AppLocalizations.of(context).chain} Txid',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
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
          ],
        )).show();
  }

/*----------------------------------------------------------------------
                  Launch URL
----------------------------------------------------------------------*/
  launchUrl(String txId, String chain, bool isKanban) async {
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

  Future test() async {
    String date = DateTime.now().toLocal().toString();
    TransactionHistory transactionHistory = new TransactionHistory(
      id: null,
      tickerName: tickerName,
      address: '',
      amount: 0.0,
      date: date,
      kanbanTxId: '',
      tickerChainTxId:
          '0x32ac8336a8660465413a649e1ae97c7eba84b13cdb057051e7c4fcac44af6da9',
      quantity: 0.15,
      tag: 'send',
      chainName: 'ETH',
    );
    // await transactionHistoryDatabaseService.deleteDb();
    walletService.insertTransactionInDatabase(transactionHistory);
    // transactionHistoryDatabaseService
    //     .insert(transactionHistory)
    //     .then((data) async {
    //   log.w('Saved in transaction history database $data');
    // });
  }
}
