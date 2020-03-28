import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/login_screen_state.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignLoginScreen extends StatelessWidget {
  const CampaignLoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignLoginScreenState>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                margin: EdgeInsets.all(10.0),
                color: globals.walletCardColor,
                child: Column(
                  children: <Widget>[
                    // Email row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Email',
                              style: Theme.of(context).textTheme.headline5,
                              //  textAlign: TextAlign.center,
                            )),
                        Expanded(
                            flex: 2,
                            child: TextField(
                              controller: model.emailTextController,
                              keyboardType: TextInputType.emailAddress,
                            ))
                      ],
                    ),
                    // Password row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Password',
                              style: Theme.of(context).textTheme.headline5,
                              // textAlign: TextAlign.center,
                            )),
                        Expanded(
                            flex: 2,
                            child: TextField(
                              controller: model.passwordTextController,
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                            ))
                      ],
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Visibility(
                        visible: model.error,
                        child: model.busy == true
                            ? Text('Loading...')
                            : Text(model.errorMessage,
                                style: Theme.of(context).textTheme.bodyText2)),
                    UIHelper.horizontalSpaceSmall,
                    // Button row
                    Row(
                      children: <Widget>[
                        // Expanded(
                        //   child: Container(
                        //     margin: EdgeInsets.only(right: 5),
                        //     child: RaisedButton(
                        //       padding: EdgeInsets.all(2.0),
                        //       elevation: 5,
                        //       focusElevation: 5,
                        //       child: Text('Delete Db',
                        //           style: Theme.of(context).textTheme.headline4),
                        //       onPressed: () {
                        //         model.deleteDb();
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 5),
                            child: RaisedButton(
                              padding: EdgeInsets.all(2.0),
                              elevation: 5,
                              focusElevation: 5,
                              child: Text('Register',
                                  style: Theme.of(context).textTheme.headline4),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/campaignRegisterAccount');
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.all(2.0),
                            elevation: 5,
                            shape: StadiumBorder(
                                side: BorderSide(
                                    color: globals.primaryColor, width: 2)),
                            color: globals.secondaryColor,
                            child: model.busy == true
                                ? Shimmer.fromColors(
                                    baseColor: globals.primaryColor,
                                    highlightColor: globals.grey,
                                    child: Text(
                                      ('Login'),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ))
                                : Text(
                                    ('Login'),
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                            onPressed: () {
                              model.checkCredentials();
                            },
                          ),
                        )
                      ],
                    ),
                    UIHelper.horizontalSpaceMedium
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
