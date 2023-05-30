import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/screens/exchange/markets/price_model.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/buy_sell/buy_sell_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/my_exchange_assets/my_exchange_assets_view.dart';

import 'package:exchangilymobileapp/screens/exchange/trade/pair_price_view.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trade_viewmodel.dart';
import 'package:exchangilymobileapp/screens/exchange/trade/trading_chart/trading_chart_view.dart';

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/shimmer_layouts/shimmer_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';

import 'market_trades/market_trades_view.dart';
import 'my_orders/my_orders_view.dart';
import 'orderbook/orderbook_view.dart';
import 'package:flutter/cupertino.dart';

class TradeView extends StatelessWidget {
  final Price? pairPriceByRoute;
  TradeView({Key? key, this.pairPriceByRoute}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TradeViewModel>.reactive(
        disposeViewModel: true,
        fireOnViewModelReadyOnce: true,
        // passing tickername in the constructor of the viewmodal so that we can pass it to the streamMap
        // which is required override
        viewModelBuilder: () =>
            TradeViewModel(pairPriceByRoute: pairPriceByRoute),
        onViewModelReady: (model) {
          model.context = context;
          model.init();
        },
        builder: (context, model, _) => WillPopScope(
              onWillPop: () async {
                model.onBackButtonPressed();
                return Future(() => false);
              },
              child: Scaffold(
                // endDrawerEnableOpenDragGesture: true,
                // endDrawer:
                //     Drawer(child: Container(child: SettingsPortableView())),
                key: _scaffoldKey,
                appBar: AppBar(
                    //actions: [
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.settings,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: () {
                    //     _scaffoldKey.currentState.openEndDrawer();
                    //   },
                    // ),
                    //  ],
                    backgroundColor: primaryColor.withOpacity(0.25),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        model.onBackButtonPressed();
                      },
                    ),
                    title: Text(
                      model.updateTickerName(pairPriceByRoute!.symbol!),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    centerTitle: true,
                    automaticallyImplyLeading: false),
                // drawer: Container(
                //     margin: EdgeInsets.only(top: 10),
                //     child: Stack(overflow: Overflow.visible, children: [
                //       Align(
                //         alignment: Alignment.topCenter,
                //         child: Container(
                //           child: model.dataReady('allPrices')
                //               ? MarketPairsTabView(
                //                   marketPairsTabBarView:
                //                       model.marketPairsTabBar,
                //                   isBusy: false,
                //                 )
                //               : Container(
                //                   child: Center(
                //                     child: Text(
                //                         AppLocalizations.of(context).loading),
                //                   ),
                //                 ),
                //         ),
                //       ),
                //       // Close button position bottom right
                //       Positioned(
                //           bottom: 0,
                //           right: 0,
                //           child: Container(
                //             padding: EdgeInsets.all(5),
                //             decoration: BoxDecoration(
                //                 color: red,
                //                 borderRadius: BorderRadius.only(
                //                     topLeft: Radius.circular(90),
                //                     bottomLeft: Radius.circular(1))),
                //             child: Padding(
                //               padding:
                //                   const EdgeInsets.only(left: 8.0, top: 8.0),
                //               child: IconButton(
                //                 icon: Icon(
                //                   Icons.close,
                //                   color: white,
                //                   size: 30,
                //                 ),
                //                 onPressed: () {
                //                   model.resumeAllStreams();
                //                   model.navigationService.goBack();
                //                 },
                //               ),
                //             ),
                //           )),
                //       // Icon(Icons.access_alarm)
                //     ])),

                body: model.isStreamDataNull || model.hasError
                    ? Center(
                        child: Text(
                          FlutterI18n.translate(context, "serverError"),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : model.isBusy && model.isDisposing
                        ? Center(
                            child: model.sharedService!.loadingIndicator(),
                          )
                        : ListView(shrinkWrap: true, children: [
                            /// Ticker price stream
                            Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: PairPriceView(
                                pairPrice: model.hasStreamTickerData
                                    ? model.currentPairPrice
                                    : model.pairPriceByRoute,
                                isBusy: !model.hasStreamTickerData,
                                decimalConfig: model.singlePairDecimalConfig,
                                usdValue: model.usdValue,
                              ),
                            ),

                            //  Below container contains trading view chart in the trade tab
                            //   model.currentPairPrice == null

                            model.currentPairPrice.price == 0.0
                                ? Container(
                                    color: Theme.of(context)
                                        .canvasColor
                                        .withAlpha(155),
                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                    height: 280,
                                    child: const Center(
                                        child: CupertinoActivityIndicator()))
                                : LoadHTMLFileToWEbView(
                                    model.updateTickerName(
                                        pairPriceByRoute!.symbol!),
                                  ),
                            //: CircularProgressIndicator(),
                            // Text(model.interval),
                            // Text(model.isTradingChartModelBusy.toString()),

                            // UIHelper.verticalSpaceMedium,
                            DefaultTabController(
                              length: 4,
                              //ordersViewTabBody.length,
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TabBar(
                                        labelPadding:
                                            const EdgeInsets.only(bottom: 5),
                                        onTap: (int tabIndex) {
                                          //  model.switchStreams(tabIndex);
                                        },
                                        indicatorColor: primaryColor,
                                        indicatorSize: TabBarIndicatorSize.tab,
                                        // Tab Names

                                        tabs: [
                                          Text(
                                              FlutterI18n.translate(
                                                  context, "orderBook"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decorationThickness: 3)),
                                          Text(
                                              FlutterI18n.translate(
                                                  context, "marketTrades"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decorationThickness: 3)),
                                          Text(
                                              FlutterI18n.translate(
                                                  context, "myOrders"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decorationThickness: 3)),
                                          Text(
                                              FlutterI18n.translate(
                                                  context, "assets"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decorationThickness: 3)),
                                        ]),
                                    UIHelper.verticalSpaceSmall,
                                    // Tabs view container
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.60,
                                      child: TabBarView(
                                        children: [
                                          // order book container
                                          Container(
                                            child: !model.hasStreamOrderbook
                                                ? const ShimmerLayout(
                                                    layoutType: 'orderbook',
                                                  )
                                                : OrderBookView(
                                                    orderbook: model.orderbook,
                                                    decimalConfig: model
                                                        .singlePairDecimalConfig,
                                                    isVerticalOrderbook: false,
                                                  ),
                                          ),

                                          // Market trades
                                          Container(
                                            child: !model.hasStreamMarketTrades
                                                ? const ShimmerLayout(
                                                    layoutType: 'marketTrades',
                                                  )
                                                : MarketTradesView(
                                                    marketTrades:
                                                        model.marketTradesList,
                                                    decimalConfig: model
                                                        .singlePairDecimalConfig),
                                          ),

                                          MyOrdersView(
                                              tickerName:
                                                  pairPriceByRoute!.symbol),
                                          // My Exchange Asssets
                                          // model.busy(model.myExchangeAssets)
                                          //     ? Container(
                                          //         margin:
                                          //             EdgeInsets.symmetric(
                                          //                 horizontal: 5.0,
                                          //                 vertical: 5),
                                          //         height: 150,
                                          //         child: ShimmerLayout(
                                          //           layoutType:
                                          //               'marketTrades',
                                          //         ),
                                          //       )
                                          //     :
                                          const MyExchangeAssetsView()
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ]),

                // Floatin Button buy/sell
                // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                // floatingActionButton:
                // bottomNavigationBar: BottomNavBar(count: 1),
                bottomNavigationBar: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(bottom: 15),
                    width: 160,
                    //margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        //Add Favorite
                        // Flexible(
                        //     flex: 2,
                        //     child: Container(
                        //       margin: EdgeInsets.only(right: 2.0),
                        //       child: FlatButton(
                        //         padding: EdgeInsets.all(0),
                        //         color: buyPrice,
                        //         onPressed: () {
                        //           Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //                 builder: (context) => BuySell(
                        //                     pair: model.currentPairPrice.symbol,
                        //                     bidOrAsk: true)),
                        //           );
                        //         },
                        //         child: Text(AppLocalizations.of(context).buy,
                        //             style:
                        //                 TextStyle(fontSize: 13, color: white)),
                        //       ),
                        //     )),
                        // Buy Button
                        Flexible(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.only(right: 2.0),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: buyPrice,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: const BorderSide(
                                          color: buyPrice, width: 1)),
                                ),
                                onPressed: () {
                                  if (!model.isBusy) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BuySellView(
                                            pairSymbolWithSlash:
                                                model.pairSymbolWithSlash,
                                            bidOrAsk: true,
                                            tickerName:
                                                pairPriceByRoute!.symbol),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  FlutterI18n.translate(context, "buy"),
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                              ),
                            )),
                        // Sell button
                        const SizedBox(width: 5),
                        Flexible(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!model.isBusy) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BuySellView(
                                            //  orderbook: model.orderbook,
                                            pairSymbolWithSlash:
                                                model.pairSymbolWithSlash,
                                            bidOrAsk: false,
                                            tickerName:
                                                pairPriceByRoute!.symbol)),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: sellPrice,
                                shape: const StadiumBorder(
                                  side: BorderSide(
                                    color: sellPrice,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                FlutterI18n.translate(context, "sell"),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                      ],
                    )),
              ),
            ));
  }
}
