import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../shared/globals.dart' as globals;

class ConfirmSeedtWalletScreen extends StatefulWidget {
  final List<String> mnemonic;
  const ConfirmSeedtWalletScreen({Key key, this.mnemonic}) : super(key: key);

  @override
  _ConfirmSeedtWalletScreenState createState() =>
      _ConfirmSeedtWalletScreenState();
}

class _ConfirmSeedtWalletScreenState extends State<ConfirmSeedtWalletScreen> {
  List<TextEditingController> _mnemonicTextController = new List();
  List<String> userTypedMnemonic = [];
  FocusNode _focusNode;
  final int _count = 12;

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
    // Top Text Row Widget
    Widget topTextRow = Row(
      children: <Widget>[
        Expanded(
            child: Text(
          'Please type in your 12 word seed phrase in the correct sequence to confirm',
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
          checkMnemonic();
        },
      ),
    );

// Scaffold

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Confirm Seed Phrase'),
          backgroundColor: globals.secondaryColor),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
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

  // Button Grid

  Widget _buttonGrid() => GridView.extent(
      maxCrossAxisExtent: 125,
      padding: const EdgeInsets.all(2),
      mainAxisSpacing: 15,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      childAspectRatio: 2,
      children: _buildButtonGrid(_count));

  // Test Build Button Grid

  List<Container> _buildButtonGri(int count) => List.generate(count, (i) {
        _mnemonicTextController.add(TextEditingController());
        return Container(
          child: TextField(
            focusNode: _focusNode,
            controller: _mnemonicTextController[i],
            style: TextStyle(color: globals.white),
            decoration: InputDecoration(
                hintText: '$i', hintStyle: TextStyle(color: globals.white)),
          ),
        );
      });

  // Check Mnemonic Values

  checkMnemonic() {
    setState(() {
      userTypedMnemonic.clear();
      for (var i = 0; i < _count; i++) {
        userTypedMnemonic.add(_mnemonicTextController[i].text);
      }
      // Collections in Dart have no inherent equality.
      // Two sets are not equal, even if they contain exactly the same objects as elements.
      // So we use listEqual for deep checking which is one many methods
      if (listEquals(widget.mnemonic, userTypedMnemonic)) {
        Navigator.of(context).pushNamed('/createWallet');
        print('if');
        print(widget.mnemonic);
        print('user typed');
        print(userTypedMnemonic);
        // userTypedMnemonic.clear();
      } else {
        Navigator.of(context).pushNamed(
            '/createWallet'); // Remove this after next screen has finished
        // May be in future we should display where user made a mistake in typing
        // For example text field index 5 should turn red if user made a mistake there
        print('else');
        print(widget.mnemonic);
        print('user typed');
        print(userTypedMnemonic);
      }
    });
  }

  // Build Button Grid

  List<Container> _buildButtonGrid(int count) => List.generate(
        count,
        (i) {
          // to show the number in the text field which should look like that it starts from 1 for user's ease
          var hintMnemonicWordNumber = i + 1;
          _mnemonicTextController.add(TextEditingController());
          return Container(
            child: TextField(
              style: TextStyle(color: globals.white),
              controller: _mnemonicTextController[i],
              maxLines: 2,
              autocorrect: false,
              decoration: InputDecoration(
                fillColor: globals.primaryColor,
                filled: true,
                hintText: '$hintMnemonicWordNumber)',
                hintStyle: TextStyle(color: globals.white),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: globals.white, width: 2),
                    borderRadius: BorderRadius.circular(30.0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          );
        },
      );
}
