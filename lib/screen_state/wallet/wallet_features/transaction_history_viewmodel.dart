import 'package:exchangilymobileapp/constants/api_routes.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/config_service.dart';
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

  PairDecimalConfig decimalConfig = new PairDecimalConfig();
  WalletInfo walletInfo = new WalletInfo();

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
      transactionHistoryToShowInView.add(element);
    });
    print(txHistoryEvents.length);
    if (txHistoryFromDb != null)
      txHistoryFromDb.forEach((t) async {
        if (t.tag == 'send') transactionHistoryToShowInView.add(t);

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
    setBusy(false);
    print(transactionHistoryToShowInView.first.toJson());
  }

  getWithdrawDepositTxHistoryEvents() async {
    return await apiService.getTransactionHistoryEvents();
  }

  getWalletFromDb() async {
    await walletDataBaseService.getBytickerName(tickerName).then((res) {
      walletInfo = res;
    });
  }

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
        title: 'Transaction Details',
        // closeFunction: () {
        //   Navigator.of(context).pop();
        // },
        content: Column(
          children: <Widget>[
            Text(
              //AppLocalizations.of(context).,
              'Kanban TxId',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RichText(
                text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(transactionHistory.kanbanTxId,
                          transactionHistory.tickerName, true);
                    },
                  text: transactionHistory.kanbanTxId.isEmpty
                      ? transactionHistory.kanbanTxStatus.isEmpty
                          ? 'In progress'
                          : transactionHistory.kanbanTxStatus
                      : transactionHistory.kanbanTxId.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.blue),
                ),
              ),
            ),
            UIHelper.verticalSpaceMedium,
            Text(
              //AppLocalizations.of(context).quantity,
              '${transactionHistory.tickerName} Chain TxId',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RichText(
                text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(transactionHistory.tickerChainTxId,
                          transactionHistory.tickerName, false);
                    },
                  text: transactionHistory.tickerChainTxId.isEmpty
                      ? transactionHistory.tickerChainTxStatus.isEmpty
                          ? 'In Progress'
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

  launchUrl(txId, tickerName, bool isKanban) async {
    ConfigService configService = locator<ConfigService>();
    String baseServerUrl = configService.getKanbanBaseUrl();
    if (isKanban) {
      String exchangilyExplorerUrl = ExchangilyExplorerUrl + txId;
      if (await canLaunch(exchangilyExplorerUrl)) {
        await launch(exchangilyExplorerUrl);
      }
    } else {
      throw 'Could not launch';
    }
  }
}
