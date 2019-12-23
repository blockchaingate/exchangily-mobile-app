import 'package:exchangilymobileapp/models/alert/alert_request.dart';
import 'package:exchangilymobileapp/models/alert/alert_response.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();
  WalletService _walletService = locator<WalletService>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showdDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showdDialog(AlertRequest request) {
    Alert(
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () =>
            _dialogService.dialogComplete(AlertResponse(confirmed: false)),
        content: Column(
          children: <Widget>[
            TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              _walletService.readEncryptedData(controller.text).then((data) => {
                    if (data != '' && data != null)
                      {
// _walletService.generateSeedFromUser(mnemonic)
                      }
                    //_dialogService.dialogComplete(AlertResponse(confirmed: true));
                  });

              // Navigator.of(context).pop();
            },
            child: Text(
              request.buttonTitle,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
