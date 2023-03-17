import 'dart:io';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/lightning-remit/lightning_remit_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/bottom_nav.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LightningRemitView extends StatelessWidget {
  const LightningRemitView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PersistentBottomSheetController persistentBottomSheetController;
    return ViewModelBuilder<LightningRemitViewmodel>.reactive(
      viewModelBuilder: () => LightningRemitViewmodel(),
      onModelReady: (model) {
        model.context = context;
        model.init();
      },
      onDispose: (LightningRemitViewmodel v) {},
      builder: (context, model, _) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return Future(() => false);
        },
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
                    color: secondaryColor,
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
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                          color: model.exchangeBalances.isEmpty
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
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.arrow_drop_down),
                                        ),
                                        iconEnabledColor: primaryColor,
                                        iconDisabledColor:
                                            model.exchangeBalances.isEmpty
                                                ? secondaryColor
                                                : grey,
                                        iconSize: 30,
                                        hint: Padding(
                                          padding:
                                              model.exchangeBalances.isEmpty
                                                  ? const EdgeInsets.all(0)
                                                  : const EdgeInsets.only(
                                                      left: 10.0),
                                          child: model.exchangeBalances.isEmpty
                                              ? ListTile(
                                                  dense: true,
                                                  leading: const Icon(
                                                    Icons
                                                        .account_balance_wallet,
                                                    color: red,
                                                    size: 18,
                                                  ),
                                                  title: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .noCoinBalance,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2),
                                                  subtitle: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .transferFundsToExchangeUsingDepositButton,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2))
                                              : Text(
                                                  AppLocalizations.of(context)
                                                      .selectCoin,
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                        ),
                                        value: model.tickerName,
                                        onChanged: (newValue) {
                                          model.updateSelectedTickername(
                                              newValue);
                                        },
                                        items: model.exchangeBalances.map(
                                          (coin) {
                                            return DropdownMenuItem(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Row(
                                                  children: [
                                                    Text(coin.ticker.toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
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
                                                          .headline5
                                                          .copyWith(
                                                              color: grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              value: coin.ticker,
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
                                        tooltip: AppLocalizations.of(context)
                                            .scanBarCode,
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: white,
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
                                        onPressed: () => model.contentPaste()),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0XFF871fff),
                                            width: 0.5)),
                                    hintText: AppLocalizations.of(context)
                                        .receiverWalletAddress,
                                    hintStyle:
                                        Theme.of(context).textTheme.headline5),
                                controller: model.addressController,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
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
                                    hintText: AppLocalizations.of(context)
                                        .enterAmount,
                                    hintStyle:
                                        Theme.of(context).textTheme.headline5),
                                controller: model.amountController,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
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
                                    child: FlatButton(
                                      textColor: Colors.white,
                                      onPressed: () {
                                        model.isBusy
                                            ? debugPrint('busy')
                                            : model.transfer();
                                      },
                                      child: Text(
                                          AppLocalizations.of(context).send,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                    ),
                                  ),
                                ),
                                UIHelper.horizontalSpaceSmall,

/*----------------------------------------------------------------------------------------------------
                                            Receive Button
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
                                        AppLocalizations.of(context).receive,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4),
                                  ),
                                ),
                                IconButton(
                                  //  borderSide: BorderSide(color: primaryColor),
                                  padding: const EdgeInsets.all(15),
                                  color: primaryColor,
                                  // textColor: Colors.white,
                                  onPressed: () async {
                                    await model
                                        .getLightningRemitTransactionHistory();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => TxHistoryView(
                                                transactionHistory:
                                                    model.transactionHistory,
                                                model: model)));
                                  },
                                  icon: Icon(Icons.history,
                                      color: white, size: 24),
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
    );
  }
}

class CoinListBottomSheetFloatingActionButton extends StatelessWidget {
  const CoinListBottomSheetFloatingActionButton({Key key, this.model})
      : super(key: key);
  final LightningRemitViewmodel model;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: EdgeInsets.all(10.0),
      width: double.infinity,
      child: FloatingActionButton(
          backgroundColor: secondaryColor,
          child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            width: 400,
            height: 220,
            //  color: secondaryColor,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: model.exchangeBalances.isEmpty
                    ? Text(AppLocalizations.of(context).noCoinBalance)
                    : Text(
                        //model.tickerName == ''
                        // ? AppLocalizations.of(context).selectCoin
                        // :
                        model.tickerName),
              ),
              Text(model.quantity == 0.0 ? '' : model.quantity.toString()),
              model.exchangeBalances.isNotEmpty
                  ? const Icon(Icons.arrow_drop_down)
                  : Container()
            ]),
          ),
          onPressed: () {
            if (model.exchangeBalances.isNotEmpty) {
              model.coinListBottomSheet(context);
            }
          }),
    );
  }
}

// transaction history

class TxHistoryView extends StatelessWidget {
  final List<TransactionHistory> transactionHistory;
  final LightningRemitViewmodel model;
  const TxHistoryView({this.transactionHistory, this.model});
  @override
  Widget build(BuildContext context) {
    /*----------------------------------------------------------------------
                    Copy Order
----------------------------------------------------------------------*/

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context).transactionHistory,
            style: Theme.of(context).textTheme.headline3),
        backgroundColor: secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: <Widget>[
                for (var transaction in transactionHistory)
                  Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      color: walletCardColor,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(transaction.tickerName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
                                ),
                                // icon
                                transaction.tag == 'send'
                                    ? Icon(
                                        FontAwesomeIcons.arrowRight,
                                        size: 11,
                                        color: sellPrice,
                                      )
                                    : Icon(
                                        Icons.arrow_downward,
                                        size: 18,
                                        color: buyPrice,
                                      ),
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Container(
                            //  width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text: transaction.tickerChainTxId,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .copyWith(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: primaryColor),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                model.copyAddress(transaction
                                                    .tickerChainTxId);
                                                model.openExplorer(transaction
                                                    .tickerChainTxId);
                                              }),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy_outlined,
                                          color: white, size: 16),
                                      onPressed: () => model.copyAddress(
                                          transaction.tickerChainTxId),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    transaction.date.substring(0, 19),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          UIHelper.horizontalSpaceSmall,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppLocalizations.of(context).quantity,
                                  style: Theme.of(context).textTheme.subtitle2),
                              Text(
                                transaction.quantity.toStringAsFixed(
                                    // model
                                    //   .decimalConfig
                                    //   .quantityDecimal
                                    2),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}
