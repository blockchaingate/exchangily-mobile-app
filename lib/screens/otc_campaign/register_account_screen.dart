import 'package:exchangilymobileapp/screen_state/otc_campaign/register_account_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignRegisterAccountScreen extends StatelessWidget {
  const CampaignRegisterAccountScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignRegisterAccountScreenState>(
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Register',
            style: Theme.of(context).textTheme.headline3,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UIHelper.verticalSpaceLarge,
              UIHelper.verticalSpaceLarge,
              UIHelper.verticalSpaceMedium,
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
                                controller: model.emailTextController,
                                style: TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.email,
                                      size: 16,
                                      semanticLabel: 'enter your email',
                                    ),
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
                          model.isPasswordTextVisible == true
                              ? Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: model.passwordTextController,
                                    style: TextStyle(
                                      color: globals.white54,
                                    ),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.enhanced_encryption),
                                          iconSize: 16,
                                          tooltip: 'Click to see the password',
                                          onPressed: () {
                                            model.showPasswordText(false);
                                          },
                                        ),
                                        labelText: 'Enter password',
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    obscureText: false,
                                    keyboardType: TextInputType.visiblePassword,
                                  ))
                              : Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: model.passwordTextController,
                                    style: TextStyle(
                                      color: globals.white54,
                                    ),
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye),
                                          iconSize: 16,
                                          tooltip: 'Click to see the password',
                                          onPressed: () {
                                            model.showPasswordText(true);
                                          },
                                        ),
                                        labelText: 'Enter password',
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                  ))
                        ],
                      ),
                      // Confirm password row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          model.isPasswordTextVisible == true
                              ? Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller:
                                        model.confirmPasswordTextController,
                                    style: TextStyle(
                                      color: globals.white54,
                                    ),
                                    decoration: InputDecoration(
                                        labelText: 'Confirm your password',
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    obscureText: false,
                                    keyboardType: TextInputType.visiblePassword,
                                  ))
                              : Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller:
                                        model.confirmPasswordTextController,
                                    style: TextStyle(
                                      color: globals.white54,
                                    ),
                                    decoration: InputDecoration(
                                        labelText: 'Confirm your password',
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                  ))
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: TextField(
                                onChanged: (value) {
                                  print(value);
                                },
                                controller:
                                    model.exgWalletAddressTextController,
                                style: TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.account_balance_wallet),
                                      iconSize: 16,
                                      onPressed: () {
                                        model.pasteClipboardText();
                                      },
                                    ),
                                    labelText: 'Exg Wallet Address',
                                    labelStyle:
                                        Theme.of(context).textTheme.headline6),
                              ))
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: TextField(
                                onChanged: (value) {
                                  print(value);
                                },
                                controller: model.referralCodeTextController,
                                style: TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.device_hub,
                                      size: 16,
                                      semanticLabel: 'referral code',
                                    ),
                                    labelText: 'Referral code',
                                    labelStyle:
                                        Theme.of(context).textTheme.headline6),
                              ))
                        ],
                      ),
                      UIHelper.verticalSpaceMedium,
                      //----------------------- Error goes here
                      Visibility(
                        visible: model.errorMessage != '' &&
                            model.errorMessage != null,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.error_outline,
                              color: globals.red,
                              size: 16,
                            ),
                            Text(' ${model.errorMessage}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2),
                          ],
                        ),
                      ),

                      UIHelper.verticalSpaceSmall,
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
                              child: model.busy == true
                                  ? Shimmer.fromColors(
                                      baseColor: globals.primaryColor,
                                      highlightColor: globals.grey,
                                      child: Text(
                                        ('Signup'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ))
                                  : Text(
                                      ('Signup'),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                              onPressed: () {
                                model.checkInputValues();
                              },
                            ),
                          )
                        ],
                      ),
                      UIHelper.verticalSpaceMedium
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
