import 'package:flutter/material.dart';
import '../shared/globals.dart' as globals;

class ConfirmSeedtWalletScreen extends StatelessWidget {
  const ConfirmSeedtWalletScreen({Key key}) : super(key: key);
  static final randomMnemonic = [
    'culture',
    'sound',
    'obey',
    'clean',
    'pretty',
    'medal',
    'churn',
    'behind',
    'chief',
    'cactus',
    'alley',
    'ready'
  ];

  @override
  Widget build(BuildContext context) {
    // Top Text Row Widget
    Widget topTextRow = Row(
      children: <Widget>[
        Expanded(
            child: Text(
          'Please type in your 12 seed phrase in the, correct sequence to restore and import your wallet',
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
          'Finish Wallet Backup',
          style: Theme.of(context).textTheme.button,
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/createWallet');
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Confirm Seed Phrase'),
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
      children: _buildButtonGrid(12));

  List<Container> _buildButtonGrid(int count) => List.generate(count, (i) {
        i = i + 1;
        return Container(
            child: TextField(
          maxLines: 2,
          autocorrect: false,
          decoration: InputDecoration(
            fillColor: globals.primaryColor,
            filled: true,
            hintText: '$i',
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
