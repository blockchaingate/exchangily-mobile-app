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
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class TransactionHistoryViewmodel extends FutureViewModel {
  final String tickerName;

  final String bindpay = 'bindpay';
  final String send = 'send';
  final String withdraw = 'withdraw';
  final String deposit = 'deposit';
  final String requireRedeposit = 'Require redeposit';

  TransactionHistoryViewmodel({this.tickerName});
  final log = getLogger('TransactionHistoryViewmodel');
  BuildContext context;
  List<TransactionHistory> transactionHistory = [];
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();
  final walletService = locator<WalletService>();
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
    List<TransactionHistory> txHistory = [];
    txHistory = data;
    await sharedService
        .getSinglePairDecimalConfig(tickerName)
        .then((decimalConfig) => decimalConfig = decimalConfig);
    setBusy(false);
    if (transactionHistory != null)
      txHistory.forEach((t) async {
        if (t.tag != 'bindpay') transactionHistory.add(t);

        if (t.status == 'pending' && t.tag != 'send' && t.tag != 'bindpay') {
          print('pending tx found ${t.toJson}');
          await walletService.checkTxStatus(t);
          log.w('called wallet service to check tx');
        } else {
          log.e('no tranaction with pending tag');
        }
      });
  }

  getWalletFromDb() async {
    await walletDataBaseService.getBytickerName(tickerName).then((res) {
      walletInfo = res;
    });
  }

  getTransaction(String tickerName) async {
    setBusy(true);
    transactionHistory = [];
    await transactionHistoryDatabaseService
        .getByNameOrderByDate(tickerName)
        .then((data) async {
      transactionHistory = data;
      await sharedService
          .getSinglePairDecimalConfig(tickerName)
          .then((decimalConfig) => decimalConfig = decimalConfig);

      transactionHistory.forEach((t) async {
        print(t.toJson);
        if (t.tag == 'Pending') {
          await walletService.checkTxStatus(t);
        }
      });
    }).catchError((onError) {
      setBusy(false);
      log.e(onError);
    });
    setBusy(false);
  }

  copyAddress(String txId) {
    Clipboard.setData(new ClipboardData(text: txId));
    sharedService.alertDialog(AppLocalizations.of(context).transactionId,
        AppLocalizations.of(context).copiedSuccessfully,
        isWarning: false);
  }

// pending as currently i save tx's locally but t
  getWithdrawTxFromApi() {}
}
