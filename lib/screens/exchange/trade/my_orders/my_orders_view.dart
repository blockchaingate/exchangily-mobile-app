import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'my_order_details_view.dart';
import 'my_order_viewmodel.dart';

class MyOrdersView extends StatelessWidget {
  //final List<OrderModel> myOrders;
  const MyOrdersView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyOrdersViewModel>.reactive(
        viewModelBuilder: () => MyOrdersViewModel(),
        onModelReady: (model) {
          print('in init MyOrdersLayoutView');
        },
        builder: (context, model, _) => Container(
            child:
                // error handling
                model.hasError
                    ? Container(
                        color: Colors.red.withAlpha(150),
                        padding: EdgeInsets.all(25),
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
                        child: DefaultTabController(
                          length: 4,
                          child: Column(
                            children: [
                              UIHelper.verticalSpaceSmall,
                              // Order type tabs
                              Column(
                                children: <Widget>[
                                  TabBar(
                                    onTap: (int i) {
                                      // model.showOrdersInTabView(i);
                                    },
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicator: BoxDecoration(
                                      color: Colors.redAccent,
                                      gradient: LinearGradient(colors: [
                                        Colors.redAccent,
                                        Colors.orangeAccent
                                      ]),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    tabs: [
                                      Text(
                                          AppLocalizations.of(context)
                                              .allOrders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          AppLocalizations.of(context)
                                              .openOrders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          AppLocalizations.of(context)
                                              .closeOrders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(AppLocalizations.of(context).assets,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6)
                                    ],
                                    indicatorColor: Colors.white,
                                  ),
                                  UIHelper.verticalSpaceSmall,
                                  // header
                                  priceFieldsHeadersRow(context),

                                  // Tab bar view container
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.40,
                                      margin: EdgeInsets.all(5),

                                      //height: 330,
                                      child: TabBarView(
                                        children: [
                                          MyOrderDetailsView(),
                                          MyOrderDetailsView(),
                                          MyOrderDetailsView(),
                                          AssetBalance()
                                        ],
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      )));
  }

// Price fields headers row
  Container priceFieldsHeadersRow(BuildContext context) {
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

class AssetBalance extends StatelessWidget {
  const AssetBalance({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(''),
    );
  }
}
