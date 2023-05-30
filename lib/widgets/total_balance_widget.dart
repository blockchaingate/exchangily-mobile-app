import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/environments/environment_type.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_dashboard_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class TotalBalanceCardWidget
    extends ViewModelBuilderWidget<WalletDashboardViewModel> {
  final Widget? logo;
  final String? title;

  const TotalBalanceCardWidget({this.logo, this.title});
  @override
  WalletDashboardViewModel viewModelBuilder(BuildContext context) =>
      WalletDashboardViewModel();

  @override
  Widget builder(BuildContext context, WalletDashboardViewModel model, _) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned(
            bottom: 20,
            right: 30,
            left: 30,
            child: Card(
              elevation: model.elevation,
              color: isProduction
                  ? Theme.of(context).canvasColor
                  : red.withAlpha(200),
              child: Container(
                //duration: Duration(milliseconds: 250),
                width: 350,
                height: 90,
                //model.totalBalanceContainerWidth,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Announcement Widget
                    Expanded(flex: 1, child: logo!),
                    model.swiperWidgetIndex == 2
                        ? Container()
                        : Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(title!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(fontWeight: FontWeight.w400)),
                                model.isBusy
                                    ? Shimmer.fromColors(
                                        baseColor: primaryColor,
                                        highlightColor: white,
                                        child: Text(
                                          '${model.totalUsdBalance} USD',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      )
                                    : Text(
                                        '${model.swiperWidgetIndex == 0 ? model.totalUsdBalance : model.totalExchangeBalance} USD',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400)),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
