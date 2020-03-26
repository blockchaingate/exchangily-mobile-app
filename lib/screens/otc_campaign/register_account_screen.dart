import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class CampaignRegisterAccountScreen extends StatelessWidget {
  const CampaignRegisterAccountScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Register',
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                  margin: EdgeInsets.all(10.0),
                  color: globals.walletCardColor,
                  child: Column(
                    children: <Widget>[
                      // Email row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: TextField(
                                style: TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    labelText: 'Enter your email',
                                    labelStyle:
                                        Theme.of(context).textTheme.headline6),
                                keyboardType: TextInputType.emailAddress,
                              ))
                        ],
                      ),
                      // Password row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: TextField(
                                style: TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    labelText: 'Enter password',
                                    labelStyle:
                                        Theme.of(context).textTheme.headline6),
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                              ))
                        ],
                      ),
                      // Confirm password row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: TextField(
                                style: TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    labelText: 'Confirm your password',
                                    labelStyle:
                                        Theme.of(context).textTheme.headline6),
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                              ))
                        ],
                      ),
                      UIHelper.horizontalSpaceSmall,
                      Text('Error/warning goes here',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2),

                      UIHelper.horizontalSpaceSmall,
                      // Button row
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.only(right: 5),
                              child: RaisedButton(
                                padding: EdgeInsets.all(2.0),
                                elevation: 5,
                                focusElevation: 5,
                                child: Text('Already have an account?',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.headline4),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/campaignLogin');
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              padding: EdgeInsets.all(2.0),
                              elevation: 5,
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color: globals.primaryColor, width: 2)),
                              color: globals.secondaryColor,
                              child: Text(
                                ('Signup'),
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/importWallet',
                                    arguments: 'import');
                              },
                            ),
                          )
                        ],
                      ),
                      UIHelper.horizontalSpaceMedium
                    ],
                  )),
            ]));
  }
}
