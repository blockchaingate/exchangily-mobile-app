import 'package:http/http.dart' as http;
import 'dart:convert';

mixin KanbanService {
  getScarAddress() async{
    var url = 'https://kanbantest.fabcoinapi.com/' + 'exchangily/getExchangeAddress';
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }
}