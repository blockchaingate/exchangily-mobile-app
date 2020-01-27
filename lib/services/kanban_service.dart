import 'package:http/http.dart' as http;
import 'dart:convert';
import '../environments/environment.dart';
mixin KanbanService {
  getScarAddress() async{
    var url = environment['endpoints']['kanban'] + 'exchangily/getExchangeAddress';
    var client = new http.Client();
    var response = await client.get(url);
    var json = jsonDecode(response.body);
    return json;
  }
}