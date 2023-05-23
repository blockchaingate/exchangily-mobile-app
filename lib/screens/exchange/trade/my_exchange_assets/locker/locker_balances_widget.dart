import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'locker_viewmodel.dart';

class LockerBalanceWidget extends ViewModelBuilderWidget<LockerViewModel> {
  @override
  LockerViewModel viewModelBuilder(BuildContext context) => LockerViewModel();

  @override
  void onViewModelReady(LockerViewModel model) async {
    //debugPrint('in coin details list widget - index $index');
  }

  @override
  bool get reactive => true;

  @override
  bool get createNewModelOnInsert => true;

  @override
  Widget builder(BuildContext context, LockerViewModel model, Widget? child) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: walletCardColor,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coin', style: Theme.of(context).textTheme.titleSmall),
                Text('Amount', style: Theme.of(context).textTheme.titleSmall),
                Text('Release Block',
                    style: Theme.of(context).textTheme.titleSmall),
                Text('Action', style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
          ),
          model.busy(model.lockers)
              ? Container(
                  margin: const EdgeInsets.all(20.0),
                  child: model.sharedService!.loadingIndicator())
              : model.lockers.isEmpty
                  ? Container(
                      margin: const EdgeInsets.all(20.0),
                      child: const Center(child: Text('No Data')))
                  : Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 5.0),
                        child: SafeArea(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: model.lockers.length,
                              itemBuilder: ((context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(model.lockers[index].tickerName ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    Text(model.lockers[index].amount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    Text(
                                        model.lockers[index].releaseBlock
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  primaryColor)),
                                      child: Text('Unlock',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall),
                                      onPressed: () {
                                        model.unlockCoins(model.lockers[index]);
                                      },
                                    ),
                                  ],
                                );
                              })),
                        ),
                      ),
                    )
        ],
      ),
    );
  }
}
