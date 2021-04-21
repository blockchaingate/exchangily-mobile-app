class CampaignParticipate {
  String id;
  String walletAdd;
  int amount;
  String currency;
  String dateCreated;
  int status;
  int v;
  int campaginId;

  CampaignParticipate(
      {this.id,
      this.walletAdd,
      this.amount,
      this.currency,
      this.dateCreated,
      this.status,
      this.v,
      this.campaginId});

  factory CampaignParticipate.fromJson(Map<String, dynamic> json) {
    return CampaignParticipate(
        id: json['_id'] as String,
        walletAdd: json['walletAdd'] as String,
        amount: json['amount'] as int,
        currency: json['currency'] as String,
        dateCreated: json['dateCreated'] as String,
        status: json['status'] as int,
        v: json['__v'] as int,
        campaginId: json['campaginId'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'walletAdd': walletAdd,
      'amount': amount,
      'currency': currency,
      'dateCreated': dateCreated,
      'status': status,
      '__v': v,
      'campaginId': campaginId
    };
  }
}
