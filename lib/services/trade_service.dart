import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'dart:async';
mixin TradeService {
  Future<int>  getAllPrices() async {
    final response =
    await http.get('https://jsonplaceholder.typicode.com/posts/1');
    return 1;
  }

  getAllPriceChannel() {
    return IOWebSocketChannel.connect('ws://18.223.17.4:3002/ws/allprices');
  }
  getOrderListChannel(String pair) {
    var wsString = 'ws://18.223.17.4:3002/ws/orders'+ '@' + pair;
    print('wsString=' + wsString);
    return IOWebSocketChannel.connect(wsString);
  }
}