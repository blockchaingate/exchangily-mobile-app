import 'package:flutter/material.dart';
import '../shared/globals.dart' as globals;

class ImportWalletScreen extends StatelessWidget {
  const ImportWalletScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('Import Wallet'),
          backgroundColor: globals.secondary),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(
                  Icons.note,
                  color: globals.white,
                  size: 25,
                ),
                Expanded(
                    child: Text(
                  'Please type in your 12 seed phrase in the, correct sequence to restore and import your wallet',
                  style: Theme.of(context).textTheme.headline,
                ))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                  shape: StadiumBorder(),
                  minWidth: 120,
                  padding: EdgeInsets.all(10),
                  child: MaterialButton(
                    color: globals.primary,
                    textColor: globals.white,
                    child: Text('dfds'),
                    onPressed: () {},
                  ),
                ),
                ButtonTheme(
                  shape: StadiumBorder(),
                  child: MaterialButton(
                    minWidth: 120,
                    padding: EdgeInsets.all(10),
                    color: globals.primary,
                    textColor: globals.white,
                    child: Text('dfds'),
                    onPressed: () {},
                  ),
                ),
                ButtonTheme(
                  shape: StadiumBorder(),
                  minWidth: 120,
                  padding: EdgeInsets.all(10),
                  child: MaterialButton(
                    color: globals.primary,
                    textColor: globals.white,
                    child: Text('dfds'),
                    onPressed: () {},
                  ),
                )
              ],
            ),
            Container(
              child: RaisedButton(
                child: Text(
                  'Confirm',
                  style: Theme.of(context).textTheme.button,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/createWallet');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
