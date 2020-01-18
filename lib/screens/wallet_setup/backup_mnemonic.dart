import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/globals.dart' as globals;
import 'package:bip39/bip39.dart' as bip39;

class BackupMnemonicWalletScreen extends StatelessWidget {
  const BackupMnemonicWalletScreen({Key key}) : super(key: key);
  static List<String> mnemonic = [];

  @override
  Widget build(BuildContext context) {
    WalletService walletService = locator<WalletService>();
    final log = getLogger('Backup Mnemonic');
    final randomMnemonic = walletService.getRandomMnemonic();
    log.w(randomMnemonic);
    mnemonic = randomMnemonic
        .split(" ")
        .toList(); // convert string to list to iterate and display single word as a textbox

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).backupMnemonic),
          backgroundColor: globals.secondaryColor),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            UIHelper.verticalSpaceMedium,
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.note_add,
                      color: globals.primaryColor,
                      size: 30,
                    )),
                Expanded(
                    child: Text(
                  AppLocalizations.of(context).warningBackupMnemonic,
                  style: Theme.of(context).textTheme.headline,
                )),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: _buttonGrid(),
            ),
            UIHelper.verticalSpaceSmall,
            Container(
              padding: EdgeInsets.all(15),
              child: RaisedButton(
                child: Text(
                  AppLocalizations.of(context).confirm,
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/confirmMnemonic', arguments: mnemonic);
                },
              ),
            )
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
      children: _buildButtonGrid(12));

  List<Container> _buildButtonGrid(int count) => List.generate(count, (i) {
        var singleWord = mnemonic[i];
        return Container(
            child: TextField(
          textAlign: TextAlign.left,
          //controller: myController,
          enableInteractiveSelection: false, // readonly
          // enabled: false, // if false use cant see the selection border around
          readOnly: true,
          autocorrect: false,
          decoration: InputDecoration(
            fillColor: globals.primaryColor,
            filled: true,
            hintText: '$singleWord',
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
