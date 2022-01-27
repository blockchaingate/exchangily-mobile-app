import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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
        padding: EdgeInsets.all(10.0),
        //  alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              UIHelper.verticalSpaceLarge,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(Icons.warning, color: yellow, size: 16),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                        FlutterI18n.translate(context, "showDialogWarnings"),
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
                        FlutterI18n.translate(
                            context, "settingsShowcaseInstructions"),
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
                            print(model.isShowCaseOnce);
                          }),
                    ),
                  ),
                ],
              ),
            ]));
  }
}
