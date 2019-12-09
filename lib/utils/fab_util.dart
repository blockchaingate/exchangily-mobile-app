import 'package:http/http.dart' as http;
import '../environments/environment.dart';
Future getFabTransactionStatus(String txid) async {
  var url = "https://fabtest.fabcoinapi.com/"  + 'gettransactionjson/' + txid;
  var client = new http.Client();
  var response = await client.get(url);
  return response;
}

getFabNode(root) {
  var node = root.derivePath("m/44'/" + environment["CoinType"]["FAB"].toString() + "'/0'/0/0");
  return node;
}