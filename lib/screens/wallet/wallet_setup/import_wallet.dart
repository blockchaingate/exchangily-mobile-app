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

import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/confirm_mnemonic_viemodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/confirm_mnemonic/verify_mnemonic.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';

class ImportWalletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var storageService = locator<LocalStorageService>();
    print('is Dark: ${storageService.isDarkMode}}');
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ConfirmMnemonicViewmodel(),
      onViewModelReady: (dynamic model) {
        model.route = 'import';
      },
      builder: (context, ConfirmMnemonicViewmodel model, child) => Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              FlutterI18n.translate(context, "importWallet"),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            backgroundColor: Theme.of(context).canvasColor.withOpacity(0.2)),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              VerifyMnemonicWalletView(
                mnemonicTextController: model.controller,
                count: model.count,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  style: generalButtonStyle1,
                  child: Text(
                    FlutterI18n.translate(context, "confirm"),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  onPressed: () {
                    model.verifyMnemonic(
                        model.controller, context, model.count, model.route);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
