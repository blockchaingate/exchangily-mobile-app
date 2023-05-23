import 'package:exchangilymobileapp/screens/exchange/trade/my_exchange_assets/my_exchange_assets_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';

import 'package:exchangilymobileapp/widgets/shimmer_layouts/shimmer_layout.dart';
import 'package:stacked/stacked.dart';


class MyExchangeAssetsView extends StatelessWidget {
  const MyExchangeAssetsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      //createNewModelOnInsert: true,
      onViewModelReady: (MyExchangeAssetsViewModel model) {
        model.context = context;

        model.init();
      },
      viewModelBuilder: () => MyExchangeAssetsViewModel(),
      builder: (context, MyExchangeAssetsViewModel model, _) =>
          //   DefaultTabController(
          // length: 2,
          // child: NestedScrollView(
          //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          //     return <Widget>[
          //       SliverPersistentHeader(
          //           pinned: true,
          //           delegate: SliverAppBarDelegate(
          //             TabBar(
          //                 padding: EdgeInsets.zero,
          //                 labelPadding: EdgeInsets.zero,
          //                 indicatorPadding: EdgeInsets.zero,
          //                 onTap: (int tabIndex) {
          //                   model.updateTabSelection(tabIndex);
          //                 },
          //                 labelColor: white,
          //                 indicatorColor: primaryColor,
          //                 indicatorSize: TabBarIndicatorSize.tab,
          //                 tabs: const [
          //                   Tab(
          //                     text: 'Balances',
          //                     icon: Icon(
          //                       FontAwesomeIcons.exchangeAlt,
          //                       size: 18,
          //                       color: white,
          //                     ),
          //                     iconMargin: EdgeInsets.only(bottom: 3),
          //                   ),
          //                   Tab(
          //                     icon: Icon(
          //                       FontAwesomeIcons.lock,
          //                       size: 16,
          //                     ),
          //                     text: 'Locker',
          //                     iconMargin: EdgeInsets.only(bottom: 3),
          //                   ),
          //                 ]),
          //           ))
          //     ];
          //   },
          //   body:
          Container(
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.only(top: 0),
              child:
                  // TabBarView(
                  //   children: [
                  //     Column(
                  //       children: [
                  //         UIHelper.verticalSpaceSmall,
                  //         Container(
                  //           color: walletCardColor,
                  //           padding: const EdgeInsets.all(10.0),
                  //           child: Row(children: <Widget>[
                  //             UIHelper.horizontalSpaceSmall,
                  //             Expanded(
                  //               flex: 1,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(left: 5),
                  //                 child: Text(AppLocalizations.of(context).symbol,
                  //                     style: Theme.of(context).textTheme.subtitle2),
                  //               ),
                  //             ),
                  //             UIHelper.horizontalSpaceSmall,
                  //             Expanded(
                  //               flex: 1,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(left: 5),
                  //                 child: Text(AppLocalizations.of(context).coin,
                  //                     style: Theme.of(context).textTheme.subtitle2),
                  //               ),
                  //             ),
                  //             UIHelper.horizontalSpaceSmall,
                  //             Expanded(
                  //               flex: 2,
                  //               child: Padding(
                  //                 padding: const EdgeInsets.only(left: 5),
                  //                 child: Text(
                  //                     AppLocalizations.of(context)
                  //                         .updatedAmountTranslation,
                  //                     style: Theme.of(context).textTheme.subtitle2),
                  //               ),
                  //             ),
                  //             Expanded(
                  //                 flex: 2,
                  //                 child: Text(
                  //                     AppLocalizations.of(context).lockedAmount,
                  //                     style: Theme.of(context).textTheme.subtitle2)),
                  //           ]),
                  //         ),
                  model.busy(model.exchangeBalances)
                      //&&
                      //   model.currentTabSelection == 0
                      ? const ShimmerLayout(
                          layoutType: 'marketTrades',
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: model.exchangeBalances!.length,
                          itemBuilder: (BuildContext context, int index) {
                            String tickerName =
                                model.exchangeBalances![index].ticker!;
                            return Row(
                              children: [
                                UIHelper.horizontalSpaceSmall,
                                // Card logo container
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7),
                                      //  margin: EdgeInsets.only(right: 10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      width: 35,
                                      height: 35,
                                      child:
                                          // Image.asset(
                                          // 'assets/images/wallet-page/${tickerName.toLowerCase()}.png') ??
                                          Image.network('${model.logoUrl}${tickerName.toLowerCase()}.png')),
                                ),
                                UIHelper.horizontalSpaceSmall,
                                UIHelper.horizontalSpaceSmall,
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                          model
                                              .exchangeBalances![index].ticker!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    )),
                                UIHelper.horizontalSpaceSmall,
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        model.exchangeBalances![index]
                                            .unlockedAmount
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge)),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                        model.exchangeBalances![index]
                                            .lockedAmount
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge))
                              ],
                            );
                          })
              // ],
              //  ),
              // lockers
              //  Center(child: Text('Lockers Data'))
              //Expanded(child: LockerBalanceWidget())
              // ],
              //  ),
              ),
      //  ),
      //)),
    );
  }
}
