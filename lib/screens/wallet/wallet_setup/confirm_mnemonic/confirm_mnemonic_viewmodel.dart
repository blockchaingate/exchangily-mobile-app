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

import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:overlay_support/overlay_support.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/navigation_service.dart';
import 'package:path/path.dart';
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
  final NavigationService navigationService = locator<NavigationService>();
  final sharedService = locator<SharedService>();
  List<int> lastIndexList = [];
  BuildContext? context;
/*----------------------------------------------------------------------
                    init
----------------------------------------------------------------------*/
  init() {
    sharedService.context = context;
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
  resetList() {
    tappedMnemonicList.clear();

    lastIndexList = [];
    for (var single in tapTextControllerList) {
      if (single.text.contains(')')) {
        int s = single.text.indexOf(' ') + 1;
        single.text = single.text.substring(s, single.text.length);
      }
    }

    notifyListeners();
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
        debugPrint('lastIndexList $lastIndexList');
        debugPrint('if : adding element ');
        tappedMnemonicList.add(singleWord);
        tapTextControllerList[i].text =
            '${tappedMnemonicList.length}) $singleWord';
        lastIndexList.add(i);
      }
      // else {
      //   debugPrint('else : remove this element and number bracket');
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

  verifyMnemonic(List controller, context, count, routeName) {
    userTypedMnemonicList.clear();
    if (controller.isEmpty || controller.length != 12) {
      log.e('Didn\'t confirm mnemonic');
      return;
    }
    debugPrint(routeName.toString());
    debugPrint(isTap.toString());
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
          sharedService.sharedSimpleNotification(
              FlutterI18n.translate(context, 'invalidMnemonic'),
              isError: true,
              position: NotificationPosition.bottom,
              subtitle: FlutterI18n.translate(
                  context, 'pleaseFillAllTheTextFieldsCorrectly'));
        }
      } else {
        showSimpleNotification(
            Text(FlutterI18n.translate(context, "invalidMnemonic"),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: red, fontWeight: FontWeight.bold)),
            background: Theme.of(context).canvasColor,
            position: NotificationPosition.bottom,
            subtitle: Text(
              FlutterI18n.translate(
                  context, "pleaseFillAllTheTextFieldsCorrectly"),
            ));
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
            background: Theme.of(context).canvasColor,
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
          background: Theme.of(context).canvasColor,
          position: NotificationPosition.bottom,
          subtitle: Text(
            FlutterI18n.translate(
                context, "pleaseFillAllTheTextFieldsCorrectly"),
          ));
    }
  }
}
