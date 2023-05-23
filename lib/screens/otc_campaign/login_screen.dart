import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/screen_state/otc_campaign/login_screen_state.dart';
import 'package:shimmer/shimmer.dart';
import '../../shared/globals.dart' as globals;

class CampaignLoginScreen extends StatelessWidget {
  final String? errorMessage;
  const CampaignLoginScreen({Key? key, this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('ERROR MSG FROM ROUTE $errorMessage');
    return BaseScreen<CampaignLoginScreenState>(
      onModelReady: (model) async {
        model.context = context;
        //  await model.init();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () {
          model.onBackButtonPressed();
          return;
        } as Future<bool> Function()?,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.login,
                style: Theme.of(context).textTheme.displaySmall),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                margin: const EdgeInsets.all(10.0),
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
                                AppLocalizations.of(context)!.email,
                                style: Theme.of(context).textTheme.headlineSmall,
                                //  textAlign: TextAlign.center,
                              ),
                            )),
                        Expanded(
                            flex: 2,
                            child: TextField(
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: const InputDecoration(
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
                                AppLocalizations.of(context)!.password,
                                style: Theme.of(context).textTheme.headlineSmall,
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
                                          tooltip: AppLocalizations.of(context)!
                                              .clickToSeeThePassword,
                                          onPressed: () {
                                            model.setBusy(true);
                                            model.isPasswordTextVisible = false;
                                            model.setBusy(false);
                                          },
                                          icon: const Icon(
                                              Icons.remove_red_eye))),
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
                                          tooltip: AppLocalizations.of(context)!
                                              .clickToSeeThePassword,
                                          onPressed: () {
                                            model.setBusy(true);
                                            model.isPasswordTextVisible = true;
                                            model.setBusy(false);
                                          },
                                          icon: const Icon(
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
                        '${AppLocalizations.of(context)!.forgotPassword}?',
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: globals.white),
                      ),
                      onTap: () => model.resetPassword(),
                    ),
                    UIHelper.verticalSpaceSmall,
                    // Error goes here
                    Visibility(
                        visible: model.hasErrorMessage,
                        child: Text(model.errorMessage!,
                            style: model.isLogging && model.busy
                                ? Theme.of(context).textTheme.bodyMedium
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.yellow))),
                    Visibility(
                        visible: errorMessage != null &&
                            errorMessage != '' &&
                            !model.hasErrorMessage,
                        child: Text(errorMessage ?? '',
                            style: Theme.of(context).textTheme.bodyMedium)),
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
                            margin: const EdgeInsets.only(right: 5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(2.0),
                                backgroundColor: globals.secondaryColor,
                                elevation: 5,
// focusElevation: 5,
                                shape: const StadiumBorder(
                                  side: BorderSide(
                                    color: globals.primaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.register,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/campaignRegisterAccount');
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(2.0),
                              backgroundColor: globals.secondaryColor,
                              elevation: 5,
                              shape: const StadiumBorder(
                                  side: BorderSide(
                                      color: globals.primaryColor, width: 2)),
                            ),
                            child: model.busy == true
                                ? Shimmer.fromColors(
                                    baseColor: globals.primaryColor,
                                    highlightColor: globals.grey,
                                    child: Text(
                                      (AppLocalizations.of(context)!.login),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ))
                                : Text(
                                    (AppLocalizations.of(context)!.login),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
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
