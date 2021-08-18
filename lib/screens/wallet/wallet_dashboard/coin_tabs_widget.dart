import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_dashboard/coin_details_card_widget.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WalletDashboardCoinsTabWidget extends StatelessWidget {
  final WalletDashboardViewModel model;
  const WalletDashboardCoinsTabWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        initialIndex: model.currentTabSelection,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TabBar(
              labelPadding: EdgeInsets.only(bottom: 5),
              onTap: (int tabIndex) {
                model.updateTabSelection(tabIndex);
              },
              indicatorColor: primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              // Tab Names

              tabs: [
                Icon(
                  FontAwesomeIcons.coins,
                  color: white,
                  size: 16,
                ),
                // Text(
                //     AppLocalizations.of(context)
                //         .allAssets,
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyText1
                //         .copyWith(
                //             fontWeight: FontWeight.w500,
                //             decorationThickness: 3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: primaryColor, size: 18),
                  ],
                ),
              ]),
          UIHelper.verticalSpaceSmall,
          // Tabs view container
          Container(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                // All coins tab
                model.isBusy
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.walletInfoCopy.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WalletDashboardCoinsDetailsCardWidget(
                            index: index,
                            wallets: model.walletInfoCopy,
                          );
                        },
                      )
                    : SmartRefresher(
                        enablePullDown: true,
                        header: Theme.of(context).platform == TargetPlatform.iOS
                            ? ClassicHeader()
                            : MaterialClassicHeader(),
                        controller: model.refreshController,
                        onRefresh: model.onRefresh,
                        // child: NotificationListener<
                        //         ScrollEndNotification>(
                        //     onNotification:
                        //         (scrollEnd) {
                        //       var metrics =
                        //           scrollEnd.metrics;
                        //       if (metrics.atEdge) {
                        //         if (metrics.pixels == 0)
                        //           print('At top');
                        //         else
                        //           print('At bottom');
                        //       }
                        //       return true;
                        //     },
                        child: ListView.builder(
                          controller: model.walletsScrollController,
                          shrinkWrap: true,
                          itemCount: model.walletInfo.length,
                          itemBuilder: (BuildContext context, int index) {
                            var usdVal = model.walletInfo[index].usdValue;

                            return Visibility(
                              // Default visible widget will be visible when usdVal is greater than equals to 0 and isHideSmallAmountAssets is false
                              visible:
                                  usdVal >= 0 && !model.isHideSmallAmountAssets,
                              child: WalletDashboardCoinsDetailsCardWidget(
                                  index: index, wallets: model.walletInfo),
                              // Secondary visible widget will be visible when usdVal is not equals to 0 and isHideSmallAmountAssets is true
                              replacement: Visibility(
                                  visible: model.isHideSmallAmountAssets &&
                                      usdVal != 0,
                                  child: WalletDashboardCoinsDetailsCardWidget(
                                      index: index, wallets: model.walletInfo)),
                            );
                          },
                        )
                        //),
                        ),

                // Fav coins tab
                model.favWalletInfoList.isEmpty ||
                        model.favWalletInfoList == null
                    ? Center(child: Icon(Icons.hourglass_empty, color: white)
                        //Text('Favorite list empty'),
                        )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.walletInfoCopy.length,
                        itemBuilder: (BuildContext context, int index) {
                          return WalletDashboardCoinsDetailsCardWidget(
                              index: index, wallets: model.favWalletInfoList);
                        },
                      )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
