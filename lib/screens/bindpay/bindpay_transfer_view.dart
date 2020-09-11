import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BindpayTransferView extends StatefulWidget {
  @override
  _BindpayTransferViewState createState() => _BindpayTransferViewState();
}

class _BindpayTransferViewState extends State<BindpayTransferView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children:[
          TextField(
                        onChanged: (String amount) {
                          model.updateTransFee();
                        },
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            suffix: Text(
                                AppLocalizations.of(context).minimumAmount +
                                    ': ' +
                                    environment['minimumWithdraw'][coinName]
                                        .toString(),
                                style: Theme.of(context).textTheme.headline6),
                            enabledBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Color(0XFF871fff), width: 1.0)),
                            hintText: AppLocalizations.of(context).enterAmount,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.w300)),
                        controller: model.amountController,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.w300)),
                    UIHelper.verticalSpaceSmall,
        ]
      ),
    );
  }
}