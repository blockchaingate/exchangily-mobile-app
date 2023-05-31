import 'package:auto_size_text/auto_size_text.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/route_names.dart';
import 'package:exchangilymobileapp/models/wallet/transaction_history.dart';
import 'package:exchangilymobileapp/screen_state/wallet/wallet_features/transaction_history_viewmodel.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/number_util.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TxHisotryCardWidget extends StatelessWidget {
  final TransactionHistoryViewmodel model;
  const TxHisotryCardWidget({
    required this.model,
    Key? key,
    required this.transaction,
    required this.customFontSize,
  }) : super(key: key);

  final TransactionHistory transaction;
  final double customFontSize;

  @override
  Widget build(BuildContext context) {
    transaction.tickerName = model.updateTickers(transaction.tickerName!);

    return Card(
        elevation: 4,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            color: Theme.of(context).cardColor,
            child: Row(children: <Widget>[
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: Padding(
                          padding: transaction.tickerName!.length > 3
                              ? const EdgeInsets.only(left: 0.0)
                              : const EdgeInsets.only(left: 5.0),
                          child: transaction.tickerName!.contains('(')
                              ? Column(
                                  children: [
                                    Text(transaction.tickerName!.split('(')[0],
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                    Text(
                                        transaction.tickerName!
                                            .split('(')[1]
                                            .substring(
                                                0,
                                                transaction.tickerName!
                                                        .split('(')[1]
                                                        .length -
                                                    1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ],
                                )
                              : Text(transaction.tickerName!.toUpperCase(),
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                        ),
                      ),

                      // icon
                      transaction.tag!.toUpperCase() ==
                              model.deposit.toUpperCase()
                          ? const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.arrow_downward,
                                size: 16,
                                color: buyPrice,
                              ),
                            )
                          : transaction.tag!.toUpperCase() ==
                                  model.send.toUpperCase()
                              ? const Padding(
                                  padding: EdgeInsets.only(left: 13.0),
                                  child: Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 11,
                                    color: sellPrice,
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    Icons.arrow_upward,
                                    size: 16,
                                    color: sellPrice,
                                  ),
                                ),

                      if (transaction.tag!.toUpperCase() ==
                          model.withdraw.toUpperCase())
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            FlutterI18n.translate(context, "withdraw"),
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        )
                      else if (transaction.tag!.toUpperCase() ==
                          model.send.toUpperCase())
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            FlutterI18n.translate(context, "send"),
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        )
                      else if (transaction.tag!.toUpperCase() ==
                          model.deposit.toUpperCase())
                        Padding(
                          padding: model.isChinese
                              ? const EdgeInsets.only(left: 7.0)
                              : const EdgeInsets.only(left: 3.0),
                          child: Text(
                            FlutterI18n.translate(context, "deposit"),
                            style: Theme.of(context).textTheme.titleSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ]),
              ),
              UIHelper.horizontalSpaceSmall,
              // DATE
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      '${transaction.date!.split(" ")[0].split("-")[1]}-${transaction.date!.split(" ")[0].split("-")[2]}-${transaction.date!.split(" ")[0].split("-")[0]}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w400),
                      minFontSize: 8,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Time
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        transaction.tag == model.send
                            ? transaction.date!.split(" ")[1].split(".")[0]
                            : transaction.date!.split(" ")[1],
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // Quantity
              Expanded(
                flex: 2,
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    alignment: Alignment.centerRight,
                    child: AutoSizeText(
                      NumberUtil()
                          .truncateDoubleWithoutRouding(transaction.quantity!,
                              precision: model.decimalLimit!)
                          .toString(),
                      textAlign: TextAlign.right,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.w400),
                      minFontSize: 8,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    )),
              ),
              UIHelper.horizontalSpaceSmall,
              // Status
              transaction.tag != model.send
                  ? Expanded(
                      flex: 1,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // If deposit is success in both Ticker chain and kanabn chain then show completed
                            if (transaction.tag!.toUpperCase() ==
                                    model.deposit.toUpperCase() &&
                                transaction.tickerChainTxStatus ==
                                    model.success &&
                                transaction.kanbanTxStatus == model.success)
                              Expanded(
                                child: AutoSizeText(
                                  firstCharToUppercase(
                                    FlutterI18n.translate(context, "completed"),
                                  ),
                                  style: TextStyle(
                                      fontSize: customFontSize,
                                      color: buyPrice),
                                  minFontSize: 8,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )

                            // If deposit is success in only Ticker chain and not in kanban chain then show sent
                            else if (transaction.tag!.toUpperCase() ==
                                    model.deposit.toUpperCase() &&
                                transaction.tickerChainTxStatus ==
                                    model.success &&
                                transaction.kanbanTxStatus == model.success)
                              Text(
                                  firstCharToUppercase(
                                    FlutterI18n.translate(context, "sent"),
                                  ),
                                  style: TextStyle(
                                      fontSize: customFontSize,
                                      color: buyPrice))
                            // depsoit pending if ticker chain staus is pending
                            else if (transaction.tag!.toUpperCase() ==
                                    model.deposit.toUpperCase() &&
                                transaction.tickerChainTxStatus ==
                                    model.pending)
                              Text(
                                  firstCharToUppercase(
                                    FlutterI18n.translate(context, "pending"),
                                  ),
                                  style: TextStyle(
                                      fontSize: customFontSize, color: yellow))
                            // depsoit pending if ticker chain staus is pending
                            else if (transaction.tag!.toUpperCase() ==
                                    model.deposit.toUpperCase() &&
                                transaction.kanbanTxStatus == model.pending)
                              Text(
                                  firstCharToUppercase(
                                    FlutterI18n.translate(context, "pending"),
                                  ),
                                  style: TextStyle(
                                      fontSize: customFontSize, color: yellow))
                            else if (transaction.tag!.toUpperCase() ==
                                    model.deposit.toUpperCase() &&
                                transaction.tickerChainTxStatus == model.failed)
                              Text(
                                FlutterI18n.translate(context, "failed"),
                                style:
                                    const TextStyle(fontSize: 12, color: red),
                              )
                            else if (transaction.tag!.toUpperCase() ==
                                        model.deposit.toUpperCase() &&
                                    transaction.kanbanTxStatus ==
                                        model.rejected ||
                                transaction.kanbanTxStatus == model.rejected)
                              RichText(
                                text: TextSpan(
                                    text: FlutterI18n.translate(
                                        context, "redeposit"),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                        color: red),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        model.navigationService!.navigateTo(
                                            RedepositViewRoute,
                                            arguments: model.walletInfo);
                                      }),
                              ) // if withdraw status is success on kanban but null on ticker chain then display sent
                            else if (transaction.tag!.toUpperCase() ==
                                    model.withdraw.toUpperCase() &&
                                transaction.kanbanTxStatus == model.success &&
                                transaction.tickerChainTxId == '')
                              Text(
                                  firstCharToUppercase(
                                    FlutterI18n.translate(context, "sent"),
                                  ),
                                  style: TextStyle(
                                      fontSize: customFontSize,
                                      color:
                                          buyPrice)) // if withdraw status is success on kanban but null on ticker chain then display sent
                            else if (transaction.tag!.toUpperCase() ==
                                    model.withdraw.toUpperCase() &&
                                transaction.kanbanTxStatus == model.success &&
                                transaction.tickerChainTxStatus!
                                    .startsWith('sent'))
                              Expanded(
                                child: AutoSizeText(
                                  firstCharToUppercase(
                                    FlutterI18n.translate(context, "completed"),
                                  ),
                                  style: TextStyle(
                                      fontSize: customFontSize,
                                      color: buyPrice),
                                  minFontSize: 8,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                          ]))
                  : Expanded(
                      flex: 1,
                      child: Text(
                          firstCharToUppercase(
                            FlutterI18n.translate(context, "sent"),
                          ),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: customFontSize, color: buyPrice)),
                    ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.more,
                          color: Theme.of(context).hintColor, size: 14),
                      onPressed: () {
                        debugPrint('tx histoy ${transaction.toJson()}');
                        model.showTxDetailDialog(transaction);
                      }),
                ),
              )
            ])));
  }
}
