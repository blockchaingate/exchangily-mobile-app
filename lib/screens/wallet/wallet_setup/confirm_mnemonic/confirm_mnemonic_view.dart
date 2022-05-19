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

import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'confirm_mnemonic_viewmodel.dart';
import 'verify_mnemonic.dart';

class ConfirmMnemonicView extends StatelessWidget {
  final List<String> randomMnemonicListFromRoute;
  const ConfirmMnemonicView({Key key, this.randomMnemonicListFromRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ConfirmMnemonicViewModel>.reactive(
      viewModelBuilder: () => ConfirmMnemonicViewModel(),
      onModelReady: (model) {
        model.init();
        model.randomMnemonicList.addAll(randomMnemonicListFromRoute);
        randomMnemonicListFromRoute.shuffle();
      },
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.onBackButtonPressed();
          return Future(() => false);
        },
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: Text(
                '${AppLocalizations.of(context).confirm} ${AppLocalizations.of(context).mnemonic}',
                style: Theme.of(context).textTheme.headline3,
              ),
              backgroundColor: secondaryColor),
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
                        shape: MaterialStateProperty.all(const StadiumBorder(
                            side: BorderSide(color: primaryColor, width: 2))),
                      ),
                      child: Text(
                          'Verify Mnemonic by tap on words in the correct order',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              fontWeight: model.isTap
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                      onPressed: () {
                        //    model.shuffleStringList();
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
                        shape: MaterialStateProperty.all(const StadiumBorder(
                            side: BorderSide(color: secondaryColor, width: 2))),
                      ),
                      child: Text('Verify Mnemonic by typing mnemonic words',
                          style: Theme.of(context).textTheme.headline5.copyWith(
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
                                model.clearTappedList();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 2.0),
                                    child: Icon(
                                      Icons.restore_sharp,
                                      color: yellow,
                                      size: 20,
                                    ),
                                  ),
                                  Text('Reset Selection',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(color: yellow)),
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
                                      randomMnemonicListFromRoute[i];

                                  //model.shuffledList[i];

                                  return TextField(
                                    onTap: () {
                                      model.selectWordsInOrder(i, singleWord);
                                    },
                                    controller: model.tapTextControllerList[i],
                                    textAlign: TextAlign.center,
                                    textAlignVertical:
                                        const TextAlignVertical(y: 0.7),
                                    enableInteractiveSelection:
                                        false, // readonly
                                    // enabled: false, // if false use cant see the selection border around
                                    readOnly: true,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      // alignLabelWithHint: true,
                                      fillColor:

                                          //  model.tappedMnemonicList
                                          //         .contains(singleWord)
                                          //         &&
                                          //     !model.isSameIndex
                                          model.tapTextControllerList[i].text
                                                  .contains(')')
                                              ? green
                                              : primaryColor,
                                      filled: true,
                                      hintText: singleWord,
                                      hintMaxLines: 1,
                                      hintStyle: const TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.w400),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
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
                      shape: MaterialStateProperty.all(const StadiumBorder(
                          side: BorderSide(color: primaryColor, width: 2))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        AppLocalizations.of(context).finishWalletBackup,
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    onPressed: () {
                      // if (model.isTap) model.clearTappedList();
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
