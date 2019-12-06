import 'package:http/http.dart' as http;
Future getFabTransactionStatus(String txid) async {
  var url = "https://fabtest.fabcoinapi.com/"  + 'gettransactionjson/' + txid;
  var client = new http.Client();
  var response = await client.get(url);
  return response;
}