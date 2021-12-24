// symbol, logo, tokenId are probably what you want
// they are fab tokens like EXG
class IssueTokenModel {
  String owner;
  String name;
  String symbol;
  String logo;
  String totalSupply;
  String txid;
  String tokenId; // smart contract address
  String status;
  int decimal;

  IssueTokenModel(
      {this.owner,
      this.name,
      this.symbol,
      this.logo,
      this.totalSupply,
      this.txid,
      this.tokenId,
      this.status,
      this.decimal}) {
    this.decimal ?? 18;
  }

  IssueTokenModel.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    name = json['name'];
    symbol = json['symbol'];
    logo = json['logo'];
    totalSupply = json['totalSupply'];
    txid = json['txid'];
    tokenId = json['tokenId'];
    status = json['status'];
    decimal = json['decimal'] ?? 18;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner'] = this.owner;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['logo'] = this.logo;
    data['totalSupply'] = this.totalSupply;
    data['txid'] = this.txid;
    data['tokenId'] = this.tokenId;
    data['status'] = this.status;
    data['decimal'] = this.decimal;
    return data;
  }
}

class IssueTokenModelList {
  final List<IssueTokenModel> issueTokens;
  IssueTokenModelList({this.issueTokens});

  factory IssueTokenModelList.fromJson(List<dynamic> parsedJson) {
    List<IssueTokenModel> issueTokens = [];
    issueTokens = parsedJson.map((i) => IssueTokenModel.fromJson(i)).toList();
    return IssueTokenModelList(issueTokens: issueTokens);
  }
}
