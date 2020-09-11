import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/bindpay/bindpay_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BindpayView extends StatelessWidget {
  const BindpayView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BindpayViewmodel>.reactive(
        viewModelBuilder: () => BindpayViewmodel(),
        onModelReady: (model) {},
        builder: (context, model, _) => Scaffold(
              appBar: AppBar(title: Text('Bindpay'), centerTitle: true),
              body: Container(
                margin: EdgeInsets.all(10.0),
                child: model.hasError
                    ? Container(
                        child: Center(child: Text('Ticker data fetch failed')),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          !model.dataReady
                              ? Center(
                                  child: CircularProgressIndicator(
                                  backgroundColor: red,
                                ))
                              :
                              // Coin list dropdown
                              DropdownButtonHideUnderline(
                                  child: model.tickerNameList == null
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          backgroundColor: yellow,
                                        ))
                                      : DropdownButton(
                                          iconEnabledColor: primaryColor,
                                          iconSize: 26,
                                          hint: Text(
                                            AppLocalizations.of(context)
                                                .changeWalletLanguage,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                          value: model.tickerName,
                                          onChanged: (newValue) {
                                            model.updateSelectedTickername(
                                                newValue);
                                          },
                                          items: [
                                              for (var i;
                                                  i <
                                                      model.tickerNameList
                                                          .length;
                                                  i++)
                                                DropdownMenuItem(
                                                  child: Text(
                                                      model.tickerNameList[i]
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6),
                                                  value:
                                                      model.tickerNameList[0],
                                                )
                                            ]),
                                ),
                          // Receiver Address textfield
                          UIHelper.verticalSpaceSmall,
                          TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Color(0XFF871fff),
                                          width: 1.0)),
                                  hintText: AppLocalizations.of(context)
                                      .recieveAddress,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(fontWeight: FontWeight.w300)),
                              controller: model.amountController,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.w300)),
                          // Transfer amount textfield
                          UIHelper.verticalSpaceSmall,
                          TextField(
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Color(0XFF871fff),
                                          width: 1.0)),
                                  hintText:
                                      AppLocalizations.of(context).enterAmount,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      .copyWith(fontWeight: FontWeight.w300)),
                              controller: model.amountController,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(fontWeight: FontWeight.w300)),

                          UIHelper.verticalSpaceMedium,

                          // Transfer - Receive Button Row
                          Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  padding: EdgeInsets.all(15),
                                  color: primaryColor,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    model.checkPass();
                                  },
                                  child: model.isBusy
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ))
                                      : Text(
                                          AppLocalizations.of(context).tranfser,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                ),
                              ),
                              UIHelper.horizontalSpaceSmall,
                              // Receive Button
                              Expanded(
                                child: OutlineButton(
                                  borderSide: BorderSide(color: primaryColor),
                                  padding: EdgeInsets.all(15),
                                  color: primaryColor,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    model.navigationService.navigateTo(
                                        '/receive',
                                        arguments: model.tickerName);
                                  },
                                  child: model.isBusy
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ))
                                      : Text(
                                          AppLocalizations.of(context).receive,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            ));
  }
}
