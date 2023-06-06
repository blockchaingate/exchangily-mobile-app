import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/screens/lightning-remit/lightning_remit_transfer_history.view.dart';
import 'package:exchangilymobileapp/screens/lightning-remit/lightning_remit_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';

class LightningRemitView extends StatelessWidget {
  const LightningRemitView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PersistentBottomSheetController persistentBottomSheetController;
    return ViewModelBuilder<LightningRemitViewmodel>.reactive(
      viewModelBuilder: () => LightningRemitViewmodel(),
      onViewModelReady: (model) {
        model.context = context;
        model.init();
      },
      onDispose: (viewModel) {},
      builder: (context, model, _) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return Future(() => false);
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: model.storageService.isDarkMode
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                debugPrint('Close keyboard');
                // persistentBottomSheetController.closed
                //     .then((value) => debugPrint(value));
                if (model.isShowBottomSheet) {
                  Navigator.pop(context);
                  model.setBusy(true);
                  model.isShowBottomSheet = false;
                  model.setBusy(false);
                  debugPrint('Close bottom sheet');
                }
              },
              child: model.busy(model.exchangeBalances) || model.isBusy
                  ? model.sharedService.loadingIndicator()
                  : Container(
                      color: Theme.of(context).canvasColor,
                      margin: const EdgeInsets.only(top: 40),
                      child: Stack(children: [
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Platform.isIOS
                                  ? CoinListBottomSheetFloatingActionButton(
                                      model: model)
                                  : Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        border: Border.all(
                                            color:
                                                model.exchangeBalances.isEmpty
                                                    ? Colors.transparent
                                                    : primaryColor,
                                            style: BorderStyle.solid,
                                            width: 0.50),
                                      ),
                                      child: DropdownButton(
                                          underline: const SizedBox.shrink(),
                                          elevation: 5,
                                          isExpanded: true,
                                          icon: const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Icon(Icons.arrow_drop_down),
                                          ),
                                          iconEnabledColor: primaryColor,
                                          iconDisabledColor: model
                                                  .exchangeBalances.isEmpty
                                              ? Theme.of(context).canvasColor
                                              : grey,
                                          iconSize: 30,
                                          hint: Padding(
                                            padding:
                                                model.exchangeBalances.isEmpty
                                                    ? const EdgeInsets.all(0)
                                                    : const EdgeInsets.only(
                                                        left: 10.0),
                                            child: model
                                                    .exchangeBalances.isEmpty
                                                ? ListTile(
                                                    dense: true,
                                                    leading: const Icon(
                                                      Icons
                                                          .account_balance_wallet,
                                                      color: red,
                                                      size: 18,
                                                    ),
                                                    title: Text(
                                                        FlutterI18n.translate(
                                                            context,
                                                            "noCoinBalance"),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium),
                                                    subtitle: Text(
                                                        FlutterI18n.translate(
                                                            context,
                                                            "transferFundsToExchangeUsingDepositButton"),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall))
                                                : Text(
                                                    FlutterI18n.translate(
                                                        context, "selectCoin"),
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall,
                                                  ),
                                          ),
                                          value: model.tickerName,
                                          onChanged: (dynamic newValue) {
                                            model.updateSelectedTickername(
                                                newValue);
                                          },
                                          items: model.exchangeBalances.map(
                                            (coin) {
                                              return DropdownMenuItem(
                                                value: coin.ticker,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          coin.ticker
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headlineSmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                      UIHelper
                                                          .horizontalSpaceSmall,
                                                      Text(
                                                        coin.unlockedAmount
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineSmall!
                                                            .copyWith(
                                                                color: grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ).toList()),
                                    ),

                              /*----------------------------------------------------------------------------------------------------
                                          Receiver Address textfield
        ----------------------------------------------------------------------------------------------------*/

                              UIHelper.verticalSpaceSmall,
                              TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          tooltip: FlutterI18n.translate(
                                              context, "scanBarCode"),
                                          icon: Icon(
                                            Icons.camera_alt,
                                            color: Theme.of(context).hintColor,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            model.scanBarcode();
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());
                                          }),
                                      suffixIcon: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            Icons.content_paste,
                                            color: green,
                                            size: 18,
                                          ),
                                          onPressed: () =>
                                              model.contentPaste()),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF871fff),
                                              width: 0.5)),
                                      hintText: FlutterI18n.translate(
                                          context, "receiverWalletAddress"),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                  controller: model.addressController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold)),

                              /*----------------------------------------------------------------------------------------------------
                                          Transfer amount textfield
        ----------------------------------------------------------------------------------------------------*/

                              UIHelper.verticalSpaceSmall,
                              TextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0XFF871fff),
                                              width: 0.5)),
                                      hintText: FlutterI18n.translate(
                                          context, "enterAmount"),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headlineSmall),
                                  controller: model.amountController,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              UIHelper.verticalSpaceMedium,
                              /*----------------------------------------------------------------------------------------------------
                                          Transfer - Receive Button Row
        ----------------------------------------------------------------------------------------------------*/

                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: model.sharedService
                                          .gradientBoxDecoration(),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.transparent,
                                          padding: const EdgeInsets.all(0),
                                        ),
                                        onPressed: () {
                                          model.isBusy
                                              ? debugPrint('busy')
                                              : model.transfer();
                                        },
                                        child: Text(
                                          FlutterI18n.translate(
                                              context, "send"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceSmall,

                                  /*----------------------------------------------------------------------------------------------------
                                              Transaction history Button
        ----------------------------------------------------------------------------------------------------*/

                                  Expanded(
                                    child: OutlinedButton(
                                      style: outlinedButtonStyles1,
                                      onPressed: () {
                                        model.isBusy
                                            ? debugPrint('busy')
                                            : model.showBarcode();
                                      },
                                      child: Text(
                                          FlutterI18n.translate(
                                              context, "receive"),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium),
                                    ),
                                  ),
                                  IconButton(
                                    //  borderSide: BorderSide(color: primaryColor),
                                    padding: const EdgeInsets.all(15),
                                    color: primaryColor,
                                    // textColor: Colors.white,
                                    onPressed: () async {
                                      await model.geTransactionstHistory();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  LightningRemitTransferHistoryView()));
                                    },
                                    icon: Icon(Icons.history,
                                        color: model.storageService.isDarkMode
                                            ? white
                                            : black,
                                        size: 24),
                                    // child: Text('History',
                                    //     style: Theme.of(context).textTheme.headline4),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /*----------------------------------------------------------------------------------------------------
                                          Stack loading container
        ----------------------------------------------------------------------------------------------------*/

                        model.isBusy
                            ? Align(
                                alignment: Alignment.center,
                                child: model.sharedService
                                    .stackFullScreenLoadingIndicator())
                            : Container()
                      ]),
                    ),
            ),
            bottomNavigationBar: BottomNavBar(count: 2),
          ),
        ),
      ),
    );
  }
}

class CoinListBottomSheetFloatingActionButton extends StatelessWidget {
  const CoinListBottomSheetFloatingActionButton({Key? key, this.model})
      : super(key: key);
  final LightningRemitViewmodel? model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: FloatingActionButton(
          backgroundColor: Theme.of(context).canvasColor,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            // width: 400,
            height: 220,
            //  color: Theme.of(context).canvasColor,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: model!.exchangeBalances.isEmpty
                    ? Text(FlutterI18n.translate(context, "noCoinBalance"))
                    : Text(
                        //model.tickerName == ''
                        // ? AppLocalizations.of(context).selectCoin
                        // :
                        model!.tickerName!),
              ),
              Text(model!.quantity == 0.0 ? '' : model!.quantity.toString()),
              model!.exchangeBalances.isNotEmpty
                  ? const Icon(Icons.arrow_drop_down)
                  : Container()
            ]),
          ),
          onPressed: () {
            if (model!.exchangeBalances.isNotEmpty) {
              model!.coinListBottomSheet(context);
            }
          }),
    );
  }
}
