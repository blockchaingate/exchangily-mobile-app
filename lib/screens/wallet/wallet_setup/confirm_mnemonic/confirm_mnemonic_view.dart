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
import 'package:exchangilymobileapp/constants/custom_styles.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:stacked/stacked.dart';

import 'confirm_mnemonic_viewmodel.dart';
import 'verify_mnemonic.dart';

class ConfirmMnemonicView extends StatelessWidget {
  final List<String>? randomMnemonicListFromRoute;
  const ConfirmMnemonicView({Key? key, this.randomMnemonicListFromRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmMnemonicViewModel>.reactive(
      viewModelBuilder: () => ConfirmMnemonicViewModel(),
      onViewModelReady: (model) {
        model.context = context;
        model.init();
        model.randomMnemonicList.addAll(randomMnemonicListFromRoute!);
        randomMnemonicListFromRoute!.shuffle();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return Future(() => false);
        },
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: 28, color: Theme.of(context).hintColor),
                onPressed: () {
                  model.navigationService.goBack();
                },
              ),
              title: Text(
                '${FlutterI18n.translate(context, "confirm")} ${FlutterI18n.translate(context, "mnemonic")}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              backgroundColor: Theme.of(context).canvasColor),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: model.isTap ? green : grey)),
                        // backgroundColor: MaterialStateProperty.all(primaryColor),
                        elevation: MaterialStateProperty.all(5),
                        shape: MaterialStateProperty.all(StadiumBorder(
                            side: BorderSide(color: primaryColor, width: 2))),
                      ),
                      child: Text(
                          FlutterI18n.translate(context, "verifyMnemonicByTap"),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontWeight: model.isTap
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                      onPressed: () {
                        model.selectConfirmMethod('tap');
                      },
                    ),
                    UIHelper.verticalSpaceSmall,
                    OutlinedButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                            BorderSide(color: model.isTap ? grey : green)),
                        // backgroundColor: MaterialStateProperty.all(primaryColor),
                        elevation: MaterialStateProperty.all(5),
                        shape: MaterialStateProperty.all(StadiumBorder(
                            side: BorderSide(
                                color: Theme.of(context).canvasColor,
                                width: 2))),
                      ),
                      child: Text(
                          FlutterI18n.translate(
                              context, "verifyMnemonicByWrite"),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontWeight: !model.isTap
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                      onPressed: () => model.selectConfirmMethod('write'),
                    ),
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                UIHelper.divider,
                UIHelper.verticalSpaceSmall,
                !model.isTap
                    ? VerifyMnemonicWalletView(
                        mnemonicTextController: model.controller,
                        count: model.count,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () {
                                model.resetList();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                      Icons.restore_sharp,
                                      color: Theme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                      FlutterI18n.translate(
                                          context, "resetSelection"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!),
                                ],
                              )),
                          UIHelper.verticalSpaceSmall,
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 5),
                            child: GridView.extent(
                                maxCrossAxisExtent: 125,
                                padding: const EdgeInsets.all(2),
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 10,
                                shrinkWrap: true,
                                childAspectRatio: 2,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(model.count, (i) {
                                  // if (model.shuffledList.isEmpty)
                                  //   model.shuffledList = model.randomMnemonicList;

                                  var singleWord =
                                      randomMnemonicListFromRoute![i];

                                  //model.shuffledList[i];

                                  return TextField(
                                    onTap: () {
                                      model.selectWordsInOrder(i, singleWord);
                                    },
                                    controller: model.tapTextControllerList[i],
                                    textAlign: TextAlign.center,

                                    enableInteractiveSelection:
                                        false, // readonly
                                    // enabled: false, // if false use cant see the selection border around
                                    readOnly: true,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      // alignLabelWithHint: true,
                                      fillColor: model
                                              .tapTextControllerList[i].text
                                              .contains(')')
                                          ? green
                                          : primaryColor,
                                      filled: true,
                                      hintText: singleWord,
                                      hintMaxLines: 1,
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                              color:
                                                  getTextColor(primaryColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: white, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                          UIHelper.verticalSpaceMedium,
                        ],
                      ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      elevation: MaterialStateProperty.all(5),
                      shape: MaterialStateProperty.all(StadiumBorder(
                          side: BorderSide(color: primaryColor, width: 2))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        FlutterI18n.translate(context, "finishWalletBackup"),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: getTextColor(primaryColor)),
                      ),
                    ),
                    onPressed: () {
                      // if (model.isTap) model.clearTappedList();s
                      model.verifyMnemonic(
                          model.isTap
                              ? model.tappedMnemonicList
                              : model.controller,
                          context,
                          model.count,
                          'create');
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
