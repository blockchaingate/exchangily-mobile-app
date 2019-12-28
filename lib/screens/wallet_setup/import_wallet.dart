import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../logger.dart';
import '../../service_locator.dart';
import '../../shared/globals.dart' as globals;

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({Key key}) : super(key: key);

  @override
  _ImportWalletScreenState createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  final log = getLogger('Import Wallet');
  List<TextEditingController> _mnemonicTextController = new List();
  List<String> userTypedMnemonic = [];
  FocusNode _focusNode;
  final int _count = 12;
  WalletService _walletService = locator<WalletService>();

  @override
  void initState() {
    _mnemonicTextController.clear();
    super.initState();
  }

  @override
  void dispose() {
    _mnemonicTextController.map((f) => f.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WalletService _walletService = locator<WalletService>();
    // Top Text Row Widget
    Widget topTextRow = Row(
      children: <Widget>[
        UIHelper.verticalSpaceMedium,
        Expanded(
            child: Text(
          'Please type in your 12 word seed phrase in the correct sequence to import wallet',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline,
        )),
      ],
    );
// Finish Wallet Backup Button Widget
    Widget finishWalletBackupButton = Container(
      padding: EdgeInsets.all(15),
      child: RaisedButton(
        child: Text(
          'Confirm',
          style: Theme.of(context).textTheme.button,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/createPassword');
          _walletService.showInfoFlushbar('Import not working',
              'Please Check back later', Icons.cancel, Colors.red, context);
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Import Wallet'),
          backgroundColor: globals.secondaryColor),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            topTextRow,
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 40,
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: _buttonGrid(),
            ),
            finishWalletBackupButton
          ],
        ),
      ),
    );
  }

  Widget _buttonGrid() => GridView.extent(
      maxCrossAxisExtent: 125,
      padding: const EdgeInsets.all(2),
      mainAxisSpacing: 15,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      childAspectRatio: 2,
      children: _buildButtonGrid(_count));

  List<Container> _buildButtonGrid(int count) => List.generate(count, (i) {
        var hintMnemonicWordNumber = i + 1;
        _mnemonicTextController.add(TextEditingController());
        return Container(
            child: TextField(
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter(RegExp(r'([a-z]{0,})$'))
          ],
          style: TextStyle(color: globals.white),
          controller: _mnemonicTextController[i],
          maxLines: 2,
          autocorrect: false,
          decoration: InputDecoration(
            fillColor: globals.primaryColor,
            filled: true,
            hintText: '$hintMnemonicWordNumber',
            hintStyle: TextStyle(color: globals.white),
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
