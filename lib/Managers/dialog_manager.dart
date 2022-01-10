/*
* Copyright (c) 2020 Exchangily LLC
*
* Licensed under Apache License v2.0
* You may obtain a copy of the License at
*
*      https://www.apache.org/licenses/LICENSE-2.0
*
*----------------------------------------------------------------------
* Author: barry-ruprai@exchangily.com
*----------------------------------------------------------------------
*/

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/dialog/dialog_request.dart';
import 'package:exchangilymobileapp/models/dialog/dialog_response.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/core_wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/vault_service.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:exchangilymobileapp/localizations.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final log = getLogger('DialogManager');
  DialogService _dialogService = locator<DialogService>();
  final _vaultService = locator<VaultService>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
    _dialogService.registerBasicDialogListener(_showBasicDialog);
    _dialogService.registerVerifyDialogListener(_showVerifyDialog);
    controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void showBasicSnackbar(DialogRequest request) {
    showSimpleNotification(
      Center(
          child: Text(request.title,
              style: Theme.of(context).textTheme.headline6)),
    );
  }

  void _showVerifyDialog(
    DialogRequest request,
    // {bool isSecondaryChoice = false}
  ) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: false,
            backgroundColor: walletCardColor,
            descStyle: Theme.of(context).textTheme.bodyText1,
            titleStyle: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontWeight: FontWeight.bold)),
        context: context,
        title: request.title,
        desc: request.description ?? '',
        closeFunction: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _dialogService.dialogComplete(
              DialogResponse(returnedText: 'Closed', confirmed: false));
          controller.text = '';

          Navigator.of(context).pop();
        },
        // content: Column(
        //   children: <Widget>[
        //     Text(request.description)

        //   ],
        // ),
        buttons: [
          if (request.secondaryButton.isNotEmpty)
            DialogButton(
              color: red,
              onPressed: () {
                _dialogService.dialogComplete(DialogResponse(confirmed: false));

                Navigator.of(context).pop();
              },
              child: Text(
                request.secondaryButton,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          DialogButton(
            color: primaryColor,
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: true));

              Navigator.of(context).pop();
            },
            child: Text(
              request.buttonTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ]).show();
  }

  void _showBasicDialog(DialogRequest request) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: false,
            backgroundColor: walletCardColor,
            descStyle: Theme.of(context).textTheme.bodyText1,
            titleStyle: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontWeight: FontWeight.bold)),
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _dialogService.dialogComplete(
              DialogResponse(returnedText: 'Closed', confirmed: false));
          controller.text = '';
          print('popping');
          //if (!Platform.isIOS)
          Navigator.of(context).pop();
          print('popped');
        },
        // content: Column(
        //   children: <Widget>[
        //     Text(request.description)

        //   ],
        // ),
        buttons: [
          DialogButton(
            color: primaryColor,
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: false));

              Navigator.of(context).pop();
            },
            child: Text(
              request.buttonTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ]).show();
  }

  void _showDialog(DialogRequest request) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: false,
            backgroundColor: walletCardColor,
            descStyle: Theme.of(context).textTheme.bodyText1,
            titleStyle: Theme.of(context)
                .textTheme
                .headline3
                .copyWith(fontWeight: FontWeight.bold)),
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _dialogService.dialogComplete(
              DialogResponse(returnedText: 'Closed', confirmed: false));
          controller.text = '';
          print('popping');
          //if (!Platform.isIOS)
          Navigator.of(context).pop();
          print('popped');
        },
        content: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              style: TextStyle(color: white),
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: white),
                icon: Icon(
                  Icons.security,
                  color: primaryColor,
                ),
                labelText: AppLocalizations.of(context).typeYourWalletPassword,
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: grey,
            onPressed: () {
              controller.text = '';
              _dialogService.dialogComplete(
                  DialogResponse(returnedText: 'Closed', confirmed: false));
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context).cancel,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.black),
            ),
          ),
          DialogButton(
            color: primaryColor,
            onPressed: () async {
              if (controller.text != '') {
                FocusScope.of(context).requestFocus(FocusNode());
                var coreWalletDatabaseService =
                    locator<CoreWalletDatabaseService>();

                String encryptedMnemonic = '';
                var finalRes = '';
                try {
                  // todo just check using new format first
                  // todo:  then check with old format if new format
                  /// todo: decryption is not available
                  /// todo: finally pass the password in the function args
                  /// todo: and after verification success, encrypt the mnemonic with
                  ///  todo: the password and store it using new format
                  // encryptedMnemonic =
                  //     await coreWalletDatabaseService.getEncryptedMnemonic();
                  //  if (encryptedMnemonic.isEmpty) {
                  // if there is no encrypted mnemonic saved in the new core wallet db
                  // then get the unencrypted mnemonic from the file

                  //finalRes = await _vaultService.decryptData(controller.text);
                  //   } else if (encryptedMnemonic.isNotEmpty) {
                  await _vaultService
                      .decryptMnemonic(controller.text, encryptedMnemonic)
                      .then((data) {
                    finalRes = data;
                  });
                  // }
                  if (finalRes == Constants.ImportantWalletUpdateText) {
                    _dialogService.dialogComplete(DialogResponse(
                        confirmed: false,
                        returnedText: '',
                        isRequiredUpdate: true));
                    controller.text = '';
                    Navigator.of(context).pop();
                  } else if (finalRes != '' && finalRes != null) {
                    _dialogService.dialogComplete(DialogResponse(
                        returnedText: finalRes,
                        confirmed: true,
                        isRequiredUpdate: false));
                    controller.text = '';
                    Navigator.of(context).pop();
                  } else {
                    _dialogService.dialogComplete(DialogResponse(
                        confirmed: false,
                        returnedText: 'wrong password',
                        isRequiredUpdate: false));
                    controller.text = '';
                    Navigator.of(context).pop();
                  }
                } catch (err) {
                  log.e('Getting mnemonic failed -- $err');
                }
              }
            },
            child: Text(
              request.buttonTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ]).show();
  }
}
