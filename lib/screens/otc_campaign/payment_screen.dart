import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/payment_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignPaymentScreen extends StatelessWidget {
  const CampaignPaymentScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignPaymentScreenState>(
      onModelReady: (model) {
        model.initState();
      },
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            title:
                Text('Payment', style: Theme.of(context).textTheme.headline3)),
        // Scaffold body container
        body: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // 1st container row Amount and payment type
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Amount text and input row
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.headline5,
                              )),
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              height: 0,
                              width: 100,
                              child: TextField(
                                cursorColor: globals.primaryColor,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      // Payment type container row
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Payment Type',
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.start,
                            ),
                            // Row that contains both radio buttons
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // USD radio button row
                                  Row(
                                    children: <Widget>[
                                      Text('USD',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Radio(
                                          activeColor: globals.primaryColor,
                                          onChanged: (value) {
                                            model.radioButtonSelection(value);
                                          },
                                          groupValue: model.value,
                                          value: 'USD'),
                                    ],
                                  ),

                                  // USDT radio button row
                                  Row(
                                    children: <Widget>[
                                      Text('USDT',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      Radio(
                                          activeColor: globals.primaryColor,
                                          onChanged: (t) {
                                            model.radioButtonSelection(t);
                                          },
                                          groupValue: model.value,
                                          value: 'USDT'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      UIHelper.horizontalSpaceSmall,
                      // Button row container
                      Container(
                        width: MediaQuery.of(context).size.width - 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: RaisedButton(
                                    padding: EdgeInsets.all(0),
                                    shape: StadiumBorder(
                                        side: BorderSide(
                                            color: globals.primaryColor,
                                            width: 2)),
                                    color: globals.secondaryColor,
                                    child: Text(
                                      AppLocalizations.of(context).cancel,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/walletSetup');
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: RaisedButton(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                      AppLocalizations.of(context).confirm,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/walletSetup');
                                  },
                                ),
                              )
                            ]),
                      )
                    ],
                  ),
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              // 2nd contianer row Order info
              Expanded(
                flex: 5,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  color: globals.walletCardColor,
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                          child: Text('Order Information',
                              style: Theme.of(context).textTheme.headline4)),
                      UIHelper.horizontalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('Time Stamp',
                              style: Theme.of(context).textTheme.bodyText1),
                          Text('Amount',
                              style: Theme.of(context).textTheme.bodyText1),
                          Text('Status',
                              style: Theme.of(context).textTheme.bodyText1)
                        ],
                      ),
                      Divider(color: globals.grey)
                    ],
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
