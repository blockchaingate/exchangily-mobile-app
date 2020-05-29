import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class TradeView extends StatelessWidget {
  final String tickerName;
  TradeView({Key key, this.tickerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(tickerName);
    return ViewModelBuilder<TradeViewModal>.reactive(
        createNewModelOnInsert: true,
        onModelReady: (model) {
          print('1');
          print(model.tickerName);
          model.tickerName = tickerName;
          print('2');
          print(model.tickerName);
        },
        builder: (context, model, _) => Scaffold(
              appBar: AppBar(title: Text(tickerName), centerTitle: true),
              body: Container(
                child: Text('In trade'),
              ),
            ),
        viewModelBuilder: () => TradeViewModal());
  }
}
