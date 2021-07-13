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
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/confirm_mnemonic_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/screens/wallet/wallet_setup/confirm_mnemonic/verify_mnemonic.dart';
import 'package:flutter/material.dart';
import '../../../logger.dart';
import '../../../shared/globals.dart' as globals;

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({Key key}) : super(key: key);

  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  final log = getLogger('Import Wallet');
  final count = 12;
  String route = '';
  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controller = [];
    return BaseScreen<ConfirmMnemonicScreenState>(
      onModelReady: (model) {
        route = 'import';
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(AppLocalizations.of(context).importWallet),
            backgroundColor: globals.secondaryColor),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              VerifyMnemonicWalletView(
                mnemonicTextController: controller,
                count: count,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text(
                    AppLocalizations.of(context).confirm,
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    model.verifyMnemonic(controller, context, count, route);
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
