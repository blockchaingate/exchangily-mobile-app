class OrderModel {
  bool payWithExg;
  String orderHash;
  String address;
  int pairLeft;
  int pairRight;
  int orderType;
  bool bidOrAsk;
  double price;
  double orderQuantity;
  double filledQuantity;
  int time;
  bool isActive;
  OrderModel(this.payWithExg, this.orderHash, this.address, this.pairLeft, this.pairRight, this.orderType, this.bidOrAsk, this.price, this.orderQuantity, this.filledQuantity, this.time, this.isActive);
}