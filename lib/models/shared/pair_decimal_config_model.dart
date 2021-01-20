// Pair decimal config

class PairDecimalConfig {
  String _name;
  int _priceDecimal;
  int _qtyDecimal;

  PairDecimalConfig({
    String name,
    int priceDecimal,
    int qtyDecimal,
  }) {
    this._priceDecimal = priceDecimal ?? 0;
    this._qtyDecimal = qtyDecimal ?? 0;

    this._name = name;
  }

  Map<String, dynamic> toJson() =>
      {'name': _name, 'priceDecimal': _priceDecimal, 'qtyDecimal': _qtyDecimal};

  factory PairDecimalConfig.fromJson(Map<String, dynamic> json) {
    return new PairDecimalConfig(
        name: json['name'],
        priceDecimal: json['priceDecimal'],
        qtyDecimal: json['qtyDecimal']);
  }

  int get priceDecimal => _priceDecimal;
  set priceDecimal(int priceDecimal) {
    this._priceDecimal = priceDecimal;
  }

  int get qtyDecimal => _qtyDecimal;

  set qtyDecimal(int qtyDecimal) {
    this._qtyDecimal = qtyDecimal;
  }

  String get name => _name;

  set name(String name) {
    this._name = name;
  }
}

class PairDecimalConfigList {
  final List<PairDecimalConfig> pairList;
  PairDecimalConfigList({this.pairList});

  factory PairDecimalConfigList.fromJson(List<dynamic> parsedJson) {
    List<PairDecimalConfig> pairList = new List<PairDecimalConfig>();
    pairList = parsedJson.map((i) => PairDecimalConfig.fromJson(i)).toList();
    return new PairDecimalConfigList(pairList: pairList);
  }
}
