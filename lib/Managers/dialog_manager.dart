import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/alert/alert_request.dart';
import 'package:exchangilymobileapp/models/alert/alert_response.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../shared/globals.dart' as globals;

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final log = getLogger('DialogManager');
  DialogService _dialogService = locator<DialogService>();
  WalletService _walletService = locator<WalletService>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showdDialog);
    controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showdDialog(AlertRequest request) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: true,
            backgroundColor: globals.walletCardColor,
            descStyle: Theme.of(context).textTheme.display2,
            titleStyle: Theme.of(context)
                .textTheme
                .display3
                .copyWith(fontWeight: FontWeight.bold)),
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _dialogService.dialogComplete(
              AlertResponse(fieldOne: 'Closed', confirmed: false));
        },
        content: Column(
          children: <Widget>[
            TextField(
              style: TextStyle(color: globals.white),
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: globals.white),
                icon: Icon(
                  Icons.security,
                  color: globals.primaryColor,
                ),
                labelText: 'Type your wallet password',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: globals.primaryColor,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _walletService.readEncryptedData(controller.text).then((data) {
                if (data != '' && data != null) {
                  log.w('Decrypted mnemonic - $data');
                  _dialogService.dialogComplete(
                      AlertResponse(fieldOne: data, confirmed: true));
                  controller.text = '';
                  Navigator.of(context).pop();
                } else {
                  _dialogService
                      .dialogComplete(AlertResponse(confirmed: false));
                  controller.text = '';
                  Navigator.of(context).pop();
                }
              });
            },
            child: Text(
              request.buttonTitle,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
