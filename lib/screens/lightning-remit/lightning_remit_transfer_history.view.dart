import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pagination_widget/pagination_widget.dart';
import 'package:stacked/stacked.dart';

import 'lightning_remit_viewmodel.dart';

class LightningRemitTransferHistoryView
    extends StackedView<LightningRemitViewmodel> {
  @override
  LightningRemitViewmodel viewModelBuilder(BuildContext context) =>
      LightningRemitViewmodel();

  @override
  void onViewModelReady(LightningRemitViewmodel model) async {
    model.geTransactionstHistory();
  }

  @override
  Widget builder(
      BuildContext context, LightningRemitViewmodel viewModel, Widget? child) {
    return Scaffold(
        appBar: customAppBarWithTitle(
          FlutterI18n.translate(context, "transactionHistory"),
        ),
        body: SingleChildScrollView(
          child: viewModel.isBusy
              ? Center(
                  child: SizedBox(
                      height: 500,
                      child: viewModel.sharedService.loadingIndicator()))
              : Container(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: <Widget>[
                      for (var transaction in viewModel.transferHistory.history)
                        Card(
                          elevation: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            color: secondaryColor,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 45,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: Text(transaction.coin.toString(),
                                            style: subText2),
                                      ),
                                      // icon
                                      transaction.type == 'send'
                                          ? const Icon(
                                              FontAwesomeIcons.arrowRight,
                                              size: 11,
                                              color: sellPrice,
                                            )
                                          : const Icon(
                                              Icons.arrow_downward,
                                              size: 18,
                                              color: buyPrice,
                                            ),
                                    ],
                                  ),
                                ),
                                UIHelper.horizontalSpaceSmall,
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                text: transaction.txid,
                                                style: subText2.copyWith(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: primaryColor),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        viewModel.copyAddress(
                                                            transaction.txid
                                                                .toString(),
                                                            context);
                                                        viewModel.openExplorer(
                                                            transaction.txid
                                                                .toString());
                                                      }),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.copy_outlined,
                                              color: black, size: 16),
                                          onPressed: () =>
                                              viewModel.copyAddress(
                                                  transaction.txid.toString(),
                                                  context),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        transaction.date!,
                                        style: headText5.copyWith(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                UIHelper.horizontalSpaceSmall,
                                UIHelper.horizontalSpaceSmall,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        FlutterI18n.translate(
                                            context, "quantity"),
                                        style: subText2),
                                    Text(
                                      transaction.amount!.toStringAsFixed(
                                          // model
                                          //   .decimalConfig
                                          //   .quantityDecimal
                                          2),
                                      style: headText5.copyWith(
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: viewModel.paginationModel.totalPages == 0
            ? Container()
            : PaginationWidget(
                paginationModel: viewModel.paginationModel,
                pageCallback: viewModel.getPaginationData));
  }
}
