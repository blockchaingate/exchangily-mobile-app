import 'package:exchangilymobileapp/screen_state/confirm_mnemonic_screen_state.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/widgets/verify_mnemonic.dart';
import 'package:flutter/material.dart';
import '../../logger.dart';
import '../../shared/globals.dart' as globals;

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({Key key}) : super(key: key);

  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  final log = getLogger('Import Wallet');
  final count = 12;
  String route = '';
  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> controller = new List();
    return BaseScreen<ConfirmMnemonicScreenState>(
      onModelReady: (model) {
        route = 'import';
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text('Import Wallet'),
            backgroundColor: globals.secondaryColor),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              VerifyMnemonicWalletScreen(
                mnemonicTextController: controller,
                count: count,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text(
                    'Confirm',
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    model.verifyMnemonic(controller, context, count, route);
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
