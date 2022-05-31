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

import 'package:exchangily_mobile_wallet/src/logger.dart';
import 'package:exchangily_mobile_wallet/src/service_locator.dart';
import 'package:exchangily_mobile_wallet/src/services/dialog_service.dart';
import 'package:flutter/widgets.dart';

class OrderUpdateDialogManager extends StatefulWidget {
  final Widget child;
  const OrderUpdateDialogManager({required this.child});

  @override
  _OrderUpdateDialogManagerState createState() =>
      _OrderUpdateDialogManagerState();
}

class _OrderUpdateDialogManagerState extends State<OrderUpdateDialogManager> {
  final log = getLogger('OrderUpdateDialogManager');
  final DialogService _dialogService = locator<DialogService>();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    log.w(widget.child);
    super.initState();
    _dialogService.registerDialogListener(_showdOrderUpdateDialog);
    controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showdOrderUpdateDialog(DialogRequest request) {
    Alert(
        style: AlertStyle(
            animationType: AnimationType.grow,
            isOverlayTapDismiss: true,
            backgroundColor: globals.priceColor,
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
        },
        content: Column(
          children: <Widget>[
            TextField(
              style: const TextStyle(color: globals.white),
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: globals.white),
                icon: Icon(
                  Icons.event_note,
                  color: globals.primaryColor,
                ),
                labelText: AppLocalizations.of(context).paymentDescription,
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: globals.primaryColor,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              request.buttonTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          DialogButton(
            color: globals.primaryColor,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Text(
              request.cancelButton,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ]).show();
  }
}
