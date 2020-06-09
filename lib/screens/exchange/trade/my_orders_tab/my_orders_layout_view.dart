import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/trade/order-model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders_tab/my_order_viewmodel.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'my_order_details_view.dart';

class MyOrdersLayoutView extends StatelessWidget {
  //final List<OrderModel> myOrders;
  const MyOrdersLayoutView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyOrdersViewModel>.reactive(
        // passing tickername in the constructor of the viewmodal so that we can pass it to the streamMap
        // which is required override
        viewModelBuilder: () => MyOrdersViewModel(),
        onModelReady: (model) {
          print('in init MyOrdersView');
        },
        builder: (context, model, _) => Container(
            child:
                // error handling
                model.hasError
                    ? Container(
                        color: Colors.red,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              'An error has occered while fetching orders: ${model.errorMessage}',
                              style: TextStyle(color: Colors.white),
                            ),
                            FlatButton(
                                onPressed: () {
                                  model.futureToRun();
                                },
                                child: Text('Reload'))
                          ],
                        ),
                      )
                    // Layout
                    : Container(
                        child: Column(
                          children: [
                            priceFieldsRow(context),
                            Expanded(
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: MyOrderDetailsView())),
                          ],
                        ),
                      )));
  }

// Price fields row
  Container priceFieldsRow(BuildContext context) {
    return Container(
      color: walletCardColor,
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: Row(children: <Widget>[
        Expanded(
          flex: 1,
          child: Text('#', style: Theme.of(context).textTheme.subtitle2),
        ),
        Expanded(
          flex: 1,
          child: Text(AppLocalizations.of(context).type,
              style: Theme.of(context).textTheme.subtitle2),
        ),
        Expanded(
            flex: 2,
            child: Text(AppLocalizations.of(context).pair,
                style: Theme.of(context).textTheme.subtitle2)),
        Expanded(
            flex: 2,
            child: Text(AppLocalizations.of(context).price,
                style: Theme.of(context).textTheme.subtitle2)),
        Expanded(
            flex: 2,
            child: Text(AppLocalizations.of(context).filledAmount,
                style: Theme.of(context).textTheme.subtitle2)),
        Expanded(
          flex: 1,
          child: Text(AppLocalizations.of(context).cancel,
              style: Theme.of(context).textTheme.subtitle2),
        ),
      ]),
    );
  }
}
