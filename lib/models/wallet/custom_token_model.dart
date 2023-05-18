// symbol, logo, tokenId are probably what you want
// they are fab tokens like EXG
class CustomTokenModel {
  String? owner;
  String? name;
  String? symbol;
  String? logo;
  String? totalSupply;
  String? txid;
  String? tokenId; // smart contract address
  String? status;
  int? decimal;
  double? balance;

  CustomTokenModel(
      {this.owner,
      this.name,
      this.symbol,
      this.logo,
      this.totalSupply,
      this.txid,
      this.tokenId,
      this.status,
      this.decimal,
      this.balance});

  CustomTokenModel.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    name = json['name'];
    symbol = json['symbol'];
    logo = json['logo'];
    totalSupply = json['totalSupply'];
    txid = json['txid'];
    tokenId = json['tokenId'];
    status = json['status'];
    decimal = json['decimals'] ?? 18;
    balance = json['balance'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['owner'] = owner;
    data['name'] = name;
    data['symbol'] = symbol;
    data['logo'] = logo;
    data['totalSupply'] = totalSupply;
    data['txid'] = txid;
    data['tokenId'] = tokenId;
    data['status'] = status;
    data['decimals'] = decimal;
    data['balance'] = balance;
    return data;
  }
}

class CustomTokenModelList {
  final List<CustomTokenModel>? customTokens;
  CustomTokenModelList({this.customTokens});

  factory CustomTokenModelList.fromJson(List<dynamic> parsedJson) {
    List<CustomTokenModel> customTokens = [];
    customTokens = parsedJson.map((i) => CustomTokenModel.fromJson(i)).toList();
    return CustomTokenModelList(customTokens: customTokens);
  }
}
