import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';

import '../logger.dart';
import '../service_locator.dart';

class ConfirmMnemonicScreenState extends BaseState {
  final WalletService _walletService = locator<WalletService>();
  final log = getLogger('CreatePasswordScreenState');
  String errorMessage = '';

  // checkMnemonic() {
  //   setState(() {
  //     userTypedMnemonic.clear();
  //     for (var i = 0; i < _count; i++) {
  //       userTypedMnemonic.add(_mnemonicTextController[i].text);
  //     }
  //     // Collections in Dart have no inherent equality.
  //     // Two sets are not equal, even if they contain exactly the same objects as elements.
  //     // So we use listEqual for deep checking which is one many methods
  //     if (listEquals(widget.mnemonic, userTypedMnemonic)) {
  //       Navigator.of(context).pushNamed('/createWallet');
  //       log.w('if');
  //       log.w(widget.mnemonic);
  //       log.w('user typed');
  //       log.w(userTypedMnemonic);
  //       // userTypedMnemonic.clear();

  //     } else {
  //       // Remove this after next screen has finished
  //       Navigator.of(context).pushNamed('/createPassword');
  //       // May be in future we should display where user made a mistake in typing
  //       // For example text field index 5 should turn red if user made a mistake there
  //       log.w('else');
  //       log.w(widget.mnemonic);
  //       log.w('user typed');
  //       log.w(userTypedMnemonic);
  //       _walletService.showInfoFlushbar(
  //           'Seed Empty',
  //           'Please fill all the text fields',
  //           Icons.cancel,
  //           Colors.red,
  //           context);
  //     }
  //   });
  // }
}
