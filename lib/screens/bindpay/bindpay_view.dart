import 'dart:io';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/bindpay/bindpay_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BindpayView extends StatelessWidget {
  const BindpayView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BindpayViewmodel>.reactive(
        viewModelBuilder: () => BindpayViewmodel(),
        onModelReady: (model) {
          model.context = context;
          model.init();
        },
        builder: (context, model, _) => Scaffold(
              appBar: AppBar(
                  title: Text(AppLocalizations.of(context).bindpay),
                  centerTitle: true),
              body: Container(
                child: Stack(children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                        height: 105,
                        width: 105,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  color: primaryColor.withAlpha(175),
                                  width: 5.0,
                                ),
                                left: BorderSide(
                                    color: secondaryColor.withAlpha(175),
                                    width: 15.0),
                                right: BorderSide(
                                    color: secondaryColor.withAlpha(175),
                                    width: 15.0))),
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          'assets/images/bindpay/bindpay.png',
                          width: 100,
                          height: 100,
                          color: white,
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
/*----------------------------------------------------------------------------------------------------
                                    Coin list dropdown
----------------------------------------------------------------------------------------------------*/

                        !model.dataReady
                            ? Center(
                                child: CircularProgressIndicator(
                                backgroundColor: yellow,
                              ))
                            : Platform.isIOS
                                ? CupertinoPicker(
                                    diameterRatio: 1.3,
                                    offAxisFraction: 5,
                                    scrollController: model.scrollController,
                                    itemExtent: 50,
                                    onSelectedItemChanged: (int newValue) {
                                      model.updateSelectedTickernameIOS(
                                          newValue);
                                    },
                                    children: [
                                        for (var i = 0;
                                            i < model.coins.length;
                                            i++)
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: primaryColor
                                                        .withAlpha(175),
                                                    width: 1)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      model.coins[i]
                                                              ['tickerName']
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5),
                                                  UIHelper.horizontalSpaceSmall,
                                                  Text(
                                                    model.coins[i]['quantity']
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        .copyWith(color: grey),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                      ])
                                : Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                          color: primaryColor,
                                          style: BorderStyle.solid,
                                          width: 0.50),
                                    ),
                                    child: DropdownButton(
                                        underline: SizedBox.shrink(),
                                        elevation: 5,
                                        isExpanded: true,
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.arrow_drop_down),
                                        ),
                                        iconEnabledColor: primaryColor,
                                        iconSize: 30,
                                        hint: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            AppLocalizations.of(context).coin,
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
                                        items: model.coins.map(
                                          (coin) {
                                            return DropdownMenuItem(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        coin['tickerName']
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5),
                                                    UIHelper
                                                        .horizontalSpaceSmall,
                                                    Text(
                                                      coin['quantity']
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5
                                                          .copyWith(
                                                              color: grey),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              value: coin['tickerName'],
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
                                suffixIcon: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.content_paste,
                                      color: green,
                                      size: 18,
                                    ),
                                    onPressed: () => model.contentPaste()),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0XFF871fff), width: 0.5)),
                                hintText:
                                    AppLocalizations.of(context).recieveAddress,
                                hintStyle:
                                    Theme.of(context).textTheme.headline5),
                            controller: model.addressController,
                            style: Theme.of(context).textTheme.headline5),

/*----------------------------------------------------------------------------------------------------
                                    Transfer amount textfield
----------------------------------------------------------------------------------------------------*/

                        UIHelper.verticalSpaceSmall,
                        TextField(
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0XFF871fff), width: 0.5)),
                                hintText:
                                    AppLocalizations.of(context).enterAmount,
                                hintStyle:
                                    Theme.of(context).textTheme.headline5),
                            controller: model.amountController,
                            style: Theme.of(context).textTheme.headline5),
                        UIHelper.verticalSpaceMedium,
/*----------------------------------------------------------------------------------------------------
                                    Transfer - Receive Button Row
----------------------------------------------------------------------------------------------------*/

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration:
                                    model.sharedService.gradientBoxDecoration(),
                                child: FlatButton(
                                  textColor: Colors.white,
                                  onPressed: () {
                                    model.isBusy
                                        ? print('busy')
                                        : model.transfer();
                                  },
                                  child: Text(
                                      AppLocalizations.of(context).tranfser,
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
                              child: OutlineButton(
                                borderSide: BorderSide(color: primaryColor),
                                padding: EdgeInsets.all(15),
                                color: primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  model.isBusy
                                      ? print('busy')
                                      : model.showBarcode();
                                },
                                child: Text(
                                    AppLocalizations.of(context).receive,
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ),
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
            ));
  }
}
