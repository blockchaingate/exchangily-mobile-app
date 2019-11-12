import 'package:exchangilymobileapp/services/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/globals.dart' as globals;

class ReceiveWalletScreen extends StatefulWidget {
  const ReceiveWalletScreen({Key key}) : super(key: key);

  @override
  _ReceiveWalletScreenState createState() => _ReceiveWalletScreenState();
}

class _ReceiveWalletScreenState extends State<ReceiveWalletScreen> {
  final key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 150,
            color: globals.walletCardColor,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Address', style: Theme.of(context).textTheme.display1),
                //.copyWith(fontWeight: FontWeight.bold)),
                Text('sdjfhaohdf84392rhfnidsakjfn209834fn',
                    style: Theme.of(context).textTheme.headline),
                Container(
                  width: 200,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.content_copy),
                        Text('copy address'),
                      ],
                    ),
                    onPressed: () {
                      copyAddress("walletAddress");
                    },
                    textColor: globals.white,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 350,
            color: globals.walletCardColor,
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.0, color: globals.primaryColor)),
                    child: Image.asset(
                      'assets/images/wallet-page/barcode.png',
                      // width: 250,
                      // height: 100,
                    )),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Save and Share QR code'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                                                  Copy Address Function

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  copyAddress(String walletAddress) {
    Clipboard.setData(new ClipboardData(text: walletAddress));
    key.currentState.showSnackBar(new SnackBar(
      backgroundColor: globals.white,
      content: new Text(
        'Copied to Clipboard',
        textAlign: TextAlign.center,
        style: TextStyle(color: globals.primaryColor),
      ),
    ));
  }
}
