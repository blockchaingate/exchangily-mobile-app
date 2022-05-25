class TransactionHistory {
  int id;
  String tickerName;
  String address;
  String amount;
  String date;
  String tickerChainTxId;
  String kanbanTxId;
  String tickerChainTxStatus; // for deposit look for this one first
  String kanbanTxStatus; // for withdraw look for this one first
  String quantity;
  String tag;
  String chainName;

  TransactionHistory(
      {this.id,
      this.tickerName = '',
      this.address = '',
      this.amount = '',
      this.date = '',
      this.tickerChainTxId = '',
      this.kanbanTxId = '',
      this.tickerChainTxStatus = '',
      this.kanbanTxStatus = '',
      this.quantity = '',
      this.tag = '',
      this.chainName = ''});

  Map<String, dynamic> toJson() => {
        'id': id,
        'tickerName': tickerName,
        'address': address,
        'amount': amount,
        'date': date,
        'tickerChainTxId': tickerChainTxId,
        'kanbanTxId': kanbanTxId,
        'tickerChainTxStatus': tickerChainTxStatus,
        'kanbanTxStatus': kanbanTxStatus,
        'quantity': quantity,
        'tag': tag,
        'chainName': chainName
      };

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
        id: json['id'],
        tickerName: json['tickerName'] as String,
        address: json['address'] as String,
        amount: json['amount'].toString(),
        date: json['date'] as String,
        tickerChainTxId: json['tickerChainTxId'],
        kanbanTxId: json['kanbanTxId'] ?? '',
        tickerChainTxStatus: json['tickerChainTxStatus'] ?? '',
        kanbanTxStatus: json['kanbanTxStatus'],
        quantity: json['quantity'].toString(),
        tag: json['tag'],
        chainName: json['chainName']);
  }
}

class TransactionHistoryList {
  final List<TransactionHistory> transactions;
  TransactionHistoryList({this.transactions});

  factory TransactionHistoryList.fromJson(List<dynamic> parsedJson) {
    List<TransactionHistory> transactions = <TransactionHistory>[];
    transactions =
        parsedJson.map((i) => TransactionHistory.fromJson(i)).toList();
    return TransactionHistoryList(transactions: transactions);
  }
}
