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
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/create_password_viewmodel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';

class CreatePasswordScreen extends StatefulWidget {
  final args;
  const CreatePasswordScreen({Key key, this.args}) : super(key: key);

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final log = getLogger('CreatePassword');
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CreatePasswordViewModel(),
      onModelReady: (model) {
        model.randomMnemonicFromRoute = widget.args['mnemonic'];
        model.context = context;
        model.errorMessage = '';
        model.passwordMatch = false;
      },
      builder: (context, CreatePasswordViewModel model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(FlutterI18n.translate(context, "secureYourWallet"),
              style: Theme.of(context).textTheme.headline4),
          backgroundColor: secondaryColor,
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                UIHelper.verticalSpaceSmall,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      FlutterI18n.translate(context, "setPasswordConditions"),
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.left,
                    ),
                    UIHelper.verticalSpaceSmall,
                    _buildPasswordTextField(model),
                    UIHelper.verticalSpaceSmall,
                    _buildConfirmPasswordTextField(model),
                    model.password != ''
                        ? model.passwordMatch
                            ? Center(
                                child: Text(
                                FlutterI18n.translate(
                                    context, "passwordMatched"),
                                style: TextStyle(color: white),
                              ))
                            : model.password.isEmpty ||
                                    model.confirmPassword.isEmpty
                                ? Text('')
                                : Center(
                                    child: Text(
                                        FlutterI18n.translate(
                                            context, "passwordDoesNotMatched"),
                                        style: TextStyle(color: grey)))
                        : Text(''),
                    UIHelper.verticalSpaceSmall,
                    Center(
                        child: Text(model.errorMessage,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: red))),
                    UIHelper.verticalSpaceLarge,
                    UIHelper.verticalSpaceLarge,
                    Center(
                      child: model.isBusy
                          ? Shimmer.fromColors(
                              baseColor: primaryColor,
                              highlightColor: grey,
                              child: Text(
                                widget.args['isImport']
                                    ? FlutterI18n.translate(
                                        context, "importingWallet")
                                    : FlutterI18n.translate(
                                        context, "creatingWallet"),
                                style: Theme.of(context).textTheme.button,
                              ),
                            )
                          : _buildCreateNewWalletButton(model, context),
                    ),
                    UIHelper.verticalSpaceLarge,
                    Text(
                      FlutterI18n.translate(context, "setPasswordNote"),
                      textAlign: TextAlign.left,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ],
            )),
        // floatingActionButton: TextButton(
        //     onPressed: () => model.coreWalletDatabaseService.initDb(),
        //     child: Text('click')),
      ),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Password

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildPasswordTextField(CreatePasswordViewModel model) {
    return TextField(
        onChanged: (String pass) {
          model.checkPassword(pass);
        },
        keyboardType: TextInputType.visiblePassword,
        focusNode: model.passFocus,
        autofocus: true,
        controller: model.passTextController,
        obscureText: true,
        maxLength: 32,
        style: model.checkPasswordConditions
            ? TextStyle(color: primaryColor, fontSize: 16)
            : TextStyle(color: grey, fontSize: 16),
        decoration: InputDecoration(
            suffixIcon:
                model.checkPasswordConditions && model.password.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Icon(Icons.check, color: primaryColor))
                    : Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: Icon(Icons.clear, color: grey)),
            labelText: FlutterI18n.translate(context, "enterPassword"),
            prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
            labelStyle: Theme.of(context).textTheme.headline5,
            helperStyle: Theme.of(context).textTheme.headline5));
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Confirm Password

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildConfirmPasswordTextField(CreatePasswordViewModel model) {
    return TextField(
        onChanged: (String pass) {
          model.checkConfirmPassword(pass);
        },
        controller: model.confirmPassTextController,
        obscureText: true,
        maxLength: 32,
        style: model.checkConfirmPasswordConditions
            ? TextStyle(color: primaryColor, fontSize: 16)
            : TextStyle(color: grey, fontSize: 16),
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            suffixIcon: model.checkConfirmPasswordConditions &&
                    model.confirmPassword.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Icon(Icons.check, color: primaryColor))
                : Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: Icon(Icons.clear, color: grey)),
            labelText: FlutterI18n.translate(context, "confirmPassword"),
            prefixIcon: Icon(Icons.lock, color: Colors.white),
            labelStyle: Theme.of(context).textTheme.headline5,
            helperStyle: Theme.of(context).textTheme.headline5));
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Create New Wallet Button

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildCreateNewWalletButton(
      CreatePasswordViewModel model, BuildContext context) {
    return ButtonTheme(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
      minWidth: double.infinity,
      child: MaterialButton(
        padding: EdgeInsets.all(15),
        color: primaryColor,
        textColor: Colors.white,
        onPressed: () {
          // Remove the on screen keyboard by shifting focus to unused focus node

          FocusScope.of(context).requestFocus(FocusNode());
          model.validatePassword();
        },
        child: Text(
          widget.args['isImport']
              ? FlutterI18n.translate(context, "importWallet")
              : FlutterI18n.translate(context, "createWallet"),
          style: Theme.of(context)
              .textTheme
              .headline4
              .copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
