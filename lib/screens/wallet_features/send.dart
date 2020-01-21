import 'package:barcode_scan/barcode_scan.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/screens/base_screen.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/screen_state/send_screen_state.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
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

    return BaseScreen<SendScreenState>(
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: globals.walletCardColor,
          title: Text(AppLocalizations.of(context).send),
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
                                      _receiverWalletAddressTextController
                                          .text = data.text;
                                    },
                                    iconSize: 25,
                                    color: globals.primaryColor,
                                  ),
                                  labelText: AppLocalizations.of(context)
                                      .receiverWalletAddress,
                                  labelStyle:
                                      Theme.of(context).textTheme.display2),
                              style: Theme.of(context).textTheme.display2,
                            ),
                          )),
                      RaisedButton(
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            scan(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(Icons.camera_enhance)),
                              Text(AppLocalizations.of(context).scanBarCode)
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
                          onChanged: (String amount) {
                            // checkSendAmount does not directly work if you use it in if as condition so setting state here to make it work
                            setState(() {
                              model.checkSendAmount = model.checkAmount(amount);
                            });
                          },
                          keyboardType:
                              TextInputType.number, // numnber keyboard
                          // inputFormatters: <TextInputFormatter>[
                          //   WhitelistingTextInputFormatter(RegExp(
                          //       '^\$|^(0|([1-9][0-9]{0,})|\.)(\\.[0-9]{0,})?\$'
                          //       // r"[\d.]"
                          //       ))
                          // ],
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: globals.primaryColor)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: globals.grey)),
                              hintText: '0.00000',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .display2
                                  .copyWith(fontSize: 20)),
                          style: model.checkSendAmount
                              ? TextStyle(color: globals.grey, fontSize: 24)
                              : TextStyle(color: globals.red, fontSize: 24),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).walletbalance +
                                    ' $bal',
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
                              AppLocalizations.of(context).gasFee,
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
                            AppLocalizations.of(context).advance,
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

                                  TXID Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

                UIHelper.verticalSpaceSmall,
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: model.txHash.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(
                                    text: AppLocalizations.of(context)
                                        .taphereToCopyTxId,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: globals.primaryColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        model.copyAddress(context);
                                      }),
                              ),
                              UIHelper.verticalSpaceSmall,
                              Text(
                                model.txHash,
                                style: Theme.of(context).textTheme.display2,
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                            model.errorMessage,
                            style: TextStyle(color: globals.red),
                          ))),
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                  Send Button Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/
                Container(
                  height:
                      100, // alignment was not working without the height so ;)
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment(0.0, 1.0),
                  child: model.state == ViewState.Busy
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          disabledColor: model.checkSendAmount
                              ? globals.grey
                              : globals.primaryColor,
                          child: Text(AppLocalizations.of(context).send),
                          onPressed: () async {
                            model.txHash = '';
                            model.errorMessage = '';
                            model.walletInfo = widget.walletInfo;
                            model.amount =
                                double.tryParse(_sendAmountTextController.text);
                            model.toAddress =
                                _receiverWalletAddressTextController.text;
                            model.checkFields(context);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    Barcode Scan

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future scan(context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => _receiverWalletAddressTextController.text = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          _receiverWalletAddressTextController.text =
              'User Access Denied'; // add to localization pending
        });
      } else {
        setState(() => _receiverWalletAddressTextController.text =
            'Unknown error: $e'); // add to localization pending
      }
    } on FormatException {
      setState(() {
        walletService.showInfoFlushbar(
            'Scan Cancelled', // add to localization pending
            'User returned by pressing the back button', // add to localization pending
            Icons.cancel,
            globals.red,
            context);
      });
    } catch (e) {
      setState(() {
        _receiverWalletAddressTextController.text =
            'Unknown error: $e'; // add to localization pending
      });
    }
  }
}
