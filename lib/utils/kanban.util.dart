import 'package:http/http.dart' as http;
import 'dart:convert';
import '../environments/environment.dart';

Future<String> getScarAddress() async{
  var url = environment['endpoints']['kanban'] + 'kanban/getScarAddress';
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<String> getCoinPoolAddress() async{
  var url = environment['endpoints']['kanban'] + 'exchangily/getCoinPoolAddress';
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<String> getExchangilyAddress() async{
  var url = environment['endpoints']['kanban'] + 'exchangily/getExchangeAddress';
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<double> getGas(String address) async {
  var url = environment['endpoints']['kanban'] + 'kanban/getBalance/' + address;
  var client = new http.Client();
  var response = await client.get(url);
  var json = jsonDecode(response.body);
  var fab = json["balance"]["FAB"];
  return double.parse(fab);
}

Future<int> getNonce(String address) async{
  var url = environment['endpoints']['kanban'] + 'kanban/getTransactionCount/' + address;
  var client = new http.Client();
  var response = await client.get(url);
  var json = jsonDecode(response.body);
  return json["transactionCount"];
}

Future<Map<String, dynamic>> submitDeposit(String rawTransaction, String rawKanbanTransaction) async {
  var url = environment['endpoints']['kanban'] + 'submitDeposit';
  var data = {
    'rawTransaction': rawTransaction,
    'rawKanbanTransaction': rawKanbanTransaction
  };

  print('rawTransaction:' + rawTransaction);
  print('rawKanbanTransaction:' + rawKanbanTransaction);
  var client = new http.Client();
  var response = await client.post(url, body: data);
  print('response from submitDeposit');
  Map<String, dynamic> res = jsonDecode(response.body);
  print(res);
  return res;
}

Future<Map<String, dynamic>> sendKanbanRawTransaction(String rawKanbanTransaction) async {
  var url = environment['endpoints']['kanban'] + 'kanban/sendRawTransaction';
  var data = {
    'signedTransactionData': rawKanbanTransaction
  };

  try {
    var client = new http.Client();
    var response = await client.post(url, body: data);
    print('response from submitDeposit');
    Map<String, dynamic> res = jsonDecode(response.body);
    return res;
  } catch(e) {
    return e;
  }
}