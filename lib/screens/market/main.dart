import "package:flutter/material.dart";
import "widgets/overview.dart";
import "widgets/detail.dart";
import '../../utils/decoder.dart';
import 'package:web_socket_channel/io.dart';
import '../../models/price.dart';
import '../../services/trade_service.dart';

class Market extends StatefulWidget{
  Market({Key key}) : super(key: key);

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market>  with TradeService {
  final GlobalKey<MarketOverviewState> _marketOverviewState = new GlobalKey<MarketOverviewState>();
  final GlobalKey<MarketDetailState> _marketDetailState = new GlobalKey<MarketDetailState>();

  List<Price> prices;
  double randDouble;
  IOWebSocketChannel allPriceChannel;
  @override
  void initState() {
    super.initState();
    allPriceChannel = getAllPriceChannel();
    allPriceChannel.stream.listen(
            (prices) {
          _updatePrice(prices);
        }
    );
  }

  void _updatePrice(prices) {
    // print(prices);
    List<Price> list = Decoder.fromJsonArray(prices);
    for(var item in list) {
      item.open = item.open / 1e18;
      item.close = item.close / 1e18;
      item.volume = item.volume / 1e18;
      item.price = item.price / 1e18;
      item.high = item.high / 1e18;
      item.low = item.low / 1e18;
      item.change = 0.0;
      if(item.open > 0) {
        item.change = ((item.close - item.open) / item.open * 100 * 10).round() / 10;
      }
    }
    _marketOverviewState.currentState.updatePrices(list);
    _marketDetailState.currentState.updatePrices(list);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Color(0xff1f2233),
        body:ListView(
          children: <Widget>[
            MarketOverview(
                key: _marketOverviewState
            ),
            MarketDetail(
                key: _marketDetailState
            )

          ],
        )
    );
  }

  @override
  void dispose() {
    allPriceChannel.sink.close();
    super.dispose();
  }
}