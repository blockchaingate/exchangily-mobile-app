import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../service_locator.dart';

class ConfirmMnemonicScreenState extends BaseState {
  final WalletService _walletService = locator<WalletService>();
  final log = getLogger('ConfirmMnemonicScreenState');
  String errorMessage = '';
  List<String> userTypedMnemonic = [];
  String mnemonic;

  verifyMnemonic(controller, context, count, routeName) {
    mnemonic = Provider.of<String>(context);
    List<String> randomMnemonic = mnemonic.split(" ").toList();

    log.w(randomMnemonic);

    userTypedMnemonic.clear();
    for (var i = 0; i < count; i++) {
      userTypedMnemonic.add(controller[i].text);
    }

    if (routeName == 'import') {
      if (userTypedMnemonic[0] != '' &&
          userTypedMnemonic[1] != '' &&
          userTypedMnemonic[2] != '' &&
          userTypedMnemonic[3] != '' &&
          userTypedMnemonic[4] != '' &&
          userTypedMnemonic[5] != '' &&
          userTypedMnemonic[6] != '' &&
          userTypedMnemonic[7] != '' &&
          userTypedMnemonic[8] != '' &&
          userTypedMnemonic[9] != '' &&
          userTypedMnemonic[10] != '' &&
          userTypedMnemonic[11] != '') {
        log.e(userTypedMnemonic.length);
        String toStringMnemonic = userTypedMnemonic.join(' ');
        importWallet(toStringMnemonic, context);
      } else {
        importWallet(mnemonic, context);
        _walletService.showInfoFlushbar(
            'Mnemonic Empty',
            'Please fill all the text fields',
            Icons.cancel,
            Colors.red,
            context);
      }
    } else {
      createWallet(randomMnemonic, context);
    }
  }

  importWallet(String toStringMnemonic, context) {
    _walletService.generateSeed(toStringMnemonic);
    Navigator.of(context)
        .pushNamed('/createPassword', arguments: toStringMnemonic);
  }

  createWallet(mnemonic, context) {
    if (listEquals(mnemonic, userTypedMnemonic)) {
      Navigator.of(context).pushNamed('/createPassword');
    } else {
      // Navigator.of(context).pushNamed('/createPassword');
      _walletService.showInfoFlushbar('Mnemonic incomplete',
          'Please fill all the text fields', Icons.cancel, Colors.red, context);
    }
  }
}
