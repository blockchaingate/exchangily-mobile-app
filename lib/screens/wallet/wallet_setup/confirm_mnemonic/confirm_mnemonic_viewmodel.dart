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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:overlay_support/overlay_support.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

import '../../../../logger.dart';

class ConfirmMnemonicViewModel extends BaseViewModel {
  final log = getLogger('ConfirmMnemonicViewModel');

  final count = 12;
  String route = '';
  final List<TextEditingController> importMnemonicController = [];

  List<TextEditingController> tapTextControllerList = [];
  List<TextEditingController> controller = [];

  String errorMessage = '';
  List<String> userTypedMnemonicList = [];
  final List<String> randomMnemonicList = [];
  String listToStringMnemonic = '';
  bool isTap = true;
  List<String> tappedMnemonicList = [];
  List<String> shuffledList = [];
  final navigationService = locator<NavigationService>();
  List<int> lastIndexList = [];
/*----------------------------------------------------------------------
                    init
----------------------------------------------------------------------*/
  init() {
    fillTapControllerList();
  }

/*----------------------------------------------------------------------
                    onBackButtonPressed
----------------------------------------------------------------------*/
  onBackButtonPressed() async {
    await navigationService.navigateTo(BackupMnemonicViewRoute);
  }

/*----------------------------------------------------------------------
                    Clear tapped list
----------------------------------------------------------------------*/
  clearTappedList() {
    setBusy(true);
    tappedMnemonicList.clear();

    lastIndexList = [];
    for (var single in tapTextControllerList) {
      if (single.text.contains(')')) {
        int s = single.text.indexOf(' ') + 1;
        single.text = single.text.substring(s, single.text.length);
      }
    }

    setBusy(false);
  }

  selectWordsInOrder(int i, String singleWord) {
    setBusy(true);
    // if (model.tappedMnemonicList
    //     .contains(singleWord)) {

    //   int duplicateWordIndex = model
    //       .tappedMnemonicList
    //       .indexOf(singleWord);
    //   if (duplicateWordIndex == i) {

    //     return;
    //   }
    // }

    if (tappedMnemonicList.length < count
        // (!tappedMnemonicList.contains(singleWord)) &&
        ) {
      if (!lastIndexList.contains(i)) {
        print('lastIndexList $lastIndexList');
        print('if : adding element ');
        tappedMnemonicList.add(singleWord);
        tapTextControllerList[i].text =
            tappedMnemonicList.length.toString() + ') ' + singleWord;
        lastIndexList.add(i);
      }
      // else {
      //   print('else : remove this element and number bracket');
      //   tappedMnemonicList.removeLast();
      //   tapTextControllerList[i].text = singleWord;
      // }
    }

    setBusy(false);
  }

/*----------------------------------------------------------------------
                    fill tap controller list
----------------------------------------------------------------------*/
  fillTapControllerList() {
    for (var i = 0; i < count; i++) {
      TextEditingController tapTextController = TextEditingController();
      tapTextControllerList.add(tapTextController);
    }
  }

/*----------------------------------------------------------------------
                    Shuffle mnemonic words
----------------------------------------------------------------------*/
  shuffleStringList(List<String> shuffling) {
    // setBusy(true);

    shuffledList = [];
    // var random = new Random();
    // log.i('before shuffled items $shuffling');
    // // Go through all elements.
    // for (var i = shuffling.length - 1; i > 0; i--) {
    //   // Pick a pseudorandom number according to the list length
    //   var n = random.nextInt(i + 1);

    //   var holder = shuffling[i];
    //   shuffling[i] = shuffling[n];
    //   shuffling[n] = holder;
    // }

    shuffling.shuffle();
    shuffledList = shuffling;
    log.w('shuffled items $shuffling');
    log.e(randomMnemonicList);
    // final res = items.map((e) => e).toSet();
    // res.forEach((element) {
    //   shuffledList.add(element);
    // });
    // log.i('shuffled list $shuffledList');
    // setBusy(false);
  }

/*----------------------------------------------------------------------
                    Select mnemonic confirm method
----------------------------------------------------------------------*/
  selectConfirmMethod(String verifyMethod) {
    setBusy(true);

    if (verifyMethod == 'tap') {
      isTap = true;
    } else {
      isTap = false;
    }

    setBusy(false);
  }

/*----------------------------------------------------------------------
                    Verify mnemonic
----------------------------------------------------------------------*/

  verifyMnemonic(controller, context, count, routeName) {
    userTypedMnemonicList.clear();

    print(routeName);
    print(isTap);
    if (routeName == 'import') isTap = false;
    for (var i = 0; i < count; i++) {
      String mnemonicWord = isTap ? controller[i] : controller[i].text;
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
          showSimpleNotification(
              Text(AppLocalizations.of(context).invalidMnemonic,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: red, fontWeight: FontWeight.bold)),
              position: NotificationPosition.bottom,
              subtitle: Text(AppLocalizations.of(context)
                  .pleaseFillAllTheTextFieldsCorrectly));
        }
      } else {
        showSimpleNotification(
            Text(AppLocalizations.of(context).invalidMnemonic,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: red, fontWeight: FontWeight.bold)),
            position: NotificationPosition.bottom,
            subtitle: Text(AppLocalizations.of(context)
                .pleaseFillAllTheTextFieldsCorrectly));
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
            Text(AppLocalizations.of(context).invalidMnemonic,
                style:
                    Theme.of(context).textTheme.headline4.copyWith(color: red)),
            position: NotificationPosition.bottom,
            subtitle: Text(AppLocalizations.of(context)
                .pleaseFillAllTheTextFieldsCorrectly));
      }
    } else {
      showSimpleNotification(
          Text(AppLocalizations.of(context).invalidMnemonic,
              style:
                  Theme.of(context).textTheme.headline4.copyWith(color: red)),
          position: NotificationPosition.bottom,
          subtitle: Text(AppLocalizations.of(context)
              .pleaseFillAllTheTextFieldsCorrectly));
    }
  }
}
