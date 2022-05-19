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
import 'package:decimal/decimal.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet/app_wallet_model.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/send_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/wallet/barcode_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';

class SendWalletView extends StatelessWidget {
  final AppWallet appWallet;
  const SendWalletView({Key key, this.appWallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => SendViewModel(),
        onModelReady: (SendViewModel model) async {
          model.context = context;
          model.appWallet = appWallet;

          await model.initState();
        },
        builder: (context, SendViewModel model, child) {
          return WillPopScope(
            onWillPop: () {
              model.storageService.customTokenData = '';
              model.navigationService.goBack();
              return Future(() => false);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: walletCardColor,
                title: Text(AppLocalizations.of(context).send,
                    style: Theme.of(context).textTheme.headline3),
                centerTitle: true,
              ),
              body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  // to avoid using ListView without having any list childs to iterate and use column as its child now
                  child: Stack(
                    children: [
                      model.isScanWindowOpen
                          ? Align(
                              alignment: Alignment.center,
                              child: BarcodeUtilWidget(
                                afterCapture: (v) => model.onCapture(v),
                                onClose: (v) => model.toggleScanWindow(v),
                              ))
                          : Container(
                              margin: const EdgeInsets.all(10.0),
                              child: Column(
                                // I was using ListView here earlier to solve keyboard overflow error
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    color: walletCardColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10.0),
                                            child: GestureDetector(
                                              child: TextField(
                                                maxLines: 1,
                                                controller: model
                                                    .receiverWalletAddressTextController,
                                                decoration: InputDecoration(
                                                    enabledBorder:
                                                        const UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: grey,
                                                                    width:
                                                                        0.5)),
                                                    suffixIcon: IconButton(
                                                      icon: const Icon(
                                                          Icons.content_paste),
                                                      onPressed: () async {
                                                        await model
                                                            .pasteClipBoardData();
                                                      },
                                                      iconSize: 25,
                                                      color: primaryColor,
                                                    ),
                                                    labelText: AppLocalizations
                                                            .of(context)
                                                        .receiverWalletAddress,
                                                    labelStyle:
                                                        Theme.of(context)
                                                            .textTheme
                                                            .headline6),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            )),
                                        TextButton(
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        const EdgeInsets.all(
                                                            10))),
                                            onPressed: () {
                                              model.toggleScanWindow(true);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5),
                                                    child: Icon(
                                                        Icons.camera_enhance)),
                                                Text(
                                                  AppLocalizations.of(context)
                                                      .scanBarCode,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          TextField(
                                            // change paste text color
                                            controller: model.amountController,
                                            inputFormatters: [
                                              DecimalTextInputFormatter(
                                                  decimalRange:
                                                      model.decimalLimit,
                                                  activatedNegativeValues:
                                                      false)
                                            ],
                                            onChanged: (String amount) =>
                                                model.amountAfterFee(),
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal:
                                                    true), // numnber keyboard
                                            decoration: InputDecoration(
                                                suffix: Text(
                                                    '${AppLocalizations.of(context).decimalLimit}: ${model.decimalLimit}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                primaryColor)),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: grey,
                                                            width: 0.5)),
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
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    model.appWallet
                                                                .tickerName ==
                                                            'FAB'
                                                        ? SizedBox(
                                                            width: 12,
                                                            height: 12,
                                                            child: IconButton(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                icon: const Icon(
                                                                    MdiIcons
                                                                        .informationOutline,
                                                                    size: 15,
                                                                    color:
                                                                        green),
                                                                onPressed: () {
                                                                  showModalBottomSheet<
                                                                          void>(
                                                                      context:
                                                                          context,
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
                                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                                                                color: primaryColor,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    AppLocalizations.of(context).availableBalanceInfoTitle,
                                                                                    // textAlign: TextAlign.center,
                                                                                    style: Theme.of(context).textTheme.headline4,
                                                                                  ),
                                                                                )),
                                                                            UIHelper.verticalSpaceMedium,
                                                                            Container(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                                child: Text(
                                                                                  AppLocalizations.of(context).availableBalanceInfoContent,
                                                                                  style: Theme.of(context).textTheme.headline2,
                                                                                ))
                                                                          ],
                                                                        );
                                                                      });
                                                                }),
                                                          )
                                                        : Container(),
                                                    model.appWallet
                                                                .tickerName ==
                                                            'FAB'
                                                        ? UIHelper
                                                            .horizontalSpaceSmall
                                                        : Container(),
                                                    // UIHelper.horizontalSpaceSmall,
                                                    Text(
                                                      '${AppLocalizations.of(context).available} ${AppLocalizations.of(context).walletbalance}  ${NumberUtil.stringDecimalLimiter(model.appWallet.balance.toString(), decimalPrecision: model.decimalLimit).stringOutput} ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                    Text(
                                                      model.tickerName
                                                          .toUpperCase(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
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
                                          model.appWallet.tickerName == 'FAB'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: 12,
                                                          height: 12,
                                                          child: IconButton(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              icon: const Icon(
                                                                  MdiIcons
                                                                      .informationOutline,
                                                                  size: 15,
                                                                  color:
                                                                      yellow),
                                                              onPressed: () {
                                                                showModalBottomSheet<
                                                                        void>(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return ListView(
                                                                        children: [
                                                                          Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                                                              color: primaryColor,
                                                                              child: Center(
                                                                                child: Text(
                                                                                  AppLocalizations.of(context).unConfirmedBalanceInfoTitle,
                                                                                  // textAlign: TextAlign.center,
                                                                                  style: Theme.of(context).textTheme.headline3,
                                                                                ),
                                                                              )),
                                                                          const SizedBox(
                                                                              height: 20),
                                                                          Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              child: Text(
                                                                                AppLocalizations.of(context).unConfirmedBalanceInfoContent,
                                                                                style: Theme.of(context).textTheme.headline2,
                                                                              )),
                                                                          UIHelper
                                                                              .verticalSpaceMedium,
                                                                          Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              child: Text(
                                                                                AppLocalizations.of(context).unConfirmedBalanceInfoExample,
                                                                                style: Theme.of(context).textTheme.headline2,
                                                                              ))
                                                                        ],
                                                                      );
                                                                    });
                                                              }),
                                                        ),
                                                        UIHelper
                                                            .horizontalSpaceSmall,
                                                        Text(
                                                          '${AppLocalizations.of(context).unConfirmedBalance}  ${NumberUtil.decimalLimiter(model.unconfirmedBalance, decimalPrecision: model.decimalLimit)} ',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                        Text(
                                                          model.tickerName
                                                              .toUpperCase(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                          model.appWallet.tickerName == 'FAB'
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 10,
                                                      horizontal: 22),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            '${AppLocalizations.of(context).totalBalance}  ${NumberUtil.decimalLimiter(model.appWallet.balance + model.unconfirmedBalance, decimalPrecision: model.decimalLimit)} ',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          ),
                                                          Text(
                                                            model.tickerName
                                                                .toUpperCase(),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child:
                                        appWallet.tickerName == 'TRX' ||
                                                appWallet.tickerName == 'USDTX'
                                            ? Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10, bottom: 0),
                                                alignment: Alignment.topLeft,
                                                child: appWallet.tickerName ==
                                                        'TRX'
                                                    ? Text(
                                                        '${AppLocalizations.of(context).gasFee}: 1 TRX',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6)
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${AppLocalizations.of(context).gasFee}: 15 TRX',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6),
                                                          Text(
                                                              'TRX'
                                                              '${AppLocalizations.of(context).balance}: ${model.chainBalance} TRX',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6),
                                                        ],
                                                      ),
                                              )
                                            : Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15,
                                                            bottom: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .gasFee,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline5
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                                  .only(
                                                              left:
                                                                  5), // padding left to keep some space from the text
                                                          child: model.isBusy
                                                              ? SizedBox(
                                                                  width: 16,
                                                                  height: 16,
                                                                  child: Theme.of(context)
                                                                              .platform ==
                                                                          TargetPlatform
                                                                              .iOS
                                                                      ? const CupertinoActivityIndicator()
                                                                      : const CircularProgressIndicator(
                                                                          strokeWidth:
                                                                              0.75,
                                                                        ))
                                                              : Text(
                                                                  '${NumberUtil.stringDecimalLimiter(model.transFee.toString(), decimalPrecision: 6).stringOutput}  ${model.feeUnit}',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6
                                                                      .copyWith(
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  // Switch Row Advance
                                                  Row(
                                                    children: <Widget>[
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .advance,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                      Switch(
                                                        value: model
                                                            .transFeeAdvance,
                                                        inactiveTrackColor:
                                                            grey,
                                                        dragStartBehavior:
                                                            DragStartBehavior
                                                                .start,
                                                        activeColor:
                                                            primaryColor,
                                                        onChanged: (bool isOn) {
                                                          model.setBusy(true);
                                                          model.transFeeAdvance =
                                                              isOn;
                                                          model.setBusy(false);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  Visibility(
                                                      visible:
                                                          model.transFeeAdvance,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Visibility(
                                                              visible: (model
                                                                          .tickerName ==
                                                                      'ETH' ||
                                                                  model.tokenType ==
                                                                      'ETH' ||
                                                                  model.tokenType ==
                                                                      'FAB'),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Text(
                                                                        AppLocalizations.of(context)
                                                                            .gasPrice,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(fontWeight: FontWeight.w400)),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 6,
                                                                      child: TextField(
                                                                          controller: model.gasPriceTextController,
                                                                          onChanged: (String amount) {
                                                                            model.updateTransFee();
                                                                          },
                                                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                                          decoration: InputDecoration(focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)), enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: grey)), hintText: '0.00000', hintStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.w400)),
                                                                          style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.w400)))
                                                                ],
                                                              )),
                                                          Visibility(
                                                              visible: (model
                                                                          .tickerName ==
                                                                      'ETH' ||
                                                                  model.tokenType ==
                                                                      'ETH' ||
                                                                  model.tokenType ==
                                                                      'FAB'),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Text(
                                                                        AppLocalizations.of(context)
                                                                            .gasLimit,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(fontWeight: FontWeight.w400)),
                                                                  ),
                                                                  Expanded(
                                                                      flex: 6,
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            model.gasLimitTextController,
                                                                        onChanged:
                                                                            (String
                                                                                amount) {
                                                                          model
                                                                              .updateTransFee();
                                                                        },
                                                                        keyboardType:
                                                                            const TextInputType.numberWithOptions(decimal: true),
                                                                        decoration: InputDecoration(
                                                                            focusedBorder:
                                                                                const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                                                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(width: 0.5, color: grey)),
                                                                            hintText: '0.00000',
                                                                            hintStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.w400)),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(fontWeight: FontWeight.w400),
                                                                      ))
                                                                ],
                                                              )),
                                                          Visibility(
                                                              visible: (model
                                                                          .tickerName ==
                                                                      'BTC' ||
                                                                  model.tickerName ==
                                                                      'FAB' ||
                                                                  model.tokenType ==
                                                                      'FAB'),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child: Text(
                                                                        AppLocalizations.of(context)
                                                                            .satoshisPerByte,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6),
                                                                  ),
                                                                  //  UIHelper.horizontalSpaceLarge,
                                                                  Expanded(
                                                                      flex: 6,
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            model.satoshisPerByteTextController,
                                                                        onChanged:
                                                                            (String
                                                                                amount) {
                                                                          model
                                                                              .updateTransFee();
                                                                        },
                                                                        keyboardType:
                                                                            const TextInputType.numberWithOptions(decimal: true),
                                                                        decoration: InputDecoration(
                                                                            focusedBorder:
                                                                                const UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                                                            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: grey)),
                                                                            hintText: '0.00000',
                                                                            hintStyle: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.w400)),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6
                                                                            .copyWith(fontWeight: FontWeight.w300),
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
                                              model.txHash.isNotEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                RichText(
                                                  text: TextSpan(
                                                      text: AppLocalizations.of(
                                                              context)
                                                          .taphereToCopyTxId,
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          color: white),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              model.copyAddress(
                                                                  context);
                                                            }),
                                                ),
                                                UIHelper.verticalSpaceSmall,
                                                Text(
                                                  model.txHash,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color: primaryColor),
                                                ),
                                              ],
                                            )
                                          : model.errorMessage !=
                                                  model.serverError
                                              ? Center(
                                                  child: Text(
                                                  model.errorMessage,
                                                  style: const TextStyle(
                                                      color: red),
                                                ))
                                              : Container()),
                                  UIHelper.verticalSpaceSmall,
                                  // show error details
                                  model.isShowErrorDetailsButton
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: RichText(
                                                text: TextSpan(
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                            color: grey,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline),
                                                    text:
                                                        '${AppLocalizations.of(context).error} ${AppLocalizations.of(context).details}',
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            model
                                                                .showDetailsMessageToggle();
                                                          }),
                                              ),
                                            ),
                                            !model.isShowDetailsMessage
                                                ? const Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.red,
                                                    size: 18)
                                                : const Icon(
                                                    Icons.arrow_drop_up,
                                                    color: Colors.red,
                                                    size: 18)
                                          ],
                                        )
                                      : Container(),
                                  model.isShowDetailsMessage
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(model.serverError,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6),
                                          ),
                                        )
                                      : Container(),
                                  UIHelper.verticalSpaceSmall,
                                  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------
          
                                          Send Button Container
          
          --------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                                  Container(
                                    // height:
                                    //     100, // alignment was not working without the height so ;)
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    // alignment: Alignment(0.0, 1.0),
                                    child: MaterialButton(
                                      padding: const EdgeInsets.all(15),
                                      color: primaryColor,
                                      textColor: Colors.white,
                                      onPressed: () {
                                        if (model.isValidAmount &&
                                            model.amount != Decimal.zero) {
                                          model.checkFields(context);
                                        }
                                      },
                                      child: model.isBusy
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: model.sharedService
                                                  .loadingIndicator())
                                          : Text(
                                              AppLocalizations.of(context)
                                                  .confirm,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(
                                                      color:
                                                          model.isValidAmount &&
                                                                  model.amount !=
                                                                      Decimal
                                                                          .zero
                                                              ? white
                                                              : grey)),
                                    ),
                                  ),
                                  UIHelper.verticalSpaceMedium
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              // floatingActionButton: TextButton(
              //   child: const Text('Click'),
              //   onPressed: () {
              //     model.test();
              //   },
              // ),
            ),
          );
        });
  }
}
