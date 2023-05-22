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

import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/confirm_mnemonic_viemodel.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/confirm_mnemonic/verify_mnemonic.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../shared/globals.dart' as globals;

class ImportWalletView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ConfirmMnemonicViewmodel(),
      onViewModelReady: (dynamic model) {
        model.route = 'import';
      },
      builder: (context, ConfirmMnemonicViewmodel model, child) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.importWallet,
              style: const TextStyle(fontSize: 14),
            ),
            backgroundColor: globals.secondaryColor),
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
                  child: Text(
                    AppLocalizations.of(context)!.confirm,
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
