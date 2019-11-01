import 'package:flutter/material.dart';

class CreateOrImportWalletScreen extends StatelessWidget {
  const CreateOrImportWalletScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: RaisedButton(
            child: Text('Create Wallet'),
            onPressed: () {
              Navigator.pushNamed(context, '/createWallet');
            },
          ),
        ),
        Container(
          child: RaisedButton(
            child: Text('Import Wallet'),
            onPressed: () {
              Navigator.pushNamed(context, '/createWallet');
            },
          ),
        )
      ],
    );
  }
}
