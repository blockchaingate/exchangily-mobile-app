import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/enums/dialog_type.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_services/stacked_services.dart';

void setupDialogUi() {
  var dialogService = locator<DialogService>();
  final log = getLogger('setupDialogUi');
  dialogService.registerCustomDialogBuilder(
      variant: DialogType.base,
      builder: (BuildContext context, DialogRequest dialogRequest) => Dialog(
          child: _customDialogUi(
              dialogRequest,
              (dialogResponse) =>
                  dialogService.completeDialog(dialogResponse))));
}

Widget _customDialogUi(
    DialogRequest dialogRequest, Function(DialogResponse) onDialogTap) {
  var dialogType = dialogRequest.customData as DialogType;

  print('dialogType $dialogType');
  switch (dialogType) {
    case DialogType.form:
      return _PasswordInputDialog(
          dialogRequest: dialogRequest, onDialogTap: onDialogTap);
    case DialogType.base:
    default:
      return _BasicCustomDialog(
          dialogRequest: dialogRequest, onDialogTap: onDialogTap);
  }
}

class _BasicCustomDialog extends StatelessWidget {
  final DialogRequest dialogRequest;
  final Function(DialogResponse) onDialogTap;
  const _BasicCustomDialog({
    Key key,
    this.dialogRequest,
    this.onDialogTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            dialogRequest.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            dialogRequest.description,
            style: TextStyle(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            // Complete the dialog when you're done with it to return some data
            onTap: () => onDialogTap(DialogResponse(confirmed: true)),
            child: Container(
              child: dialogRequest.showIconInMainButton
                  ? Icon(Icons.check_circle)
                  : Text(dialogRequest.mainButtonTitle),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PasswordInputDialog extends HookWidget {
  final DialogRequest dialogRequest;
  final Function(DialogResponse) onDialogTap;

  const _PasswordInputDialog({Key key, this.dialogRequest, this.onDialogTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _dialogService = locator<DialogService>();
    WalletService _walletService = locator<WalletService>();
    var controller = useTextEditingController();
    return Container(
      child: Column(
        children: [
          TextField(
            style: TextStyle(color: white),
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              labelStyle:
                  Theme.of(context).textTheme.bodyText1.copyWith(color: white),
              icon: Icon(
                Icons.security,
                color: primaryColor,
              ),
              labelText: AppLocalizations.of(context).typeYourWalletPassword,
            ),
          ),
          GestureDetector(

              // Complete the dialog when you're done with it to return some data
              onTap: () => _walletService
                      .readEncryptedData(controller.text)
                      .then((data) {
                    if (data != '' && data != null) {
                      _dialogService.completeDialog(
                          DialogResponse(responseData: data, confirmed: true));
                      controller.text = '';
                      Navigator.of(context).pop();
                    } else {
                      _dialogService
                          .completeDialog(DialogResponse(confirmed: false));
                      controller.text = '';
                      Navigator.of(context).pop();
                    }
                  })

              //  _dialogService
              //     .completeDialog(DialogResponse(confirmed: true)),
              // child: Container(
              //   child: dialogRequest.showIconInMainButton
              //       ? Icon(Icons.check_circle)
              //       : Text(dialogRequest.mainButtonTitle),
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   width: double.infinity,
              //   decoration: BoxDecoration(
              //     color: Colors.redAccent,
              //     borderRadius: BorderRadius.circular(5),
              //   ),
              // ),
              )
        ],
      ),
    );
  }
}
