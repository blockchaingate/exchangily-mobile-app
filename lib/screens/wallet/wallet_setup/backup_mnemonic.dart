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
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
        elevation: 0,
        title: Text(AppLocalizations.of(context).backupMnemonic,
            style: Theme.of(context).textTheme.headline3),
        backgroundColor: globals.secondaryColor,
        actions: <Widget>[
          // action button
          IconButton(
              icon: Icon(
                MdiIcons.helpCircleOutline,
                size: 18,
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32.0, horizontal: 20),
                        children: [
                          Container(
                              child: Text(
                            AppLocalizations.of(context)
                                .backupMnemonicNoticeTitle,
                            // textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline3,
                          )),
                          SizedBox(height: 20),
                          Container(
                              // padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                            AppLocalizations.of(context)
                                .backupMnemonicNoticeContent,
                            style: Theme.of(context).textTheme.headline5,
                          ))
                        ],
                      );
                    });
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UIHelper.verticalSpaceMedium,
            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                  color: globals.primaryColor,
                  borderRadius: BorderRadius.circular(30)
                  // shape: BoxShape.circle
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.information,
                    color: globals.white,
                    size: 25,
                  ),
                  SizedBox(width: 5),
                  Text(
                    AppLocalizations.of(context).important,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 16),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  AppLocalizations.of(context).warningBackupMnemonic,
                  style: Theme.of(context).textTheme.headline5,
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
            // UIHelper.verticalSpaceSmall,
            Center(
              child: Container(
                padding: EdgeInsets.all(15),
                child: MaterialButton(
                  color: primaryColor,
                  child: Text(
                    AppLocalizations.of(context).confirm,
                    // style: Theme.of(context).textTheme.headline4,
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/confirmMnemonic',
                        arguments:
                            BackupMnemonicWalletScreen.randomMnemonicList);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonGrid() => GridView.extent(
      physics: NeverScrollableScrollPhysics(),
      maxCrossAxisExtent: 125,
      padding: const EdgeInsets.all(2),
      mainAxisSpacing: 20,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      childAspectRatio: 2.2,
      children: _buildButtonGrid(12));

  List<Container> _buildButtonGrid(int count) => List.generate(count, (i) {
        var singleWord = BackupMnemonicWalletScreen.randomMnemonicList[i];
        return Container(
            child: TextField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical(y: 0.8),
          enableInteractiveSelection: false, // readonly
          // enabled: false, // if false use cant see the selection border around
          readOnly: true,
          autocorrect: false,
          decoration: InputDecoration(
            // alignLabelWithHint: true,
            fillColor: globals.primaryColor,
            filled: true,
            hintText: '$singleWord',
            hintMaxLines: 1,
            hintStyle:
                TextStyle(color: globals.white, fontWeight: FontWeight.w600),
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
