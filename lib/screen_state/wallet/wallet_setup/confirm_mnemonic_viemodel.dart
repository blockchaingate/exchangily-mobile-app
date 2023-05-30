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

// -----------------------------------burayi ac ----------------------------------------
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import '../../../logger.dart';
import '../../../service_locator.dart';

class ConfirmMnemonicViewmodel extends BaseViewModel {
  final SharedService? sharedService = locator<SharedService>();
  final log = getLogger('ConfirmMnemonicScreenState');
  String errorMessage = '';
  List<String> userTypedMnemonicList = [];
  List<String> randomMnemonicList = [];
  String listToStringMnemonic = '';
  final List<TextEditingController> controller = [];
  final count = 12;
  String route = '';

  verifyMnemonic(controller, context, count, routeName) {
    userTypedMnemonicList.clear();
    for (var i = 0; i < count; i++) {
      String mnemonicWord = controller[i].text;
      userTypedMnemonicList.add(mnemonicWord.trim());
    }

    if (routeName == 'import') {
      if (userTypedMnemonicList[0] != '' &&
          userTypedMnemonicList[1] != '' &&
          userTypedMnemonicList[2] != '' &&
          userTypedMnemonicList[3] != '' &&
          userTypedMnemonicList[4] != '' &&
          userTypedMnemonicList[5] != '' &&
          userTypedMnemonicList[6] != '' &&
          userTypedMnemonicList[7] != '' &&
          userTypedMnemonicList[8] != '' &&
          userTypedMnemonicList[9] != '' &&
          userTypedMnemonicList[10] != '' &&
          userTypedMnemonicList[11] != '') {
        listToStringMnemonic = userTypedMnemonicList.join(' ');
        bool isValid = bip39.validateMnemonic(listToStringMnemonic);
        if (isValid) {
          importWallet(listToStringMnemonic, context);
        } else {
          sharedService!.sharedSimpleNotification(
              FlutterI18n.translate(context, "invalidMnemonic"),
              subtitle: FlutterI18n.translate(
                  context, "pleaseFillAllTheTextFieldsCorrectly"));
        }
      } else {
        sharedService!.sharedSimpleNotification(
            FlutterI18n.translate(context, "invalidMnemonic"),
            subtitle: FlutterI18n.translate(
                context, "pleaseFillAllTheTextFieldsCorrectly"));
      }
    } else {
      createWallet(context);
    }
  }

  // Import Wallet

  importWallet(String stringMnemonic, context) async {
    var args = {'mnemonic': stringMnemonic, 'isImport': true};
    Navigator.of(context).pushNamed('/createPassword', arguments: args);
  }

// Create Wallet
  createWallet(context) {
    if (listEquals(randomMnemonicList, userTypedMnemonicList)) {
      listToStringMnemonic = randomMnemonicList.join(' ');
      bool isValid = bip39.validateMnemonic(listToStringMnemonic);
      if (isValid) {
        var args = {'mnemonic': listToStringMnemonic, 'isImport': false};
        Navigator.of(context).pushNamed('/createPassword', arguments: args);
      } else {
        showSimpleNotification(
            Text(FlutterI18n.translate(context, "invalidMnemonic"),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: red)),
            position: NotificationPosition.bottom,
            subtitle: Text(FlutterI18n.translate(
                context, "pleaseFillAllTheTextFieldsCorrectly")));
      }
    } else {
      showSimpleNotification(
          Text(FlutterI18n.translate(context, "invalidMnemonic"),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: red)),
          position: NotificationPosition.bottom,
          subtitle: Text(FlutterI18n.translate(
              context, "pleaseFillAllTheTextFieldsCorrectly")));
    }
  }
}
