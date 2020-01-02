import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/screen_state/confirm_mnemonic_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/widgets/verify_mnemonic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
}
