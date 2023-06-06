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
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../shared/globals.dart' as globals;

class BackupMnemonicView extends StatefulWidget {
  const BackupMnemonicView({Key? key}) : super(key: key);
  static List<String> randomMnemonicList = [];

  @override
  BackupMnemonicViewState createState() => BackupMnemonicViewState();
}

class BackupMnemonicViewState extends State<BackupMnemonicView> {
  WalletService? walletService = locator<WalletService>();
  final NavigationService? navigationService = locator<NavigationService>();
  @override
  void initState() {
    super.initState();
    final randomMnemonicString = walletService!.getRandomMnemonic();
    // convert string to list to iterate and display single word in a textbox
    BackupMnemonicView.randomMnemonicList =
        randomMnemonicString.split(" ").toList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigationService!.navigateTo(WalletSetupViewRoute);
        return Future(() => false);
      },
      child: Scaffold(
        // backgroundColor: ,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(FlutterI18n.translate(context, "backupMnemonic"),
              style: Theme.of(context).textTheme.displaySmall),
          backgroundColor: Theme.of(context).canvasColor.withOpacity(0.5),
          leading: IconButton(
            icon: Icon(MdiIcons.arrowLeft,
                size: 28, color: Theme.of(context).hintColor),
            onPressed: () {
              navigationService!.navigateTo(WalletSetupViewRoute);
            },
          ),
          actions: <Widget>[
            // action button
            IconButton(
                icon: Icon(
                  MdiIcons.helpCircleOutline,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return ListView(
                          padding: const EdgeInsets.symmetric(
                              vertical: 32.0, horizontal: 20),
                          children: [
                            Text(
                              FlutterI18n.translate(
                                  context, "backupMnemonicNoticeTitle"),
                              // textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              FlutterI18n.translate(
                                  context, "backupMnemonicNoticeContent"),
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          ],
                        );
                      });
                }),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UIHelper.verticalSpaceMedium,
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      color: Theme.of(context).canvasColor,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      FlutterI18n.translate(context, "important"),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    FlutterI18n.translate(context, "warningBackupMnemonic"),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )),
                ],
              ),
              UIHelper.verticalSpaceSmall,
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: _buttonGrid(),
              ),
              // UIHelper.verticalSpaceSmall,
              Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: MaterialButton(
                    color: primaryColor,
                    child: Text(
                      FlutterI18n.translate(context, "confirm"),
                      // style: Theme.of(context).textTheme.headline4,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/confirmMnemonic',
                          arguments: BackupMnemonicView.randomMnemonicList);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonGrid() => GridView.extent(
      physics: const NeverScrollableScrollPhysics(),
      maxCrossAxisExtent: 125,
      padding: const EdgeInsets.all(2),
      mainAxisSpacing: 20,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      childAspectRatio: 2.2,
      children: _buildButtonGrid(12));

  List<Widget> _buildButtonGrid(int count) => List.generate(count, (i) {
        var singleWord = BackupMnemonicView.randomMnemonicList[i];
        return TextField(
          textAlign: TextAlign.center,
          // textAlignVertical: const TextAlignVertical(y: 0.5),
          enableInteractiveSelection: false, // readonly
          // enabled: false, // if false use cant see the selection border around
          readOnly: true,
          autocorrect: false,
          decoration: InputDecoration(
            // alignLabelWithHint: true,
            fillColor: primaryColor,
            filled: true,
            hintText: singleWord,
            hintMaxLines: 1,
            hintStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: getTextColor(primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: globals.white, width: 2),
                borderRadius: BorderRadius.circular(30.0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        );
      });
}
