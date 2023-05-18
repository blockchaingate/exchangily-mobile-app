import 'transactions.dart';

class TransactionHistoryEvents {
  String? action;
  String? coin;
  int? timestamp;
  String? quantity;
  List<Transactions>? transactions;

  TransactionHistoryEvents({
    this.action,
    this.coin,
    this.timestamp,
    this.quantity,
    this.transactions,
  });

  @override
  String toString() {
    return 'TransactionHistoryEvents(action: $action, coin: $coin, timestamp: $timestamp, quantity: $quantity, transactions: $transactions)';
  }

  factory TransactionHistoryEvents.fromJson(Map<String, dynamic> json) {
    return TransactionHistoryEvents(
      action: json['action'] as String?,
      coin: json['coin'] as String?,
      timestamp: json['timestamp'] as int?,
      quantity: json['quantity'] as String?,
      transactions: (json['transactions'])?.map((e) {
        return e == null
            ? null
            : Transactions.fromJson(e as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'coin': coin,
      'timestamp': timestamp,
      'quantity': quantity,
      'transactions': transactions?.map((e) => e.toJson()).toList(),
    };
  }
}

class TransactionHistoryEventsList {
  final List<TransactionHistoryEvents>? transactions;
  TransactionHistoryEventsList({this.transactions});

  factory TransactionHistoryEventsList.fromJson(List<dynamic> parsedJson) {
    List<TransactionHistoryEvents> transactions = <TransactionHistoryEvents>[];
    transactions =
        parsedJson.map((i) => TransactionHistoryEvents.fromJson(i)).toList();
    return TransactionHistoryEventsList(transactions: transactions);
  }
}
