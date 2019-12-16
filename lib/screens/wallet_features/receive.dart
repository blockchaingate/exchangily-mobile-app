import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import '../../models/wallet.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../shared/globals.dart' as globals;
import 'package:share/share.dart';

class ReceiveWalletScreen extends StatefulWidget {
  final WalletInfo walletInfo;
  ReceiveWalletScreen({Key key, this.walletInfo}) : super(key: key);

  @override
  _ReceiveWalletScreenState createState() => _ReceiveWalletScreenState();
}

class _ReceiveWalletScreenState extends State<ReceiveWalletScreen> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _globalKey = new GlobalKey();

  Widget build(BuildContext context) {
    print('Wallet info in receive ${widget.walletInfo.address}');
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Receive'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildCopyAddressContainer(context),
          buildQrImageContainer(),
        ],
      ),
    );
  }
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                    QR Code Image and Share Button Container

--------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Container buildQrImageContainer() {
    return Container(
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
                  border: Border.all(width: 1.0, color: globals.primaryColor)),
              child: SizedBox(
                height: 500.0,
                child: Center(
                  child: Container(
                    child: RepaintBoundary(
                      key: _globalKey,
                      child: QrImage(
                          data: widget.walletInfo.address,
                          version: QrVersions.auto,
                          size: 300,
                          gapless: true,
                          errorStateBuilder: (context, err) {
                            return Container(
                              child: Center(
                                child: Text('Uh oh! Something went wrong...',
                                    textAlign: TextAlign.center),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              )),
          RaisedButton(
              child: Text('Save and Share QR code'),
              onPressed: () {
                String receiveFileName = 'share.png';
                getApplicationDocumentsDirectory().then((dir) {
                  String filePath = "${dir.path}/$receiveFileName";
                  File file = File(filePath);

                  Future.delayed(new Duration(milliseconds: 30), () {
                    _capturePng().then((byteData) {
                      file.writeAsBytes(byteData).then((onFile) {
                        Share.shareFile(onFile,
                            text: widget.walletInfo.address);
                      });
                    });
                  });
                });
              })
        ],
      ),
    );
  }

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                        Copy Address Build Container

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Container buildCopyAddressContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: globals.walletCardColor,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Address', style: Theme.of(context).textTheme.display1),
          Text(widget.walletInfo.address,
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
                copyAddress(widget.walletInfo.address);
              },
              textColor: globals.white,
            ),
          )
        ],
      ),
    );
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                        Copy Address Function

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  copyAddress(String walletAddress) {
    Clipboard.setData(new ClipboardData(text: walletAddress));
    Flushbar(
      backgroundColor: globals.secondaryColor.withOpacity(0.75),
      title: 'Copied Successfully',
      message: 'Address copied to the Clipboard',
      icon: Icon(
        Icons.done,
        size: 24,
        color: globals.primaryColor,
      ),
      leftBarIndicatorColor: globals.green,
      duration: Duration(seconds: 2),
    ).show(context);
  }

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                        Save and Share PNG

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
