import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_exchange_assets_view.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';

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
        disposeViewModel: false,
        viewModelBuilder: () => MyOrdersViewModel(),
        onModelReady: (model) {
          print('in init MyOrdersView');

          model.myOrdersTabBarView = [
            model.myAllOrders,
            model.myOpenOrders,
            model.myCloseOrders
          ];
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
                                child: Text(AppLocalizations.of(context).reload))
                          ],
                        ),
                      )
                    // Layout
                    : Container(
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              UIHelper.verticalSpaceSmall,
                              // Order type tabs
                              Column(
                                children: <Widget>[
                                  TabBar(
                                    onTap: (int i) {},
                                    indicatorSize: TabBarIndicatorSize
                                        .tab, // model.showOrdersInTabView(i);
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
                                      child:
                                          //  !model.dataReady
                                          //     ? ShimmerLayout(
                                          //         layoutType: 'marketTrades')
                                          //     :
                                          TabBarView(
                                        children: model.myOrdersTabBarView
                                            .map((orders) {
                                          return Container(
                                              child: MyOrderDetailsView(
                                                  orders: orders));
                                        }).toList(),
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
