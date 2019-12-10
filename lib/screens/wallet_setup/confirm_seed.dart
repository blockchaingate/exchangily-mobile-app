import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
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
  final subject = new PublishSubject<String>();

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
          if (widget.mnemonic == userTypedMnemonic) {
            Navigator.of(context).pushNamed('/createWallet');
            print(userTypedMnemonic);
          } else {
            print('else');
            print(userTypedMnemonic);
          }
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
      children: _buildButtonGri(_count));

  List<Container> _buildButtonGri(int count) => List.generate(count, (i) {
        _mnemonicTextController.add(TextEditingController());
        return Container(
          child: TextField(
            focusNode: _focusNode,
            controller: _mnemonicTextController[i],
            decoration: InputDecoration(hintText: '$i'),
            onChanged: (value) {
              if (value != null) {
                final controller = value;
                print(controller);
                userTypedMnemonic.add(controller);
              }
            },
          ),
        );
      });

  // Build Button Grid

  List<Container> _buildButtonGrid(int count) => List.generate(
        count,
        (i) {
          // to show the number in the text field which should look like that it starts from 1 for user's ease
          i = i + 1;
          _mnemonicTextController.add(TextEditingController());
          return Container(
            child: TextField(
              controller: _mnemonicTextController[i],
              onChanged: (value) {
                final controller = _mnemonicTextController[i].text;
                print('Current field index is $i and new value is $value');
                print('Final controller $controller');
                userTypedMnemonic.add(controller);
                print(userTypedMnemonic.length);
              },
              maxLines: 2,
              autocorrect: false,
              decoration: InputDecoration(
                fillColor: globals.primaryColor,
                filled: true,
                hintText: '$i)',
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
