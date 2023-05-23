import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/register_account_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignRegisterAccountScreen extends StatelessWidget {
  const CampaignRegisterAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScreen<CampaignRegisterAccountScreenState>(
      onModelReady: (model) async {
        model.context = context;
        await model.init();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.register,
            style: Theme.of(context).textTheme.displaySmall,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 5.0),
                  margin: const EdgeInsets.all(10.0),
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
                                      semanticLabel:
                                          AppLocalizations.of(context)!
                                              .enterYourEmail,
                                    ),
                                    labelText: AppLocalizations.of(context)!
                                        .enterYourEmail,
                                    labelStyle:
                                        Theme.of(context).textTheme.titleLarge),
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
                                          icon: const Icon(
                                              Icons.enhanced_encryption),
                                          iconSize: 16,
                                          tooltip: AppLocalizations.of(context)!
                                              .showPassword,
                                          onPressed: () {
                                            model.showPasswordText(false);
                                          },
                                        ),
                                        labelText: AppLocalizations.of(context)!
                                            .enterPassword,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
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
                                          icon:
                                              const Icon(Icons.remove_red_eye),
                                          iconSize: 16,
                                          tooltip: AppLocalizations.of(context)!
                                              .showPassword,
                                          onPressed: () {
                                            model.showPasswordText(true);
                                          },
                                        ),
                                        labelText: AppLocalizations.of(context)!
                                            .enterPassword,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
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
                                        labelText: AppLocalizations.of(context)!
                                            .confirmPassword,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
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
                                        labelText: AppLocalizations.of(context)!
                                            .confirmPassword,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
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
                                  debugPrint(value.toString());
                                },
                                controller:
                                    model.exgWalletAddressTextController,
                                style: const TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                          Icons.account_balance_wallet),
                                      iconSize: 16,
                                      onPressed: () {
                                        model.pasteClipboardText();
                                      },
                                    ),
                                    labelText: AppLocalizations.of(context)!
                                        .pasteExgAddress,
                                    labelStyle:
                                        Theme.of(context).textTheme.titleLarge),
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
                                  debugPrint(value.toString());
                                },
                                controller: model.referralCodeTextController,
                                style: const TextStyle(
                                  color: globals.white54,
                                ),
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.device_hub,
                                      size: 16,
                                      semanticLabel:
                                          AppLocalizations.of(context)!
                                              .referralCode,
                                    ),
                                    labelText: AppLocalizations.of(context)!
                                        .referralCode,
                                    labelStyle:
                                        Theme.of(context).textTheme.titleLarge),
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
                            const Icon(
                              Icons.error_outline,
                              color: globals.red,
                              size: 16,
                            ),
                            Text(' ${model.errorMessage}',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium),
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
                              margin: const EdgeInsets.only(right: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(2.0),
                                  backgroundColor: Theme.of(context).cardColor,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                ),
                                child: Text(
                                    '${AppLocalizations.of(context)!
                                            .alreadyHaveAnAccount}?',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('/campaignLogin');
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(2.0),
                                backgroundColor: globals.secondaryColor,
                                elevation: 5,
                                shape: const StadiumBorder(
                                  side: BorderSide(
                                    color: globals.primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: model.busy == true
                                  ? Shimmer.fromColors(
                                      baseColor: globals.primaryColor,
                                      highlightColor: globals.grey,
                                      child: Text(
                                        (AppLocalizations.of(context)!.signUp),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ))
                                  : Text(
                                      (AppLocalizations.of(context)!.signUp),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
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
