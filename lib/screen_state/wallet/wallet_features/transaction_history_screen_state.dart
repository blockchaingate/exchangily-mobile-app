import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/transaction-history.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/transaction_history_database_service.dart';

class TransactionHistoryScreenState extends BaseState {
  final log = getLogger('TransactionHistoryScreenState');
  List<TransactionHistory> transactionHistory;
  TransactionHistoryDatabaseService transactionHistoryDatabaseService =
      locator<TransactionHistoryDatabaseService>();

  getTransaction(String tickerName) async {
    setState(ViewState.Busy);
    transactionHistory = [];
    await transactionHistoryDatabaseService.getByName(tickerName).then((data) {
      transactionHistory = data;
      setState(ViewState.Idle);
    }).catchError((onError) {
      setState(ViewState.Busy);
      log.e(onError);
    });
  }
}
