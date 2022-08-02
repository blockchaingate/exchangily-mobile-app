class Transactions {
  String chain;
  String transactionId;
  String timestamp;
  String status;

  Transactions({
    this.chain,
    this.transactionId,
    this.timestamp,
    this.status,
  });

  @override
  String toString() {
    return 'Transactions(chain: $chain, transactionId: $transactionId, timestamp: $timestamp, status: $status)';
  }

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      chain: json['chain'] as String,
      transactionId: json['transactionId'] as String,
      timestamp: json['timestamp'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chain': chain,
      'transactionId': transactionId,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
