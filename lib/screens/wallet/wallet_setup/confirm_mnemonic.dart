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
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_setup/confirm_mnemonic_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/verify_mnemonic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;
import '../../base_screen.dart';

class ConfirmMnemonictWalletScreen extends StatefulWidget {
  final List<String> randomMnemonicListFromRoute;
  const ConfirmMnemonictWalletScreen(
      {Key key, this.randomMnemonicListFromRoute})
      : super(key: key);

  @override
  _ConfirmMnemonictWalletScreenState createState() =>
      _ConfirmMnemonictWalletScreenState();
}

class _ConfirmMnemonictWalletScreenState
    extends State<ConfirmMnemonictWalletScreen> {
  final log = getLogger('Confirm Mnemonic');
  List<TextEditingController> controller = new List();
  final int count = 12;

  @override
  Widget build(BuildContext context) {
    return BaseScreen<ConfirmMnemonicScreenState>(
      onModelReady: (model) {
        model.randomMnemonicList = widget.randomMnemonicListFromRoute;
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context).confirm +
                  AppLocalizations.of(context).mnemonic,
              style: Theme.of(context).textTheme.headline3,
            ),
            backgroundColor: globals.secondaryColor),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                UIHelper.verticalSpaceSmall,
                VerifyMnemonicWalletScreen(
                  mnemonicTextController: controller,
                  count: count,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: RaisedButton(
                    child: Text(
                      AppLocalizations.of(context).finishWalletBackup,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    onPressed: () {
                      model.verifyMnemonic(
                          controller, context, count, 'create');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
