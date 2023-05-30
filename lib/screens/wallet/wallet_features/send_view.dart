/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/models/wallet/wallet_model.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/send_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

class SendWalletView extends StatelessWidget {
  final WalletInfo? walletInfo;
  const SendWalletView({Key? key, this.walletInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SendViewModel(),
        onViewModelReady: (SendViewModel model) async {
          model.context = context;
          model.walletInfo = walletInfo;

          await model.initState();
        },
        builder: (context, SendViewModel model, child) {
          return WillPopScope(
            onWillPop: () {
              model.storageService!.customTokenData = '';
              model.navigationService!.goBack();
              return Future(() => false);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: walletCardColor,
                title: Text(
                    '${FlutterI18n.translate(context, "send")} ${model.specialTickerName!}',
                    style: Theme.of(context).textTheme.headlineMedium),
                centerTitle: true,
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  // to avoid using ListView without having any list childs to iterate and use column as its child now
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      // I was using ListView here earlier to solve keyboard overflow error
                      children: <Widget>[
                        // Receiver's Wallet Address Container

                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: walletCardColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: GestureDetector(
                                    child: TextField(
                                      onChanged: (value) =>
                                          model.checkDomain(value),
                                      maxLines: 1,
                                      controller: model
                                          .receiverWalletAddressTextController,
                                      decoration: InputDecoration(
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: grey, width: 0.5)),
                                          suffixIcon: Container(
                                            margin: EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                model.receiverWalletAddressTextController
                                                        .text.isNotEmpty
                                                    ? IconButton(
                                                        icon: const Icon(
                                                            Icons.cancel),
                                                        onPressed: () {
                                                          model.clearAddress();
                                                        },
                                                        iconSize: 18,
                                                        color: white
                                                            .withAlpha(190),
                                                      )
                                                    : Container(),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.content_paste),
                                                  onPressed: () async {
                                                    await model
                                                        .pasteClipBoardData();
                                                  },
                                                  iconSize: 22,
                                                  color: primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          labelText:
                                              '${FlutterI18n.translate(context, "receiverWalletAddress")}, DNS',
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  )),
                              model.busy(model.userTypedDomain)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: model.sharedService!
                                                  .loadingIndicator()),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              model.userTypedDomain.isNotEmpty &&
                                      !model.busy(model.userTypedDomain)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.userTypedDomain,
                                          style:
                                              headText6.copyWith(color: grey),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.all(10))),
                                  onPressed: () {
                                    model.scan();
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Padding(
                                          padding: EdgeInsets.only(right: 5),
                                          child: Icon(Icons.camera_enhance)),
                                      Text(
                                        FlutterI18n.translate(
                                            context, "scanBarCode"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Container(
                            color: walletCardColor,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextField(
                                  // change paste text color
                                  controller: model.amountController,
                                  inputFormatters: [
                                    DecimalTextInputFormatter(
                                        decimalRange: model.decimalLimit,
                                        activatedNegativeValues: false)
                                  ],
                                  onChanged: (String amount) {
                                    // model.amount = double.parse(amount);

                                    model.amountAfterFee();
                                    //   model.checkAmount();
                                  },
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true), // numnber keyboard
                                  decoration: InputDecoration(
                                      suffix: Text(
                                          '${FlutterI18n.translate(context, "decimalLimit")}: ${model.decimalLimit}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: primaryColor)),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: grey, width: 0.5)),
                                      hintText: '0.00000',
                                      hintStyle: const TextStyle(
                                          fontSize: 14, color: grey)),
                                  style: model.isValidAmount
                                      ? const TextStyle(
                                          color: grey, fontSize: 14)
                                      : const TextStyle(
                                          color: red, fontSize: 14),
                                ),
                                // Wallet Balance
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          model.walletInfo!.tickerName == 'FAB'
                                              ? SizedBox(
                                                  width: 12,
                                                  height: 12,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      icon: Icon(
                                                          MdiIcons
                                                              .informationOutline,
                                                          size: 15,
                                                          color: green),
                                                      onPressed: () {
                                                        showModalBottomSheet<
                                                                void>(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ListView(
                                                                // padding: const EdgeInsets
                                                                //         .symmetric(
                                                                //     vertical: 32.0,
                                                                //     horizontal: 20),
                                                                children: [
                                                                  Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10,
                                                                          vertical:
                                                                              20),
                                                                      color:
                                                                          primaryColor,
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          FlutterI18n.translate(
                                                                              context,
                                                                              "availableBalanceInfoTitle"),
                                                                          // textAlign: TextAlign.center,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .headlineMedium,
                                                                        ),
                                                                      )),
                                                                  UIHelper
                                                                      .verticalSpaceMedium,
                                                                  Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      child:
                                                                          Text(
                                                                        FlutterI18n.translate(
                                                                            context,
                                                                            "availableBalanceInfoContent"),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .displayMedium,
                                                                      ))
                                                                ],
                                                              );
                                                            });
                                                      }),
                                                )
                                              : Container(),
                                          model.walletInfo!.tickerName == 'FAB'
                                              ? UIHelper.horizontalSpaceSmall
                                              : Container(),
                                          // UIHelper.horizontalSpaceSmall,
                                          Text(
                                            '${FlutterI18n.translate(context, "available")} ${FlutterI18n.translate(context, "walletbalance")}  ${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.availableBalance, precision: model.decimalLimit!)} ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                          Text(
                                            model.specialTickerName!
                                                .toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),

                                      // send max amount balance

                                      // Row(
                                      //   children: [
                                      //     OutlinedButton(
                                      //         style: ButtonStyle(
                                      //           minimumSize:
                                      //               MaterialStateProperty.all(
                                      //                   Size.square(20)),
                                      //           padding:
                                      //               MaterialStateProperty.all(
                                      //                   EdgeInsets.symmetric(
                                      //                       vertical: 2,
                                      //                       horizontal: 5)),
                                      //           backgroundColor:
                                      //               MaterialStateProperty.all(
                                      //                   green),
                                      //         ),
                                      //         onPressed: () {
                                      //           if (walletInfo.availableBalance !=
                                      //               0.0) model.fillMaxAmount();
                                      //         },
                                      //         child: Text(
                                      //           AppLocalizations.of(context)
                                      //               .maxAmount,
                                      //           style: Theme.of(context)
                                      //               .textTheme
                                      //               .subtitle2
                                      //               .copyWith(color: white),
                                      //         )),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                                // Unconfirmed balance
                                model.walletInfo!.tickerName == 'FAB'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 12,
                                                height: 12,
                                                child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    icon: const Icon(
                                                        MdiIcons
                                                            .informationOutline,
                                                        size: 15,
                                                        color: yellow),
                                                    onPressed: () {
                                                      showModalBottomSheet<
                                                              void>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ListView(
                                                              children: [
                                                                Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            20),
                                                                    color:
                                                                        primaryColor,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        FlutterI18n.translate(
                                                                            context,
                                                                            "unConfirmedBalanceInfoTitle"),
                                                                        // textAlign: TextAlign.center,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .displaySmall,
                                                                      ),
                                                                    )),
                                                                const SizedBox(
                                                                    height: 20),
                                                                Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20),
                                                                    child: Text(
                                                                      FlutterI18n.translate(
                                                                          context,
                                                                          "unConfirmedBalanceInfoContent"),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayMedium,
                                                                    )),
                                                                UIHelper
                                                                    .verticalSpaceMedium,
                                                                Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20),
                                                                    child: Text(
                                                                      FlutterI18n.translate(
                                                                          context,
                                                                          "unConfirmedBalanceInfoExample"),
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .displayMedium,
                                                                    ))
                                                              ],
                                                            );
                                                          });
                                                    }),
                                              ),
                                              UIHelper.horizontalSpaceSmall,
                                              Text(
                                                '${FlutterI18n.translate(context, "unConfirmedBalance")}  ${NumberUtil().truncateDoubleWithoutRouding(model.unconfirmedBalance!, precision: model.decimalLimit!)} ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                              Text(
                                                model.specialTickerName!
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
                                model.walletInfo!.tickerName == 'FAB'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 22),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '${FlutterI18n.translate(context, "totalBalance")}  ${NumberUtil().truncateDoubleWithoutRouding(model.walletInfo!.availableBalance + model.unconfirmedBalance!, precision: model.decimalLimit!)} ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                Text(
                                                  model.specialTickerName!
                                                      .toUpperCase(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: <Widget>[
                              model.isTrx()
                                  ? Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 0),
                                      alignment: Alignment.topLeft,
                                      child: walletInfo!.tickerName == 'TRX'
                                          ? Text(
                                              '${FlutterI18n.translate(context, "gasFee")}: ${model.trxGasValueTextController.text} TRX',
                                              textAlign: TextAlign.left,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge)
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${FlutterI18n.translate(context, "gasFee")}: ${model.trxGasValueTextController.text} TRX',
                                                    textAlign: TextAlign.left,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
                                                Text(
                                                    'TRX'
                                                    '${FlutterI18n.translate(context, "balance")}: ${model.chainBalance} TRX',
                                                    textAlign: TextAlign.left,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge),
                                              ],
                                            ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            FlutterI18n.translate(
                                                context, "gasFee"),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left:
                                                    5), // padding left to keep some space from the text
                                            child: model.isBusy
                                                ? SizedBox(
                                                    width: 16,
                                                    height: 16,
                                                    child: Theme.of(context)
                                                                .platform ==
                                                            TargetPlatform.iOS
                                                        ? const CupertinoActivityIndicator()
                                                        : const CircularProgressIndicator(
                                                            strokeWidth: 0.75,
                                                          ))
                                                : Text(
                                                    '${NumberUtil().truncateDoubleWithoutRouding(model.transFee!, precision: 6)}  ${model.feeUnit}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                              // Switch Row Advance
                              Row(
                                children: <Widget>[
                                  Text(
                                    FlutterI18n.translate(context, "advance"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall!
                                        .copyWith(fontWeight: FontWeight.w400),
                                  ),
                                  Switch(
                                    value: model.transFeeAdvance,
                                    inactiveTrackColor: grey,
                                    dragStartBehavior: DragStartBehavior.start,
                                    activeColor: primaryColor,
                                    onChanged: (bool isOn) {
                                      model.setBusy(true);
                                      model.transFeeAdvance = isOn;
                                      model.setBusy(false);
                                    },
                                  )
                                ],
                              ),
                              model.isTrx()
                                  ? Visibility(
                                      visible: model.transFeeAdvance,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              flex: 3,
                                              child: Text(
                                                'TRX ${FlutterI18n.translate(context, "gasFee")}',
                                                style: headText5.copyWith(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: TextField(
                                                  controller: model
                                                      .trxGasValueTextController,
                                                  onChanged: (String amount) {
                                                    if (amount.isNotEmpty) {
                                                      model.trxGasValueTextController
                                                              .text =
                                                          amount.toString();
                                                      model.notifyListeners();
                                                    }
                                                  },
                                                  keyboardType: const TextInputType
                                                          .numberWithOptions(
                                                      decimal:
                                                          true), // numnber keyboard
                                                  decoration: InputDecoration(
                                                      focusedBorder:
                                                          const UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      primaryColor)),
                                                      enabledBorder:
                                                          const UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: grey)),
                                                      hintText: '0.00000',
                                                      hintStyle: headText5.copyWith(
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                  style: headText5.copyWith(
                                                      fontWeight:
                                                          FontWeight.w300)))
                                        ],
                                      ),
                                    )
                                  : Visibility(
                                      visible: model.transFeeAdvance,
                                      child: Column(
                                        children: <Widget>[
                                          Visibility(
                                            visible: (model.specialTickerName ==
                                                    'ETH' ||
                                                model.tokenType == 'ETH' ||
                                                model.tokenType == 'POLYGON' ||
                                                model.tokenType == 'FAB'),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                      FlutterI18n.translate(
                                                          context, "gasPrice"),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                ),
                                                Expanded(
                                                    flex: 6,
                                                    child: TextField(
                                                        controller: model
                                                            .gasPriceTextController,
                                                        onChanged:
                                                            (String amount) {
                                                          model
                                                              .updateTransFee();
                                                        },
                                                        keyboardType:
                                                            const TextInputType.numberWithOptions(
                                                                decimal: true),
                                                        decoration: InputDecoration(
                                                            focusedBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color:
                                                                        primaryColor)),
                                                            enabledBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 0.5,
                                                                    color:
                                                                        grey)),
                                                            hintText: '0.00000',
                                                            hintStyle: Theme.of(context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight.w400)))
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                              visible: (model
                                                          .specialTickerName ==
                                                      'ETH' ||
                                                  model.tokenType == 'ETH' ||
                                                  model.tokenType ==
                                                      'POLYGON' ||
                                                  model.tokenType == 'FAB'),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        FlutterI18n.translate(
                                                            context,
                                                            "gasLimit"),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                  ),
                                                  Expanded(
                                                      flex: 6,
                                                      child: TextField(
                                                        controller: model
                                                            .gasLimitTextController,
                                                        onChanged:
                                                            (String amount) {
                                                          model
                                                              .updateTransFee();
                                                        },
                                                        keyboardType:
                                                            const TextInputType
                                                                    .numberWithOptions(
                                                                decimal: true),
                                                        decoration: InputDecoration(
                                                            focusedBorder:
                                                                const UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                primaryColor)),
                                                            enabledBorder: const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        width:
                                                                            0.5,
                                                                        color:
                                                                            grey)),
                                                            hintText: '0.00000',
                                                            hintStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ))
                                                ],
                                              )),
                                          Visibility(
                                              visible:
                                                  (model.specialTickerName ==
                                                          'BTC' ||
                                                      model.specialTickerName ==
                                                          'FAB' ||
                                                      model.tokenType == 'FAB'),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        FlutterI18n.translate(
                                                            context,
                                                            "satoshisPerByte"),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge),
                                                  ),
                                                  //  UIHelper.horizontalSpaceLarge,
                                                  Expanded(
                                                      flex: 6,
                                                      child: TextField(
                                                        controller: model
                                                            .satoshisPerByteTextController,
                                                        onChanged:
                                                            (String amount) {
                                                          model
                                                              .updateTransFee();
                                                        },
                                                        keyboardType:
                                                            const TextInputType
                                                                    .numberWithOptions(
                                                                decimal: true),
                                                        decoration: InputDecoration(
                                                            focusedBorder:
                                                                const UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                primaryColor)),
                                                            enabledBorder:
                                                                const UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                grey)),
                                                            hintText: '0.00000',
                                                            hintStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400)),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ))
                                                ],
                                              ))
                                        ],
                                      ))
                            ],
                          ),
                        ),
                        /*--------------------------------------------------------------------------------------------------------------------------------------------------------------
          
                                      TXID Container
          
          --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

                        UIHelper.verticalSpaceSmall,
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: model.txHash != null &&
                                    model.txHash!.isNotEmpty
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                            text: FlutterI18n.translate(
                                                context, "taphereToCopyTxId"),
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: white),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                model.copyAddress(context);
                                              }),
                                      ),
                                      UIHelper.verticalSpaceSmall,
                                      Text(
                                        model.txHash!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: primaryColor),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                    model.errorMessage,
                                    style: const TextStyle(color: red),
                                  ))),
                        UIHelper.verticalSpaceSmall,
                        // show error details
                        // model.isShowErrorDetailsButton
                        //     ? Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Center(
                        //             child: RichText(
                        //               text: TextSpan(
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .bodyText2
                        //                       .copyWith(
                        //                           decoration:
                        //                               TextDecoration.underline),
                        //                   text:
                        //                       '${AppLocalizations.of(context).error} ${AppLocalizations.of(context).details}',
                        //                   recognizer: TapGestureRecognizer()
                        //                     ..onTap = () {
                        //                       model.showDetailsMessageToggle();
                        //                     }),
                        //             ),
                        //           ),
                        //           !model.isShowDetailsMessage
                        //               ? const Icon(Icons.arrow_drop_down,
                        //                   color: Colors.red, size: 18)
                        //               : const Icon(Icons.arrow_drop_up,
                        //                   color: Colors.red, size: 18)
                        //         ],
                        //       )
                        //     : Container(),
                        // model.isShowDetailsMessage
                        //     ? Center(
                        //         child: Text(model.serverError,
                        //             style:
                        //                 Theme.of(context).textTheme.headline6),
                        //       )
                        //     : Container(),
                        UIHelper.verticalSpaceSmall,
                        /*--------------------------------------------------------------------------------------------------------------------------------------------------------------
          
                                      Send Button Container
          
          --------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                        Container(
                          // height:
                          //     100, // alignment was not working without the height so ;)
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          // alignment: Alignment(0.0, 1.0),
                          child: MaterialButton(
                            padding: const EdgeInsets.all(15),
                            color: primaryColor,
                            textColor: Colors.white,
                            onPressed: () {
                              if (model.isValidAmount && model.amount != 0.0) {
                                model.checkFields(context);
                              }
                            },
                            child: model.isBusy
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child:
                                        model.sharedService!.loadingIndicator())
                                : Text(
                                    FlutterI18n.translate(context, "confirm"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(
                                            color: model.isValidAmount &&
                                                    model.amount != 0.0
                                                ? white
                                                : grey)),
                          ),
                        ),
                        UIHelper.verticalSpaceMedium
                      ],
                    ),
                  ),
                ),
              ),
              // floatingActionButton: TextButton(
              //   child: Text('Click'),
              //   onPressed: () async {
              //     var a = await Erc20Util().getGasPrice(bnbBaseUrl);
              //     // 10000000000

              //     int.parse(a.toString());

              //     print('a $a');
              //   },
              // ),
            ),
          );
        });
  }
}
