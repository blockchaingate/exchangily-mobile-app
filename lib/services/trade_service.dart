import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'package:exchangilymobileapp/environments/environment.dart';
mixin TradeService {
  Future<int>  getAllPrices() async {
    final response =
    await http.get('https://jsonplaceholder.typicode.com/posts/1');
    return 1;
  }

  getAllPriceChannel() {
    return IOWebSocketChannel.connect(environment['websocket'] + 'allprices');
  }

  getOrderListChannel(String pair) {
    var wsString = environment['websocket'] + 'orders'+ '@' + pair;
    print('wsString=' + wsString);
    return IOWebSocketChannel.connect(wsString);
  }

}