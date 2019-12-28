import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/globals.dart' as globals;
import 'package:bip39/bip39.dart' as bip39;

class BackupMnemonicWalletScreen extends StatelessWidget {
  const BackupMnemonicWalletScreen({Key key}) : super(key: key);
  static List<String> mnemonic = [];

  @override
  Widget build(BuildContext context) {
    final log = getLogger('Backup Seed');
    final randomMnemonic = Provider.of<String>(context);
    log.w(randomMnemonic);
    mnemonic = randomMnemonic
        .split(" ")
        .toList(); // convert string to list to iterate and display single word as a textbox

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(AppLocalizations.of(context).backupSeedPhrase),
          backgroundColor: globals.secondaryColor),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
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
                  'Below are the 12 mnemonics to help you recover your wallet. Please make sure that your password is safely stored and write down this mnemonics on the paper, as this is the only way to recover your phone wallet',
                  style: Theme.of(context).textTheme.headline,
                )),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 40,
              ),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              child: _buttonGrid(),
            ),
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
        var index = i + 1;
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
