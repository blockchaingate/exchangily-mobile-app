import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodal.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';

class TradeView extends StatelessWidget {
  final String tickerName;
  TradeView({Key key, this.tickerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TradeViewModal>.reactive(
      // passing tickername in the constructor of the viewmodal so that we can pass it to the streamMap
      // which is required override
      viewModelBuilder: () => TradeViewModal(tickerName: tickerName),
      onModelReady: (model) {
        model.context = context;
      },
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
            title: FlatButton.icon(
                textColor: Colors.white,
                onPressed: () {
                  model.showBottomSheet();
                },
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                label: Text(tickerName)),
            centerTitle: true,
            automaticallyImplyLeading: false),
        body: Container(
          child: Text('In trade'),
        ),
        bottomNavigationBar: BottomNavBar(count: 1),
      ),
    );
  }
}
