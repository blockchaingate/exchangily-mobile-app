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
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/create_password_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/wallet/toggle_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stacked/stacked.dart';

class CreatePasswordScreen extends StatefulWidget {
  final args;
  const CreatePasswordScreen({Key? key, this.args}) : super(key: key);

  @override
  CreatePasswordScreenState createState() => CreatePasswordScreenState();
}

class CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final log = getLogger('CreatePassword');
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => CreatePasswordViewModel(),
      onViewModelReady: (dynamic model) {
        model.randomMnemonicFromRoute = widget.args['mnemonic'];
        model.context = context;
        model.errorMessage = '';
        model.passwordMatch = false;
      },
      builder: (context, CreatePasswordViewModel model, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(FlutterI18n.translate(context, "secureYourWallet"),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: getTextColor(primaryColor))),
          backgroundColor: primaryColor.withOpacity(0.85),
        ),
        body: Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(15),
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
                      style: Theme.of(context).textTheme.bodyLarge,
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
                                style: const TextStyle(color: white),
                              ))
                            : model.password.isEmpty ||
                                    model.confirmPassword.isEmpty
                                ? const Text('')
                                : Center(
                                    child: Text(
                                        FlutterI18n.translate(
                                            context, "passwordDoesNotMatched"),
                                        style: const TextStyle(color: grey)))
                        : const Text(''),
                    UIHelper.verticalSpaceSmall,
                    Center(
                        child: Text(model.errorMessage,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
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
                                style: Theme.of(context).textTheme.labelLarge,
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
                          .headlineSmall!
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
    return TextFormField(
        onChanged: (String pass) {
          model.checkPassword(pass);
        },
        keyboardType: TextInputType.visiblePassword,
        focusNode: model.passFocus,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, model.passFocus, model.confirmPassFocus);
        },
        autofocus: true,
        controller: model.passTextController,
        obscureText: model.isShowPassword ? false : true,
        maxLength: 32,
        textInputAction: TextInputAction.next,
        style: model.checkPasswordConditions
            ? const TextStyle(color: primaryColor, fontSize: 16)
            : const TextStyle(color: grey, fontSize: 16),
        decoration: InputDecoration(
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: model.checkPasswordConditions &&
                            model.password.isNotEmpty
                        ? const Icon(
                            Icons.check,
                            color: primaryColor,
                            size: 18,
                          )
                        : const Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: grey,
                            size: 18,
                          )),
                TogglePasswordWidget(
                    isShow: model.isShowPassword,
                    togglePassword: model.togglePassword)
              ],
            ),
            labelText: FlutterI18n.translate(context, "enterPassword"),
            prefixIcon: const Icon(Icons.lock_outline, color: grey),
            labelStyle: Theme.of(context).textTheme.headlineSmall,
            helperStyle: Theme.of(context).textTheme.headlineSmall));
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Confirm Password

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget _buildConfirmPasswordTextField(CreatePasswordViewModel model) {
    return TextFormField(
        onChanged: (String pass) {
          model.checkConfirmPassword(pass);
        },
        controller: model.confirmPassTextController,
        focusNode: model.confirmPassFocus,
        obscureText: model.isShowPassword ? false : true,
        onFieldSubmitted: (term) {
          model.confirmPassFocus.unfocus();
          model.validatePassword();
        },
        maxLength: 32,
        cursorColor: Theme.of(context).hintColor,
        style: model.checkConfirmPasswordConditions
            ? const TextStyle(color: primaryColor, fontSize: 16)
            : const TextStyle(color: grey, fontSize: 16),
        decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.white),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: model.checkConfirmPasswordConditions &&
                            model.password.isNotEmpty
                        ? const Icon(
                            Icons.check,
                            color: primaryColor,
                            size: 18,
                          )
                        : const Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: grey,
                            size: 18,
                          )),
                TogglePasswordWidget(
                    isShow: model.isShowPassword,
                    togglePassword: model.togglePassword)
              ],
            ),
            labelText: FlutterI18n.translate(context, "confirmPassword"),
            prefixIcon: const Icon(Icons.lock, color: grey),
            labelStyle: Theme.of(context).textTheme.headlineSmall,
            helperStyle: Theme.of(context).textTheme.headlineSmall));
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Widget Create New Wallet Button

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Widget _buildCreateNewWalletButton(
      CreatePasswordViewModel model, BuildContext context) {
    return ButtonTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      minWidth: double.infinity,
      child: MaterialButton(
        padding: const EdgeInsets.all(15),
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
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w400, color: getTextColor(primaryColor)),
        ),
      ),
    );
  }
}
