import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:exchangilymobileapp/widgets/carousel.dart';
import 'package:exchangilymobileapp/widgets/loading_animation.dart';
import "package:flutter/material.dart";
import "widgets/overview.dart";
import "widgets/detail.dart";
import '../../utils/decoder.dart';
import 'package:web_socket_channel/io.dart';
import '../../models/price.dart';
import '../../services/trade_service.dart';
import '../../utils/string_util.dart';

class Market extends StatefulWidget {
  Market({Key key}) : super(key: key);

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> with TradeService {
  final GlobalKey<MarketOverviewState> _marketOverviewState =
      new GlobalKey<MarketOverviewState>();
  final GlobalKey<MarketDetailState> _marketDetailState =
      new GlobalKey<MarketDetailState>();

  List<Price> prices;
  double randDouble;
  IOWebSocketChannel allPriceChannel;

  //temp use for test
  final List<Map> images = [
    {"imgUrl": "https://images.unsplash.com/photo-1451187580459-43490279c0fa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1052&q=80"},
    {"imgUrl": "https://images.unsplash.com/photo-1561451213-d5c9f0951fdf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"},
    {"imgUrl": "https://images.unsplash.com/photo-1516245834210-c4c142787335?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"},
  ];

  @override
  void initState() {
    super.initState();
  }

  List<Price> _updatePrice(prices) {
    List<Price> list = Decoder.fromJsonArray(prices);
    for (var item in list) {
      item.open = bigNum2Double(item.open);
      item.close = bigNum2Double(item.close);
      item.volume = bigNum2Double(item.volume);
      item.price = bigNum2Double(item.price);
      item.high = bigNum2Double(item.high);
      item.low = bigNum2Double(item.low);
      item.change = 0.0;
      if (item.open > 0) {
        item.change =
            ((item.close - item.open) / item.open * 100 * 10).round() / 10;
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f2233),
      body: StreamBuilder(
        stream: getAllPriceChannel().stream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView(
                  children: <Widget>[
                    SizedBox(height:10),
                    Carousel(imageData:images),
                    SizedBox(height:10),
                    MarketOverview(
                        key: _marketOverviewState,
                        data: _updatePrice(snapshot.data)),
                    MarketDetail(
                        key: _marketDetailState,
                        data: _updatePrice(snapshot.data))
                  ],
                )
              : Loading();
        },
      ),
      // bottomNavigationBar: BottomNavBar(count: 1),
    );
  }

  @override
  void dispose() {
    allPriceChannel.sink.close();
    super.dispose();
  }
}
