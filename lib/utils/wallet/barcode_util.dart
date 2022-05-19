import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

class BarcodeUtilWidget extends StatelessWidget {
  final Function(bool) onClose;
  final Function(String) afterCapture;
  const BarcodeUtilWidget(
      {@required this.afterCapture, @required this.onClose});

  @override
  Widget build(BuildContext context) {
    ScanController scanController = ScanController();

    return Container(
      color: grey.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height / 2,
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () => onClose(false),
                padding: const EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: sellPrice,
                  size: 26,
                )),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          height: MediaQuery.of(context).size.height / 2.5,
          child: ScanView(
              controller: scanController,
              scanAreaScale: 1,
              scanLineColor: green,
              onCapture: (v) => afterCapture(v)),
        ),
      ]),
    );
  }
}
