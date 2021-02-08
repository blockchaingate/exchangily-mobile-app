import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;
import 'package:exchangilymobileapp/screen_state/shop/shopLogin_state.dart';

class ShopLoginScreen extends StatelessWidget {
  final String errorMessage;
  const ShopLoginScreen({Key key, this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ERROR MSG FROM ROUTE $errorMessage');
    return BaseScreen<ShopLoginScreenState>(
      onModelReady: (model) async {
        model.context = context;
        //  await model.init();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          model.onBackButtonPressed();
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Ecombar "+AppLocalizations.of(context).login,
                style: Theme.of(context).textTheme.headline3),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                margin: EdgeInsets.all(10.0),
                color: globals.walletCardColor,
                child: Column(
                  children: <Widget>[
                    // Email row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Text(
                                AppLocalizations.of(context).email,
                                style: Theme.of(context).textTheme.headline5,
                                //  textAlign: TextAlign.center,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: TextField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                  isDense: true,
                                  suffixIcon: Icon(
                                    Icons.email,
                                    color: globals.grey,
                                    size: 16,
                                  )),
                              controller: model.emailTextController,
                              keyboardType: TextInputType.emailAddress,
                            ))
                      ],
                    ),
                    // Password row (it has two input expanded widgets one to show the password and another is to hide it)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 7.0),
                              child: Text(
                                AppLocalizations.of(context).password,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            )),
                        model.isPasswordTextVisible == true
                            ? Expanded(
                                flex: 2,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: IconButton(
                                          iconSize: 18,
                                          tooltip: AppLocalizations.of(context)
                                              .clickToSeeThePassword,
                                          onPressed: () {
                                            model.setBusy(true);
                                            model.isPasswordTextVisible = false;
                                            model.setBusy(false);
                                          },
                                          icon: Icon(Icons.remove_red_eye))),
                                  controller: model.passwordTextController,
                                  obscureText: false,
                                  keyboardType: TextInputType.visiblePassword,
                                ))
                            : Expanded(
                                flex: 2,
                                child: TextField(
                                  //   textAlignVertical: TextAlignVertical.bottom,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          iconSize: 18,
                                          tooltip: AppLocalizations.of(context)
                                              .clickToSeeThePassword,
                                          onPressed: () {
                                            model.setBusy(true);
                                            model.isPasswordTextVisible = true;
                                            model.setBusy(false);
                                          },
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: globals.grey,
                                          ))),
                                  controller: model.passwordTextController,
                                  obscureText: true,
                                  keyboardType: TextInputType.visiblePassword,
                                ))
                      ],
                    ),
                    UIHelper.verticalSpaceMedium,
                    InkWell(
                      child: Text(
                        AppLocalizations.of(context).forgotPassword + '?',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: globals.white),
                      ),
                      onTap: () => model.resetPassword(),
                    ),
                    UIHelper.verticalSpaceSmall,
                    // Error goes here
                    Visibility(
                        visible: model.hasErrorMessage,
                        child: Text(model.errorMessage,
                            style: model.isLogging && model.busy
                                ? Theme.of(context).textTheme.bodyText2
                                : Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.yellow))),
                    Visibility(
                        visible: errorMessage != null &&
                            errorMessage != '' &&
                            !model.hasErrorMessage,
                        child: Text(errorMessage == null ? '' : errorMessage,
                            style: Theme.of(context).textTheme.bodyText2)),
                    UIHelper.verticalSpaceSmall,
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
                        //           style: Theme.of(context)
                        //               .textTheme
                        //               .headline4),
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
                              child: Text(AppLocalizations.of(context).register,
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
                                      (AppLocalizations.of(context).login),
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ))
                                : Text(
                                    (AppLocalizations.of(context).login),
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
                    UIHelper.verticalSpaceMedium
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
