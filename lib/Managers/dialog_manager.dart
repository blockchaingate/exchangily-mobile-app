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
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DialogManager extends StatefulWidget {
  final Widget? child;
  const DialogManager({Key? key, this.child}) : super(key: key);

  @override
  DialogManagerState createState() => DialogManagerState();
}

class DialogManagerState extends State<DialogManager> {
  final log = getLogger('DialogManager');
  final DialogService _dialogService = locator<DialogService>();
  final VaultService _vaultService = locator<VaultService>();
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
    return widget.child!;
  }

  void showBasicSnackbar(DialogRequest request) {
    showSimpleNotification(
      Center(
          child: Text(request.title!,
              style: Theme.of(context).textTheme.titleLarge)),
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
            backgroundColor: Theme.of(context).cardColor,
            alertAlignment: Alignment.center,
            descStyle: Theme.of(context).textTheme.bodyLarge!,
            titleStyle: Theme.of(context)
                .textTheme
                .displaySmall!
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
          if (request.secondaryButton!.isNotEmpty)
            DialogButton(
              color: red,
              onPressed: () {
                _dialogService.dialogComplete(DialogResponse(confirmed: false));

                Navigator.of(context).pop();
              },
              child: Text(
                request.secondaryButton!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          DialogButton(
            color: primaryColor,
            onPressed: () {
              _dialogService.dialogComplete(DialogResponse(confirmed: true));

              Navigator.of(context).pop();
            },
            child: Text(
              request.buttonTitle!,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ]).show();
  }

  void _showBasicDialog(DialogRequest request) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: false,
            alertAlignment: Alignment.center,
            backgroundColor: Theme.of(context).cardColor,
            descStyle: Theme.of(context).textTheme.bodyLarge!,
            titleStyle: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.bold)),
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _dialogService.dialogComplete(
              DialogResponse(returnedText: 'Closed', confirmed: false));
          controller.text = '';
          debugPrint('popping');
          //if (!Platform.isIOS)
          Navigator.of(context).pop();
          debugPrint('popped');
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
              request.buttonTitle!,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ]).show();
  }

  void _showDialog(DialogRequest request) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: false,
            alertAlignment: Alignment.center,
            backgroundColor: Theme.of(context).cardColor,
            descStyle: Theme.of(context).textTheme.bodyLarge!,
            titleStyle: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(fontWeight: FontWeight.bold)),
        context: context,
        title: request.title,
        desc: request.description,
        closeFunction: () {
          FocusScope.of(context).requestFocus(FocusNode());
          _dialogService.dialogComplete(
              DialogResponse(returnedText: 'Closed', confirmed: false));
          controller.text = '';
          debugPrint('popping');
          //if (!Platform.isIOS)
          Navigator.of(context).pop();
          debugPrint('popped');
        },
        content: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              style: Theme.of(context).textTheme.bodyLarge,
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.labelMedium,
                icon: const Icon(
                  Icons.security,
                  color: primaryColor,
                ),
                labelText:
                    FlutterI18n.translate(context, "typeYourWalletPassword"),
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
              FlutterI18n.translate(context, "cancel"),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.black),
            ),
          ),
          DialogButton(
            color: primaryColor,
            onPressed: () async {
              if (controller.text != '') {
                FocusScope.of(context).requestFocus(FocusNode());

                String? encryptedMnemonic = '';
                var finalRes = '';
                try {
                  var coreWalletDatabaseService =
                      locator<CoreWalletDatabaseService>();

                  encryptedMnemonic =
                      (await coreWalletDatabaseService.getEncryptedMnemonic())!;
                  try {
                    encryptedMnemonic;
                  } catch (err) {
                    log.e(
                        'failed to assign empty string to null encrypted mnemonic variable');
                  }
                  if (encryptedMnemonic.isEmpty) {
                    // if there is no encrypted mnemonic saved in the new core wallet db
                    // then get the unencrypted mnemonic from the file

                    finalRes = await _vaultService.decryptData(controller.text);
                  } else if (encryptedMnemonic.isNotEmpty) {
                    await _vaultService
                        .decryptMnemonic(controller.text, encryptedMnemonic)
                        .then((data) {
                      finalRes = data;
                    });
                  }
                  if (finalRes == Constants.ImportantWalletUpdateText) {
                    _dialogService.dialogComplete(DialogResponse(
                        confirmed: false,
                        returnedText: '',
                        isRequiredUpdate: true));
                    controller.text = '';
                    Navigator.of(context).pop();
                  } else if (finalRes != '') {
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
              request.buttonTitle!,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          )
        ]).show();
  }
}
