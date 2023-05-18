import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_orders/my_order_model.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layouts/shimmer_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'my_orders_viewmodel.dart';

class MyOrdersView extends StatelessWidget {
  final String? tickerName;

  const MyOrdersView({Key? key, this.tickerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    return ViewModelBuilder<MyOrdersViewModel>.reactive(
        createNewViewModelOnInsert: true,
        fireOnModelReadyOnce: true,
        viewModelBuilder: () => MyOrdersViewModel(tickerName: tickerName),
        onModelReady: (model) {
          debugPrint('in init MyOrdersView');
          model.context = context;

          model.refreshController = _refreshController;
          model.init();
        },
        onDispose: (viewModel) {
          if (_refreshController != null) _refreshController.dispose();
          debugPrint('_refreshController disposed in wallet dashboard view');
        },

        // onDispose: () {
        //   if (_refreshController != null) _refreshController.dispose();
        //   debugPrint(‘_refreshController disposed in wallet dashboard view’);
        // },
        builder: (context, MyOrdersViewModel model, _) => Container(
            child:
                // error handling
                model.isFutureError
                    ? Container(
                        color: primaryColor.withAlpha(150),
                        padding: const EdgeInsets.all(25),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.serverError +
                                  ': ${model.errorMessage}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            IconButton(
                              icon: const Icon(Icons.replay),
                              color: white,
                              onPressed: () {
                                model.isFutureError = false;
                                debugPrint(
                                    'Running futures to run again to reset the hasError and try to get the data so that user can see the data with view instead of error screen');
                                model.swapSources(false);
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
                              //           debugPrint(
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
                                      AppLocalizations.of(context)!
                                          .showAllPairOrders,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6),
                                  Transform.scale(
                                    scale: 0.75,
                                    child: Switch.adaptive(
                                        activeColor: primaryColor,
                                        value: model.isShowAllOrders,
                                        onChanged: (bool v) {
                                          debugPrint('switch value $v');

                                          model.swapSources(v);
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
                                    labelPadding: const EdgeInsets.all(3),
                                    onTap: (int i) {},
                                    indicatorSize: TabBarIndicatorSize
                                        .tab, // model.showOrdersInTabView(i);
                                    indicator: BoxDecoration(
                                      color: Colors.redAccent,
                                      gradient: const LinearGradient(colors: [
                                        Colors.redAccent,
                                        Colors.orangeAccent
                                      ]),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    tabs: [
                                      Text(
                                          AppLocalizations.of(context)!
                                              .allOrders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .openOrders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          AppLocalizations.of(context)!
                                              .closedOrders,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Text(
                                          AppLocalizations.of(context)!
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
                                      margin: const EdgeInsets.all(5),
                                      child: model.isBusy
                                          ? const ShimmerLayout(
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      child: Row(children: <Widget>[
        // Expanded(
        //   flex: 1,
        //   child: Text('#', style: Theme.of(context).textTheme.subtitle2),
        // ),
        Expanded(
          flex: 1,
          child: Text(AppLocalizations.of(context)!.type,
              style: Theme.of(context).textTheme.subtitle2),
        ),
        Expanded(
            flex: 2,
            child: Text(AppLocalizations.of(context)!.pair,
                style: Theme.of(context).textTheme.subtitle2)),
        Expanded(
            flex: 2,
            child: Text(AppLocalizations.of(context)!.price,
                style: Theme.of(context).textTheme.subtitle2)),
        Expanded(
            flex: 2,
            child: Text(AppLocalizations.of(context)!.quantity,
                style: Theme.of(context).textTheme.subtitle2)),
        Expanded(
            flex: 2,
            child: Text(AppLocalizations.of(context)!.filledAmount,
                style: Theme.of(context).textTheme.subtitle2)),
        Expanded(
          flex: 1,
          child: Text(AppLocalizations.of(context)!.cancel,
              style: Theme.of(context).textTheme.subtitle2),
        ),
      ]),
    );
  }
}

class MyOrderDetailsView extends ViewModelWidget<MyOrdersViewModel> {
  final List<OrderModel>? orders;
  const MyOrderDetailsView({Key? key, this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context, MyOrdersViewModel model) {
    model.refreshController = RefreshController();
    return SmartRefresher(
      enablePullUp: true,
      header: Theme.of(context).platform == TargetPlatform.iOS
          ? const ClassicHeader()
          : const MaterialClassicHeader(),
      enablePullDown: true,
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = const Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = const Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text(AppLocalizations.of(context)!.releaseToLoadMore);
          } else {
            body = const Text("No more Data");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: model.refreshController,
      onRefresh: model.onRefresh,
      onLoading: model.onLoading,
      child: ListView.builder(
          itemCount: orders!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            var order = orders![index];
            return Row(
              children: [
                // Expanded(
                //     flex: 1,
                //     child: Text('${index + 1}',
                //         style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 1,
                    child: Text(
                        order.bidOrAsk!
                            ? AppLocalizations.of(context)!.buy
                            : AppLocalizations.of(context)!.sell,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Color(
                                  order.bidOrAsk! ? 0xFF0da88b : 0xFFe2103c),
                            ))),
                Expanded(
                    flex: 2,
                    child: Text(order.pairName.toString(),
                        style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 2,
                    child: Text(
                        order.price!
                            .toStringAsFixed(model.decimalConfig.priceDecimal!),
                        style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 2,
                    child: Text(
                        order.totalOrderQuantity!
                            .toStringAsFixed(model.decimalConfig.qtyDecimal!),
                        style: Theme.of(context).textTheme.headline6)),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                            order.filledQuantity!.toStringAsFixed(
                                model.decimalConfig.qtyDecimal!),
                            style: Theme.of(context).textTheme.headline6),
                        Text(
                            order.filledPercentage!.isNaN
                                ? '0.0%'
                                : '${order.filledPercentage!.toStringAsFixed(2)}%',
                            style: Theme.of(context).textTheme.subtitle2)
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: order.isActive!
                        ? model.isCancelling &&
                                //   model.busy(model.onClickOrderHash) &&
                                orders![index].orderHash ==
                                    model.onClickOrderHash
                            ? const CupertinoActivityIndicator()
                            : IconButton(
                                color: red,
                                icon: const Icon(
                                  Icons.close,
                                  size: 16,
                                ),
                                onPressed: () {
                                  debugPrint(index.toString());
                                  debugPrint(orders!.indexOf(order).toString());
                                  if (index == orders!.indexOf(order)) {
                                    debugPrint(
                                        'inside if ${index == orders!.indexOf(order)}');

                                    model.checkPass(context, order.orderHash);
                                  }
                                })
                        : IconButton(
                            disabledColor:
                                Theme.of(context).disabledColor.withAlpha(50),
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                            ),
                            onPressed: () {
                              debugPrint('cancelled orders');
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
