import 'package:http/http.dart' as http;
Future getBtcTransactionStatus(String txid) async {
  var url = "https://btctest.fabcoinapi.com/"  + 'gettransactionjson/' + txid;
  var client = new http.Client();
  var response = await client.get(url);
  return response;
}