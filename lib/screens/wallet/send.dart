import 'package:exchangilymobileapp/services/db.dart';
import 'package:exchangilymobileapp/services/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/globals.dart' as globals;

class SendWalletScreen extends StatefulWidget {
  final WalletInfo walletInfo;
  const SendWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  _SendWalletScreenState createState() => _SendWalletScreenState();
}

class _SendWalletScreenState extends State<SendWalletScreen> {
  DatabaseService walletService = DatabaseService();
  final _receiverWalletAddressTextController = TextEditingController();
  final _sendAmountTextController = TextEditingController();

  @override
  void dispose() {
    _receiverWalletAddressTextController.dispose();
    _sendAmountTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bal = widget.walletInfo.availableBalance;
    String coinName = widget.walletInfo.tickerName;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.walletCardColor,
        title: Text('Send'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Receiver's Wallet Address Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
          Container(
            margin: EdgeInsets.only(bottom: 10),
            color: globals.walletCardColor,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: TextField(
              controller: _receiverWalletAddressTextController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.add,
                    size: 30,
                    color: globals.primaryColor,
                  ),
                  hintText: 'Wallet Address',
                  hintStyle: Theme.of(context).textTheme.display2),
              style: Theme.of(context).textTheme.display2,
            ),
          ),

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Send Amount And Available Balance Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
          Container(
              color: globals.walletCardColor,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _sendAmountTextController,
                    keyboardType: TextInputType.number, // numnber keyboard
                    inputFormatters: <TextInputFormatter>[
                      BlacklistingTextInputFormatter(new RegExp('[\\-|\\ \\,]'))
                    ],
                    decoration: InputDecoration(
                        hintText: '0.00000',
                        hintStyle: Theme.of(context).textTheme.display2),
                    style: Theme.of(context).textTheme.display2,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Balance: ' + '$bal',
                          style: Theme.of(context).textTheme.headline,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: Text(
                            '$coinName'.toUpperCase(),
                            style: Theme.of(context).textTheme.headline,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Gas fee and Advance Switch Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Gas Fee ',
                        style: Theme.of(context)
                            .textTheme
                            .display3
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left:
                                5), // padding left to keep some space from the text
                        child: Text(
                          '0.000033',
                          style: Theme.of(context)
                              .textTheme
                              .display3
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                // Switch Row
                Row(
                  children: <Widget>[
                    Text(
                      'Advanced',
                      style: Theme.of(context)
                          .textTheme
                          .display3
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: false,
                      inactiveTrackColor: globals.grey,
                      dragStartBehavior: DragStartBehavior.start,
                      activeColor: globals.primaryColor,
                      onChanged: (bool s) {
                        print(s);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Send Button Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
          Container(
            height: 250, // alignment was not working without the height so ;)
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment(0.0, 1.0),
            child: RaisedButton(
              child: Text('Send'),
              onPressed: () {
                var amount = _sendAmountTextController.text;
                walletService.sendTransaction(
                    widget.walletInfo.tickerName.toUpperCase(),
                    [0],
                    _receiverWalletAddressTextController.text,
                    5,
                    'options',
                    false);
              },
            ),
          )
        ],
      ),
    );
  }
}
