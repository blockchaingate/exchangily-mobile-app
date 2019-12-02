import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getScarAddress() async{
  var url = 'https://kanbantest.fabcoinapi.com/' + 'kanban/getScarAddress';
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<String> getCoinPoolAddress() async{
  var url = 'https://kanbantest.fabcoinapi.com/' + 'exchangily/getCoinPoolAddress';
  var client = new http.Client();
  var response = await client.get(url);
  return response.body;
}

Future<double> getGas(String address) async {
  var url = 'https://kanbantest.fabcoinapi.com/' + 'kanban/getBalance/' + address;
  var client = new http.Client();
  var response = await client.get(url);
  var json = jsonDecode(response.body);
  var fab = json["balance"]["FAB"];
  return double.parse(fab);
}

Future<int> getNonce(String address) async{
  var url = 'https://kanbantest.fabcoinapi.com/' + 'kanban/getTransactionCount/' + address;
  var client = new http.Client();
  var response = await client.get(url);
  var json = jsonDecode(response.body);
  return json["transactionCount"];
}

Future<int> submitDeposit(String rawTransaction, String rawKanbanTransaction) async {
  var url = 'https://kanbantest.fabcoinapi.com/' + 'submitDeposit';
  var data = {
    'rawTransaction': rawTransaction,
    'rawKanbanTransaction': rawKanbanTransaction
  };

  print('rawTransaction:' + rawTransaction);
  print('rawKanbanTransaction:' + rawKanbanTransaction);
  var client = new http.Client();
  var response = await client.post(url, body: data);
  print('response from submitDeposit');
  print(response.body);
  return 0;
}