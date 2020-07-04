import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/shared/decimal_config.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/trade_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class TransactionHistoryScreenState extends BaseState {
  final log = getLogger('TransactionHistoryScreenState');
  BuildContext context;
  List<TransactionHistory> transactionHistory;
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();
  SharedService sharedService = locator<SharedService>();
  DecimalConfig decimalConfig = new DecimalConfig();
  TradeService tradeService = locator<TradeService>();
  getTransaction(String tickerName) async {
    setBusy(true);
    transactionHistory = [];
    await transactionHistoryDatabaseService
        .getByName(tickerName)
        .then((data) async {
      transactionHistory = data;
      await tradeService
          .getDecimalPairConfig(tickerName)
          .then((decimalConfig) => decimalConfig = decimalConfig);
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
}
