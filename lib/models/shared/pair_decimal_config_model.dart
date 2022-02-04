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
    _priceDecimal = priceDecimal ?? 4;
    _qtyDecimal = qtyDecimal ?? 6;

    _name = name;
  }

  Map<String, dynamic> toJson() =>
      {'name': _name, 'priceDecimal': _priceDecimal, 'qtyDecimal': _qtyDecimal};

  factory PairDecimalConfig.fromJson(Map<String, dynamic> json) {
    return PairDecimalConfig(
        name: json['name'],
        priceDecimal: json['priceDecimal'],
        qtyDecimal: json['qtyDecimal']);
  }

  int get priceDecimal => _priceDecimal;
  set priceDecimal(int priceDecimal) {
    _priceDecimal = priceDecimal;
  }

  int get qtyDecimal => _qtyDecimal;

  set qtyDecimal(int qtyDecimal) {
    _qtyDecimal = qtyDecimal;
  }

  String get name => _name;

  set name(String name) {
    _name = name;
  }
}

class PairDecimalConfigList {
  final List<PairDecimalConfig> pairList;
  PairDecimalConfigList({this.pairList});

  factory PairDecimalConfigList.fromJson(List<dynamic> parsedJson) {
    List<PairDecimalConfig> pairList = <PairDecimalConfig>[];
    pairList = parsedJson.map((i) => PairDecimalConfig.fromJson(i)).toList();
    return PairDecimalConfigList(pairList: pairList);
  }
}
