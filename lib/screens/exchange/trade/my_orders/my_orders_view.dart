import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'my_order_viewmodel.dart';

class MyOrdersView extends StatelessWidget {
  final String tickerName;
  final bool isReload;
  MyOrdersView({Key key, this.tickerName, this.isReload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyOrdersViewModel>.reactive(
        viewModelBuilder: () =>
            MyOrdersViewModel(tickerName: tickerName, isReload: isReload),
        onModelReady: (model) {
          print('in init MyOrdersView, is reloading $isReload');
          model.context = context;
          model.init();
        },
        builder: (context, model, _) => Container(
            child:
                // error handling
                model.isFutureError
                    ? Container(
                        color: primaryColor.withAlpha(150),
                        padding: EdgeInsets.all(25),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context).serverError +
                                  ': ${model.errorMessage}',
                              style: TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: Icon(Icons.replay),
                              color: white,
                              onPressed: () {
                                model.isFutureError = false;
                                print(
                                    'Running futures to run again to reset the hasError and try to get the data so that user can see the data with view instead of error screen');
                                model.swapSources();
                              },
                            ),
                          ],
                        ),
                      )
                    // Layout
                    : Container(
                        child: DefaultTabController(
                          length: 4,
                          child: Column(
                            children: [
                              // Container(
                              //   color: primaryColor.withAlpha(150),
                              //   padding: EdgeInsets.all(25),
                              //   alignment: Alignment.center,
                              //   child: Column(
                              //     children: [
                              //       Text(
                              //         AppLocalizations.of(context).serverError +
                              //             ': ${model.errorMessage}',
                              //         style: TextStyle(color: Colors.white),
                              //       ),
                              //       IconButton(
                              //         icon: Icon(Icons.replay),
                              //         color: white,
                              //         onPressed: () {
                              //           model.isFutureError = false;
                              //           print(
                              //               'Running futures to run again to reset the hasError and try to get the data so that user can see the data with view instead of error screen');
                              //           model.swapSources1();
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Switch to show only current pair orders
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)
                                          .showAllPairOrders,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Transform.scale(
                                    scale: 0.75,
                                    child: Switch.adaptive(
                                        activeColor: primaryColor,
                                        value: model.isSwitch,
                                        onChanged: (bool v) {
                                          print('switch value $v');

                                          model.swapSources();
                                        }),
                                  ),
                                ],
                              ),
                              model.errorMessage.isNotEmpty
                                  ? Center(child: Text(model.errorMessage))
                                  : Container(),
                              // Order type tabs
                              Column(
                                children: <Widget>[
                                  TabBar(
                                    labelPadding: EdgeInsets.all(3),
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
                                              .closedOrders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          AppLocalizations.of(context)
                                              .cancelledOrders,
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
                                      child: model.isBusy
                                          ? ShimmerLayout(
                                              layoutType: 'marketTrades')
                                          : TabBarView(
                                              children: model.myOrdersTabBarView
                                                  .map((orders) {
                                                return Container(
                                                    child: MyOrderDetailsView(
                                                        orders: orders));
                                              }).toList(),
                                            )),
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
            child: Text(AppLocalizations.of(context).quantity,
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

class MyOrderDetailsView extends ViewModelWidget<MyOrdersViewModel> {
  final List<OrderModel> orders;
  const MyOrderDetailsView({Key key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context, MyOrdersViewModel model) {
    return SmartRefresher(
      enablePullUp: true,
      header: Theme.of(context).platform == TargetPlatform.iOS
          ? ClassicHeader()
          : MaterialClassicHeader(),
      enablePullDown: true,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text(AppLocalizations.of(context).releaseToLoadMore);
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: model.refreshController,
      onRefresh: model.onRefresh,
      onLoading: model.onLoading,
      child: ListView.builder(
          itemCount: orders.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            var order = orders[index];
            return Row(
              children: [
                // Expanded(
                //     flex: 1,
                //     child: Text('${index + 1}',
                //         style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 1,
                    child: Text(
                        order.bidOrAsk
                            ? AppLocalizations.of(context).buy
                            : AppLocalizations.of(context).sell,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              color: Color(
                                  (order.bidOrAsk) ? 0xFF0da88b : 0xFFe2103c),
                            ))),
                Expanded(
                    flex: 2,
                    child: Text(order.pairName.toString(),
                        style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 2,
                    child: Text(
                        order.price
                            .toStringAsFixed(model.decimalConfig.priceDecimal),
                        style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 2,
                    child: Text(
                        order.totalOrderQuantity.toStringAsFixed(
                            model.decimalConfig.quantityDecimal),
                        style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                            order.filledQuantity.toStringAsFixed(
                                model.decimalConfig.quantityDecimal),
                            style: Theme.of(context).textTheme.headline6),
                        Text(
                            order.filledPercentage.isNaN
                                ? '0.0%'
                                : '${order.filledPercentage.toStringAsFixed(2)}%',
                            style: Theme.of(context).textTheme.subtitle2)
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: order.isActive
                        ? model.isBusy &&
                                orders[index].orderHash ==
                                    model.onClickOrderHash
                            ? CupertinoActivityIndicator()
                            : IconButton(
                                color: red,
                                icon: Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                                onPressed: () {
                                  print(index);
                                  print(orders.indexOf(order));
                                  if (index == orders.indexOf(order)) {
                                    print(
                                        'inside if ${index == orders.indexOf(order)}');

                                    model.checkPass(context, order.orderHash);
                                  }
                                })
                        : IconButton(
                            disabledColor:
                                Theme.of(context).disabledColor.withAlpha(50),
                            icon: Icon(
                              Icons.close,
                              size: 16,
                            ),
                            onPressed: () {
                              print('closed orders');
                            }))
              ],
            );
          }),
    );
  }

  // @override
  // MyOrdersViewModel viewModelBuilder(BuildContext context) =>
  //     MyOrdersViewModel();
}
