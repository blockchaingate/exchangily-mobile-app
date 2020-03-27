class CampaignOrder {
  String _orderId;
  String _orderNumber;
  String _walletAdd; // Wallet EXG address
  String _statuis;
  String _txid;
  double _amount;
  String _paymentType;
  String _note;
  String _officialNote;
  bool _active;
  String _createdTime;

  CampaignOrder({  String orderId,
  String orderNumber,
  String walletAdd, // Wallet EXG address
  String statuis,
  String txid,
  double amount,
  String paymentType,
  String note,
  String officialNote,
  bool active,
  String createdTime,})
}
