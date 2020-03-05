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
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import '../../../shared/globals.dart' as globals;

class BackupMnemonicWalletScreen extends StatefulWidget {
  const BackupMnemonicWalletScreen({Key key}) : super(key: key);
  static List<String> randomMnemonicList = [];

  @override
  _BackupMnemonicWalletScreenState createState() =>
      _BackupMnemonicWalletScreenState();
}

class _BackupMnemonicWalletScreenState
    extends State<BackupMnemonicWalletScreen> {
  WalletService walletService = locator<WalletService>();
  @override
  void initState() {
    super.initState();
    final randomMnemonicString = walletService.getRandomMnemonic();
    // convert string to list to iterate and display single word in a textbox
    BackupMnemonicWalletScreen.randomMnemonicList =
        randomMnemonicString.split(" ").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).backupMnemonic,
              style: Theme.of(context).textTheme.headline3),
          backgroundColor: globals.secondaryColor),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            UIHelper.verticalSpaceMedium,
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.note_add,
                      color: globals.primaryColor,
                      size: 30,
                    )),
                Expanded(
                    child: Text(
                  AppLocalizations.of(context).warningBackupMnemonic,
                  style: Theme.of(context).textTheme.headline,
                )),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: _buttonGrid(),
            ),
            UIHelper.verticalSpaceSmall,
            Container(
              padding: EdgeInsets.all(15),
              child: RaisedButton(
                child: Text(
                  AppLocalizations.of(context).confirm,
                  style: Theme.of(context).textTheme.headline4,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/confirmMnemonic',
                      arguments: BackupMnemonicWalletScreen.randomMnemonicList);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonGrid() => GridView.extent(
      maxCrossAxisExtent: 125,
      padding: const EdgeInsets.all(2),
      mainAxisSpacing: 15,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      childAspectRatio: 2,
      children: _buildButtonGrid(12));

  List<Container> _buildButtonGrid(int count) => List.generate(count, (i) {
        var singleWord = BackupMnemonicWalletScreen.randomMnemonicList[i];
        return Container(
            child: TextField(
          textAlign: TextAlign.left,
          enableInteractiveSelection: false, // readonly
          // enabled: false, // if false use cant see the selection border around
          readOnly: true,
          autocorrect: false,
          decoration: InputDecoration(
            fillColor: globals.primaryColor,
            filled: true,
            hintText: '$singleWord',
            hintStyle: TextStyle(color: globals.white),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: globals.white, width: 2),
                borderRadius: BorderRadius.circular(30.0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ));
      });
}
