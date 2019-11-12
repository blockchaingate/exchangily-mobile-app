import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../shared/globals.dart' as globals;

class ReceiveWalletScreen extends StatefulWidget {
  final String address;
  final String filePath;
  const ReceiveWalletScreen({Key key, this.address, this.filePath})
      : super(key: key);

  @override
  _ReceiveWalletScreenState createState() => _ReceiveWalletScreenState();
}

class _ReceiveWalletScreenState extends State<ReceiveWalletScreen> {
  final key = new GlobalKey<ScaffoldState>();

  String _filePath;
  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
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
                Text(widget.address,
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
                      copyAddress(widget.address);
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
                    child: SizedBox(
                      height: 500.0,
                      child: Center(
                          child: Container(
                              child: QrImage(
                                  data: widget.address,
                                  version: QrVersions.auto,
                                  size: 300,
                                  errorStateBuilder: (context, err) {
                                    return Container(
                                      child: Center(
                                        child: Text(
                                            'Uh oh! Something went wrong...',
                                            textAlign: TextAlign.center),
                                      ),
                                    );
                                  }))),
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
    print(walletAddress);
    _captureAndSharePng();
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

  /*--------------------------------------------------------------------------------------------------------------------------------------------------------------

                                                        Capture and Share PNG

  --------------------------------------------------------------------------------------------------------------------------------------------------------------*/

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: prefix0.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel(('channel:me.alfian.share/share'));
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
