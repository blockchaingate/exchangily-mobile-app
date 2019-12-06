import 'package:barcode_scan/barcode_scan.dart';
import 'package:exchangilymobileapp/services/models.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import '../../shared/globals.dart' as globals;

class SendWalletScreen extends StatefulWidget {
  final WalletInfo walletInfo;
  const SendWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  _SendWalletScreenState createState() => _SendWalletScreenState();
}

class _SendWalletScreenState extends State<SendWalletScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  WalletService walletService = WalletService();
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
      body: SingleChildScrollView(
        // to avoid using ListView without having any list childs to iterate and use column as its child now
        child: Container(
          child: Column(
            // I was using ListView here earlier to solve keyboard overflow error
            children: <Widget>[
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Receiver's Wallet Address Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

              Container(
                margin: EdgeInsets.only(bottom: 10),
                color: globals.walletCardColor,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onLongPressUp: () {
                            print('text long press release');
                          },
                          onLongPress: () {
                            print('Text long press');
                          },
                          child: TextField(
                            maxLines: 1,
                            controller: _receiverWalletAddressTextController,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.content_paste),
                                  onPressed: () async {
                                    ClipboardData data =
                                        await Clipboard.getData(
                                            Clipboard.kTextPlain);
                                    _receiverWalletAddressTextController.text =
                                        data.text;
                                  },
                                  iconSize: 25,
                                  color: globals.primaryColor,
                                ),
                                labelText: 'Receiver Wallet Address',
                                labelStyle:
                                    Theme.of(context).textTheme.display2),
                            style: Theme.of(context).textTheme.display2,
                          ),
                        )),
                    RaisedButton(
                        padding: EdgeInsets.all(10),
                        onPressed: scan,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(Icons.camera_enhance)),
                            Text('Scan Barcode')
                          ],
                        ))
                  ],
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
                        onEditingComplete: () {
                          print('complete editring');
                        },
                        keyboardType: TextInputType.number, // numnber keyboard
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter(RegExp(
                              '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$'))
                        ],
                        decoration: InputDecoration(
                            hintText: '0.00000',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .display2
                                .copyWith(fontSize: 20)),
                        style: Theme.of(context)
                            .textTheme
                            .display2
                            .copyWith(fontSize: 24),
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
                height:
                    200, // alignment was not working without the height so ;)
                padding: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment(0.0, 1.0),
                child: RaisedButton(
                  child: Text('Send'),
                  onPressed: () {
                    const options = {};

                    double amount =
                        double.tryParse(_sendAmountTextController.text);
                    var address = _receiverWalletAddressTextController.text;
                    print('amount');
                    print(amount);
                    if (address == '') {
                      print('Address');
                      print(address);
                      showInfoFlushbar('Empty Address',
                          'Please enter an address', Icons.cancel, globals.red);
                    } else if (amount == null ||
                        amount > widget.walletInfo.availableBalance) {
                      showInfoFlushbar(
                          'Invalid Amount',
                          'Please enter a valid amount',
                          Icons.cancel,
                          globals.red);
                    } else {
                      walletService.sendTransaction(
                          widget.walletInfo.tickerName.toUpperCase(),
                          [0],
                          address,
                          amount,
                          options,
                          true);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Barcode Scan

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => _receiverWalletAddressTextController.text = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _receiverWalletAddressTextController.text = 'User Access Denied';
        });
      } else {
        setState(() =>
            _receiverWalletAddressTextController.text = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() {
        showInfoFlushbar(
            'Scan Cancelled',
            'User returned by pressing the back button',
            Icons.cancel,
            globals.red);
      });
    } catch (e) {
      setState(() {
        _receiverWalletAddressTextController.text = 'Unknown error: $e';
      });
    }
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Common Flushbar Notification

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  void showInfoFlushbar(
      String title, String message, IconData iconData, Color leftBarColor) {
    Flushbar(
      backgroundColor: globals.secondaryColor.withOpacity(0.75),
      title: title,
      message: message,
      icon: Icon(
        iconData,
        size: 24,
        color: globals.primaryColor,
      ),
      leftBarIndicatorColor: leftBarColor,
      duration: Duration(seconds: 3),
    ).show(context);
  }
}
