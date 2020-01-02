import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/confirm_mnemonic_screen_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/verify_mnemonic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/globals.dart' as globals;
import '../base_screen.dart';

class ConfirmMnemonictWalletScreen extends StatefulWidget {
  final List<String> mnemonic;
  const ConfirmMnemonictWalletScreen({Key key, this.mnemonic})
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
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Confirm Mnemonic'),
            backgroundColor: globals.secondaryColor),
        body: Container(
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
                    'Finish Wallet Backup',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    model.verifyMnemonic(controller, context, count, 'create');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

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
  //       Navigator.of(context).pushNamed('/createPassword');
  //     } else {
  //       // Navigator.of(context).pushNamed('/createPassword', arguments: '');
  //       // May be in future we should display where user made a mistake in typing
  //       // For example text field index 5 should turn red if user made a mistake there
  //       _walletService.showInfoFlushbar(
  //           'Seed Empty',
  //           'Please fill all the fields correctly',
  //           Icons.cancel,
  //           Colors.red,
  //           context);
  //     }
  //   });
  // }
}
