import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/settings/settings_viewmodel.dart';

import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SettingsPortableView extends StatelessWidget {
  const SettingsPortableView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewmodel>.reactive(
      onModelReady: (model) async {
        model.context = context;
        await model.init();
      },
      viewModelBuilder: () => SettingsViewmodel(),
      builder: (context, model, _) => Scaffold(
        // When the keyboard appears, the Flutter widgets resize to avoid that we use resizeToAvoidBottomInset: false
        resizeToAvoidBottomInset: false,

        body: model.isBusy
            ? Center(child: model.sharedService.loadingIndicator())
            : SettingsPortableContainer(model: model),
      ),
    );
  }
}

class SettingsPortableContainer extends StatelessWidget {
  const SettingsPortableContainer({Key key, this.model}) : super(key: key);
  final SettingsViewmodel model;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        //  alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              UIHelper.verticalSpaceLarge,
              // Container(
              //   margin: EdgeInsets.only(left: 8.0),
              //   child: Theme.of(context).platform == TargetPlatform.iOS
              //       ? CupertinoPicker(
              //           diameterRatio: 1.3,
              //           offAxisFraction: 5,
              //           scrollController: model.scrollController,
              //           itemExtent: 50,
              //           onSelectedItemChanged: (int value) {
              //             String lang = '';
              //             if (value == 1) {
              //               lang = 'en';
              //             } else if (value == 2) {
              //               lang = 'zh';
              //             }
              //             model.changeWalletLanguage(lang);
              //           },
              //           children: [
              //               Center(
              //                 child: Text(
              //                   AppLocalizations.of(context)
              //                       .changeWalletLanguage,
              //                   style: Theme.of(context).textTheme.headline5,
              //                 ),
              //               ),
              //               Center(
              //                 child: Text(
              //                   "English",
              //                   style: Theme.of(context).textTheme.headline5,
              //                 ),
              //               ),
              //               Center(
              //                 child: Text(
              //                   "简体中文",
              //                   style: Theme.of(context).textTheme.headline5,
              //                 ),
              //               ),
              //             ])
              //       : DropdownButtonHideUnderline(
              //           child: DropdownButton(
              //               isExpanded: true,
              //               iconEnabledColor: primaryColor,
              //               iconSize: 30,
              //               hint: Row(
              //                 children: [
              //                   Padding(
              //                     padding: const EdgeInsets.only(right: 4.0),
              //                     child: Icon(Icons.language,
              //                         color: white, size: 16),
              //                   ),
              //                   Text(
              //                     AppLocalizations.of(context)
              //                         .changeWalletLanguage,
              //                     textAlign: TextAlign.center,
              //                     style: Theme.of(context).textTheme.headline5,
              //                   )
              //                 ],
              //               ),
              //               value: model.selectedLanguage,
              //               onChanged: (newValue) {
              //                 model.changeWalletLanguage(newValue);
              //                 model.navigationService.navigateUsingpopAndPushedNamed('buysell');
              //               },
              //               items: [
              //                 DropdownMenuItem(
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: [
              //                       Image.asset(
              //                         "assets/images/img/flagEn.png",
              //                         width: 20,
              //                         height: 20,
              //                       ),
              //                       SizedBox(width: 15),
              //                       Text("English",
              //                           textAlign: TextAlign.center,
              //                           style: Theme.of(context)
              //                               .textTheme
              //                               .headline6),
              //                     ],
              //                   ),
              //                   value: model.languages[0],
              //                 ),
              //                 DropdownMenuItem(
              //                   child: Row(
              //                     mainAxisSize: MainAxisSize.min,
              //                     // mainAxisAlignment: MainAxisAlignment.center,
              //                     children: [
              //                       Image.asset(
              //                         "assets/images/img/flagChina.png",
              //                         width: 20,
              //                         height: 20,
              //                       ),
              //                       SizedBox(width: 15),
              //                       Text("简体中文",
              //                           textAlign: TextAlign.center,
              //                           style: Theme.of(context)
              //                               .textTheme
              //                               .headline6),
              //                     ],
              //                   ),
              //                   value: model.languages[1],
              //                 ),
              //               ]),
              //         ),
              // ),
              // UIHelper.verticalSpaceSmall,
              // Show/Hide dialog warning checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(Icons.warning, color: yellow, size: 16),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(AppLocalizations.of(context).showDialogWarnings,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.left),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 20,
                      child: Switch(
                          inactiveThumbColor: grey,
                          activeTrackColor: white,
                          activeColor: primaryColor,
                          inactiveTrackColor: white,
                          value: model.isDialogDisplay,
                          onChanged: (value) {
                            model.setIsDialogWarningValue(value);
                          }),
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpaceMedium,
              // Showcase ON/OFF
              Row(
                //  crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(Icons.insert_comment, color: white, size: 16),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                        AppLocalizations.of(context)
                            .settingsShowcaseInstructions,
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.left),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 20,
                      child: Switch(
                          inactiveThumbColor: grey,
                          activeTrackColor: white,
                          activeColor: primaryColor,
                          inactiveTrackColor: white,
                          value: !model.isShowCaseOnce,
                          onChanged: (value) {
                            model.storageService.isShowCaseView = !value;

                            model.setBusy(true);
                            // get new value and assign it to the viewmodel variable
                            model.isShowCaseOnce =
                                model.storageService.isShowCaseView;
                            model.setBusy(false);
                            debugPrint(model.isShowCaseOnce.toString());
                          }),
                    ),
                  ),
                ],
              ),
            ]));
  }
}
