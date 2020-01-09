class TradeModel {
  String orderHash1;
  String orderHash2;
  double price;
  double amount;
  int blockNumber;
  int time;
  bool bidOrAsk;
  TradeModel(this.orderHash1, this.orderHash2, this.price, this.amount, this.blockNumber, this.time, this.bidOrAsk);
}