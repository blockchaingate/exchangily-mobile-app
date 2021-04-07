import 'dart:io';
import 'dart:typed_data';

import 'package:exchangilymobileapp/constants/colors.dart';
import 'package:exchangilymobileapp/enums/screen_state.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet/wallet.dart';
import 'package:exchangilymobileapp/screen_state/base_state.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/shared/ui_helpers.dart';
import 'package:exchangilymobileapp/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exchangilymobileapp/services/db/token_list_database_service.dart';
import 'package:exchangilymobileapp/models/shared/pair_decimal_config_model.dart';
import 'package:exchangilymobileapp/utils/eth_util.dart';
import 'dart:convert';
import 'package:exchangilymobileapp/utils/fab_util.dart';
import 'package:exchangilymobileapp/utils/coin_util.dart';
import 'package:http/http.dart' as http;

class MoveToWalletViewmodel extends BaseState {
  final log = getLogger('MoveToWalletViewmodel');

  DialogService _dialogService = locator<DialogService>();
  WalletService walletService = locator<WalletService>();
  ApiService apiService = locator<ApiService>();
  SharedService sharedService = locator<SharedService>();
  TokenListDatabaseService tokenListDatabaseService =
      locator<TokenListDatabaseService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();

  WalletInfo walletInfo;
  BuildContext context;

  String gasFeeUnit = '';
  String feeMeasurement = '';
  final kanbanGasPriceTextController = TextEditingController();
  final kanbanGasLimitTextController = TextEditingController();
  final amountController = TextEditingController();
  var kanbanTransFee;
  var minimumAmount;
  bool transFeeAdvance = false;
  double gasAmount = 0.0;
  var withdrawLimit;
  PairDecimalConfig singlePairDecimalConfig = new PairDecimalConfig();
  bool isShowErrorDetailsButton = false;
  bool isShowDetailsMessage = false;
  String serverError = '';
  List<Map<String, dynamic>> chainBalances = [];
  var ethChainBalance;
  var fabChainBalance;
  var trxTsWalletBalance;
  bool isWithdrawChoice = false;
  String _groupValue;
  get groupValue => _groupValue;
  bool isShowFabChainBalance = false;
  bool isShowTrxTsWalletBalance = false;
  String specialTicker = '';
  String updateTickerForErc = '';
  bool isAlert = false;
  bool isSpeicalTronTokenWithdraw = false;

/*---------------------------------------------------
                      INIT
--------------------------------------------------- */
  void initState() {
    setBusy(true);
    print('ticker ${walletInfo.tickerName}');
    sharedService.context = context;
    var gasPrice = environment["chains"]["KANBAN"]["gasPrice"];
    var gasLimit = environment["chains"]["KANBAN"]["gasLimit"];
    kanbanGasPriceTextController.text = gasPrice.toString();
    kanbanGasLimitTextController.text = gasLimit.toString();

    kanbanTransFee = bigNum2Double(gasPrice * gasLimit);

    if (walletInfo.tickerName == 'ETH' || walletInfo.tickerName == 'USDT') {
      gasFeeUnit = 'WEI';
    } else if (walletInfo.tickerName == 'FAB') {
      gasFeeUnit = 'LIU';
      feeMeasurement = '10^(-8)';
    }
    checkGasBalance();
    getSingleCoinExchangeBal();
    getDecimalData();
    _groupValue = 'ETH';
    if (walletInfo.tickerName == 'FAB' ||
        walletInfo.tickerName == 'EXG' ||
        walletInfo.tickerName == 'DSC' ||
        walletInfo.tickerName == 'BST') {
      _groupValue = 'FAB';
      isShowFabChainBalance = true;
    }
    if (walletInfo.tickerName == 'USDTX') {
      _groupValue = 'TRX';
    }
    setWithdrawLimit(walletInfo.tickerName);
    specialTicker = walletService.updateSpecialTokensTickerNameForTxHistory(
        walletInfo.tickerName)['tickerName'];

    setBusy(false);
  }

/*---------------------------------------------------
                Info about TS wallet balance
--------------------------------------------------- */
  updateIsAlert(bool value) {
    setBusy(true);
    isAlert = value;
    log.i('update isAlert $isAlert');
    setBusy(false);
  }

/*---------------------------------------------------
          Info dialog
--------------------------------------------------- */
  showInfoDialog(bool isTSWalletInfo) {
    updateIsAlert(true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? Theme(
                data: ThemeData.dark(),
                child: CupertinoAlertDialog(
                  title: Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Center(
                        child: Text(
                      '${AppLocalizations.of(context).note}',
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: primaryColor, fontWeight: FontWeight.w500),
                    )),
                  ),
                  content: Container(
                    child: !isTSWalletInfo
                        ? Column(children: [
                            Text(
                                AppLocalizations.of(context)
                                    .specialExchangeBalanceNote,
                                style: Theme.of(context).textTheme.headline5),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('e.g. FAB and FAB(ERC20)',
                                  style: Theme.of(context).textTheme.headline5),
                            ),
                          ])
                        : Column(children: [
                            Text(AppLocalizations.of(context).tsWalletNote,
                                style: Theme.of(context).textTheme.headline5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                  AppLocalizations.of(context)
                                      .specialWithdrawNote,
                                  style: Theme.of(context).textTheme.headline5),
                            ),
                            UIHelper.verticalSpaceSmall,
                            Text(
                                AppLocalizations.of(context)
                                    .specialWithdrawFailNote,
                                style: Theme.of(context).textTheme.headline5),
                          ]),
                  ),
                  actions: <Widget>[
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.only(left: 5),
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: Text(
                              AppLocalizations.of(context).close,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ))
            : AlertDialog(
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.all(5.0),
                elevation: 5,
                backgroundColor: walletCardColor.withOpacity(0.85),
                title: Container(
                  padding: EdgeInsets.all(10.0),
                  color: secondaryColor.withOpacity(0.5),
                  child: Center(
                      child: Text('${AppLocalizations.of(context).note}')),
                ),
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontWeight: FontWeight.bold),
                contentTextStyle: TextStyle(color: grey),
                content: Container(
                  padding: EdgeInsets.all(5.0),
                  child: !isTSWalletInfo
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              Text(
                                  AppLocalizations.of(context)
                                      .specialExchangeBalanceNote,
                                  style: Theme.of(context).textTheme.headline5),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('e.g. FAB and FAB(ERC20)',
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  updateIsAlert(false);
                                },
                                child: Text(
                                  AppLocalizations.of(context).close,
                                  style: TextStyle(color: red),
                                ),
                              )
                            ])
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                              Text(AppLocalizations.of(context).tsWalletNote,
                                  style: Theme.of(context).textTheme.headline5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                    AppLocalizations.of(context)
                                        .specialWithdrawNote,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                              UIHelper.verticalSpaceSmall,
                              Text(
                                  AppLocalizations.of(context)
                                      .specialWithdrawFailNote,
                                  style: Theme.of(context).textTheme.headline5),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  updateIsAlert(false);
                                },
                                child: Text(
                                  AppLocalizations.of(context).close,
                                  style: TextStyle(color: red),
                                ),
                              )
                            ]),
                ));
      },
    );
  }

/*---------------------------------------------------
                    Details message toggle
--------------------------------------------------- */
  showDetailsMessageToggle() {
    setBusy(true);
    isShowDetailsMessage = !isShowDetailsMessage;
    setBusy(false);
  }

/*---------------------------------------------------
                      Decimal data
--------------------------------------------------- */
  getDecimalData() async {
    setBusy(true);
    singlePairDecimalConfig =
        await sharedService.getSinglePairDecimalConfig(walletInfo.tickerName);
    log.i('singlePairDecimalConfig ${singlePairDecimalConfig.toJson()}');
    setBusy(false);
  }

/*---------------------------------------------------
                Set Withdraw Limit
--------------------------------------------------- */

  setWithdrawLimit(String ticker) async {
    setBusy(true);
    withdrawLimit = environment["minimumWithdraw"][ticker];

    if (withdrawLimit == null) {
      await apiService.getTokenList().then((token) {
        token.forEach((token) {
          if (token.tickerName == ticker)
            withdrawLimit = double.parse(token.minWithdraw);
        });
      });
      if (withdrawLimit == null) {
        await apiService.getTokenListUpdates().then((token) {
          token.forEach((token) async {
            //    await tokenListDatabaseService.insert(token);
            if (token.tickerName == ticker)
              withdrawLimit = double.parse(token.minWithdraw);
          });
        });

        ///  await tokenListDatabaseService
        //     .getByTickerName(ticker)
        //   .then((token) => withdrawLimit = double.parse(token.minWithdraw));
      }
    }
    log.i('withdrawLimit $withdrawLimit');
    setBusy(false);
  }

/*---------------------------------------------------
                      Get gas
--------------------------------------------------- */

  checkGasBalance() async {
    String address = await sharedService.getExgAddressFromWalletDatabase();
    await walletService.gasBalance(address).then((data) {
      gasAmount = data;
      log.i('gas balance $gasAmount');
      if (gasAmount < 0.5) {
        sharedService.alertDialog(
          AppLocalizations.of(context).notice,
          AppLocalizations.of(context).insufficientGasAmount,
        );
      }
    }).catchError((onError) => log.e(onError));
    log.w('gas amount $gasAmount');
    return gasAmount;
  }

  // Check single coin exchange balance
  Future getSingleCoinExchangeBal() async {
    setBusy(true);
    String tickerName = '';
    if (walletInfo.tickerName == 'DSCE' || walletInfo.tickerName == 'DSC') {
      tickerName = 'DSC';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'BSTE' ||
        walletInfo.tickerName == 'BST') {
      tickerName = 'BST';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'FABE' ||
        walletInfo.tickerName == 'FAB') {
      tickerName = 'FAB';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'EXGE' ||
        walletInfo.tickerName == 'EXG') {
      tickerName = 'EXG';
      isWithdrawChoice = true;
    } else if (walletInfo.tickerName == 'USDT') {
      tickerName = 'USDT';
      isWithdrawChoice = true;
      isShowFabChainBalance = false;
    } else if (walletInfo.tickerName == 'USDTX') {
      tickerName = 'USDT';
      isWithdrawChoice = true;
      isShowFabChainBalance = false;
      isShowTrxTsWalletBalance = true;
    } else {
      tickerName = walletInfo.tickerName;
    }
    await apiService.getSingleCoinExchangeBalance(tickerName).then((res) {
      walletInfo.inExchange = res.unlockedAmount;
      log.w('single coin exchange balance check ${walletInfo.inExchange}');
    });

    if (isWithdrawChoice) {
      await getEthChainBalance();
      if (tickerName == 'USDT' || tickerName == 'USDTX') {
        // if (walletInfo.tickerName == 'USDTX') {
        await getTrxUsdtTsWalletBalance();
        // } else
        //   await getTrxTsWalletBalance();
      } else {
        tickerName == 'FAB'
            ? await getFabBalance()
            : await getFabChainBalance(tickerName);
      }
    }
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        TRX 20 TS Wallet Balance
----------------------------------------------------------------------*/
  getTrxTsWalletBalance() async {
    setBusy(true);
    String trxOfficialddress = getOfficalAddress('TRX');
    await apiService.getTronTsWalletBalance(trxOfficialddress).then((res) {
      trxTsWalletBalance = res['balance'] / 1e6;
      log.e('getTrxTsWalletBalance $trxTsWalletBalance');
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        TRX USDT TS Wallet Balance
----------------------------------------------------------------------*/
  getTrxUsdtTsWalletBalance() async {
    setBusy(true);

    String smartContractAddress = '';
    await tokenListDatabaseService
        .getContractAddressByTickerName("USDTX")
        .then((value) {
      if (value != null) {
        smartContractAddress = value;
      }
    });
    String trxOfficialddress = getOfficalAddress('TRX');
    await apiService
        .getTronUsdtTsWalletBalance(trxOfficialddress, smartContractAddress)
        .then((res) {
      trxTsWalletBalance = res / 1e6;
      log.e('getTrxTsWalletBalance $trxTsWalletBalance');
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        Fab Chain Balance
----------------------------------------------------------------------*/

  getFabBalance() async {
    setBusy(true);
    String fabAddress = getOfficalAddress('FAB');
    await walletService.coinBalanceByAddress('FAB', fabAddress, '').then((res) {
      log.e('fab res $res');
      fabChainBalance = res['balance'];
    });
    setBusy(false);
  }

  getFabChainBalance(String tickerName) async {
    setBusy(true);
    var address = sharedService.getEXGOfficialAddress();

    var smartContractAddress =
        environment["addresses"]["smartContract"][tickerName];
    if (smartContractAddress == null) {
      print('$tickerName contract is null so fetching from token database');
      await tokenListDatabaseService
          .getContractAddressByTickerName(tickerName)
          .then((value) {
        if (value != null) {
          if (!value.startsWith('0x'))
            smartContractAddress = '0x' + value;
          else
            smartContractAddress = value;
        }
      });
      print('official smart contract address $smartContractAddress');
    }

    String balanceInfoABI = '70a08231';

    var body = {
      'address': trimHexPrefix(smartContractAddress),
      'data': balanceInfoABI + fixLength(trimHexPrefix(address), 64)
    };
    var tokenBalance;
    var url = fabBaseUrl + 'callcontract';
    print(
        'Fab_util -- address $address getFabTokenBalanceForABI balance by address url -- $url -- body $body');

    var response = await http.post(url, body: body);
    var json = jsonDecode(response.body);
    var unlockBalance = json['executionResult']['output'];
    print('unlocl fab chain balance');
    // if (unlockBalance == null || unlockBalance == '') {
    //   return 0.0;

    var unlockInt = BigInt.parse(unlockBalance, radix: 16);

    // if ((decimal != null) && (decimal > 0)) {
    //   tokenBalance = ((unlockInt) / BigInt.parse(pow(10, decimal).toString()));
    // } else {
    tokenBalance = bigNum2Double(unlockInt);
    //   // print('tokenBalance for EXG==');
    //   // print(tokenBalance);
    // }

    // }

    fabChainBalance = tokenBalance;
    setBusy(false);
  }

/*----------------------------------------------------------------------
                        ETH Chain Balance
----------------------------------------------------------------------*/
  getEthChainBalance() async {
    setBusy(true);
    String officialAddress = '';
    officialAddress = getOfficalAddress('ETH');
    // call to get token balance
    if (walletInfo.tickerName == 'FAB') {
      updateTickerForErc = 'FABE';
    } else if (walletInfo.tickerName == 'DSC') {
      updateTickerForErc = 'DSCE';
    } else if (walletInfo.tickerName == 'BST') {
      updateTickerForErc = 'BSTE';
    } else if (walletInfo.tickerName == 'EXG') {
      updateTickerForErc = 'EXGE';
    } else if (walletInfo.tickerName == 'USDTX') {
      updateTickerForErc = 'USDT';
    } else {
      updateTickerForErc = walletInfo.tickerName;
    }
    await getEthTokenBalanceByAddress(officialAddress, updateTickerForErc)
        .then((res) {
      log.e('getEthChainBalance $res');
      if (walletInfo.tickerName == 'USDT' || walletInfo.tickerName == 'USDTX') {
        ethChainBalance = res['balance1e6'];
      } else if (walletInfo.tickerName == 'FABE' ||
          walletInfo.tickerName == 'FAB') {
        ethChainBalance = res['balanceIe8'];
      } else {
        ethChainBalance = res['tokenBalanceIe18'];
      }

      log.w('ethChainBalance $ethChainBalance');
    });
    setBusy(false);
  }

/*----------------------------------------------------------------------
                Radio button selection
----------------------------------------------------------------------*/

  radioButtonSelection(value) async {
    setBusy(true);
    print(value);
    _groupValue = value;
    if (value == 'FAB') {
      isShowFabChainBalance = true;
      isShowTrxTsWalletBalance = false;
      if (walletInfo.tickerName != 'FAB') walletInfo.tokenType = 'FAB';
      if (walletInfo.tickerName == 'FAB') walletInfo.tokenType = '';
      updateTickerForErc = walletInfo.tickerName;
      log.i('chain type ${walletInfo.tokenType}');
      setWithdrawLimit(walletInfo.tickerName);
    } else if (value == 'TRX') {
      isShowTrxTsWalletBalance = true;
      if (walletInfo.tickerName != 'TRX') walletInfo.tokenType = 'TRX';

      isSpeicalTronTokenWithdraw = true;
      //  walletInfo.tokenType = 'TRX';
      log.i('chain type ${walletInfo.tokenType}');
      setWithdrawLimit('USDTX');
    }
    // else if (walletInfo.tickerName == 'TRX' && !isShowTrxTsWalletBalance) {
    //   await tokenListDatabaseService
    //       .getByTickerName('USDTX')
    //       .then((token) => withdrawLimit = double.parse(token.minWithdraw));
    //   log.i('withdrawLimit $withdrawLimit');
    // }
    else {
      isShowTrxTsWalletBalance = false;
      isShowFabChainBalance = false;
      walletInfo.tokenType = 'ETH';
      log.i('chain type ${walletInfo.tokenType}');
      if (walletInfo.tickerName == 'FAB' && !isShowFabChainBalance) {
        setWithdrawLimit('FABE');
      } else if (walletInfo.tickerName == 'DSC' && !isShowFabChainBalance) {
        setWithdrawLimit('DSCE');
      } else if (walletInfo.tickerName == 'BST' && !isShowFabChainBalance) {
        setWithdrawLimit('BSTE');
      } else if (walletInfo.tickerName == 'EXG' && !isShowFabChainBalance) {
        setWithdrawLimit('EXGE');
      } else if (walletInfo.tickerName == 'USDTX' &&
          !isShowTrxTsWalletBalance) {
        setWithdrawLimit('USDT');
      } else
        setWithdrawLimit(walletInfo.tickerName);
      setBusy(false);
    }
  }

/*----------------------------------------------------------------------
                      Verify Wallet Password
----------------------------------------------------------------------*/
  checkPass() async {
    setBusy(true);
    try {
      if (amountController.text.isEmpty) {
        sharedService.showInfoFlushbar(
            AppLocalizations.of(context).minimumAmountError,
            AppLocalizations.of(context)
                .yourWithdrawMinimumAmountaIsNotSatisfied,
            Icons.cancel,
            red,
            context);
        setBusy(false);
        return;
      }
      await checkGasBalance();
      if (gasAmount == 0.0 || gasAmount < 0.5) {
        sharedService.alertDialog(
          AppLocalizations.of(context).notice,
          AppLocalizations.of(context).insufficientGasAmount,
        );
        setBusy(false);
        return;
      }

      var amount = double.tryParse(amountController.text);
      if (amount < withdrawLimit) {
        sharedService.showInfoFlushbar(
            AppLocalizations.of(context).minimumAmountError,
            AppLocalizations.of(context)
                .yourWithdrawMinimumAmountaIsNotSatisfied,
            Icons.cancel,
            red,
            context);
        setBusy(false);
        return;
      }
      await getSingleCoinExchangeBal();
      if (amount == null ||
          amount > walletInfo.inExchange ||
          amount == 0 ||
          amount.isNegative) {
        sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
            AppLocalizations.of(context).pleaseEnterValidNumber,
            isWarning: false);
        setBusy(false);
        return;
      }
      if (isWithdrawChoice) if (!isShowTrxTsWalletBalance &&
          isShowFabChainBalance &&
          amount > fabChainBalance) {
        sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
            AppLocalizations.of(context).pleaseEnterValidNumber,
            isWarning: false);
        setBusy(false);
        return;
      }

      /// show warning like amount should be less than ts wallet balance
      /// instead of displaying the generic error
      if (isWithdrawChoice) if (!isShowTrxTsWalletBalance &&
          !isShowFabChainBalance &&
          amount > ethChainBalance) {
        sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
            AppLocalizations.of(context).pleaseEnterValidNumber,
            isWarning: false);
        setBusy(false);
        return;
      }
      if (isWithdrawChoice) if (isShowTrxTsWalletBalance &&
          !isShowFabChainBalance &&
          amount > trxTsWalletBalance) {
        sharedService.alertDialog(AppLocalizations.of(context).invalidAmount,
            AppLocalizations.of(context).pleaseEnterValidNumber,
            isWarning: false);
        setBusy(false);
        return;
      }

      setMessage('');
      var res = await _dialogService.showDialog(
          title: AppLocalizations.of(context).enterPassword,
          description:
              AppLocalizations.of(context).dialogManagerTypeSamePasswordNote,
          buttonTitle: AppLocalizations.of(context).confirm);
      if (res.confirmed) {
        String exgAddress =
            await sharedService.getExgAddressFromWalletDatabase();
        String mnemonic = res.returnedText;
        Uint8List seed = walletService.generateSeed(mnemonic);
        // if (walletInfo.tickerName == 'FAB' && ) walletInfo.tokenType = '';
        var tokenType = walletInfo.tokenType;
        var coinName = walletInfo.tickerName;
        var coinAddress = '';
        if (isShowFabChainBalance && coinName != 'FAB') {
          coinAddress = exgAddress;
          tokenType = 'FAB';
          log.i('coin address is exg address');
        }

        /// Ticker is FAB but fab chain balance is false then
        /// take coin address as ETH wallet address because coin is an erc20
        else if (coinName == 'FAB' && !isShowFabChainBalance) {
          await walletDataBaseService
              .getBytickerName('ETH')
              .then((wallet) => coinAddress = wallet.address);
          log.i('coin address is ETH address');
        } else if (coinName == 'USDT' && isShowTrxTsWalletBalance) {
          await walletDataBaseService
              .getBytickerName('TRX')
              .then((wallet) => coinAddress = wallet.address);
          log.i('coin address is TRX address');
        } else {
          coinAddress = walletInfo.address;
          log.i('coin address is its own wallet info address');
        }
        // if (!isShowFabChainBalance) {
        //   amount = BigInt.tryParse(amountController.text);
        // }
        if (coinName == 'BCH') {
          await walletService.getBchAddressDetails(coinAddress).then(
              (addressDetails) =>
                  coinAddress = addressDetails['legacyAddress']);
        }

        var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
        var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);
        // BigInt bigIntAmount = BigInt.tryParse(amountController.text);
        // log.w('Big int from amount string $bigIntAmount');
        // if (bigIntAmount == null) {
        //   bigIntAmount = BigInt.from(amount);
        //   log.w('Bigint $bigIntAmount from amount $amount ');
        // }

        if (walletInfo.tickerName == 'TRX' ||
            walletInfo.tickerName == 'USDTX') {
          //      int kanbanGasPrice = environment['chains']['KANBAN']['gasPrice'];
          // int kanbanGasLimit = environment['chains']['KANBAN']['gasLimit'];
          await walletService
              .withdrawTron(seed, coinName, coinAddress, tokenType, amount,
                  kanbanPrice, kanbanGasLimit)
              .then((ret) {
            log.w(ret);
            bool success = ret["success"];
            if (success && ret['transactionHash'] != null) {
              String txId = ret['transactionHash'];
              log.i('txid $txId');
              amountController.text = '';
              serverError = '';
              isShowErrorDetailsButton = false;
              setMessage(txId);
            } else {
              serverError = ret['data'].toString();
              if (serverError == null || serverError == '') {
                var errMsg = AppLocalizations.of(context).serverError;
                setErrorMessage(errMsg);
                isShowErrorDetailsButton = true;
              }
            }
            sharedService.alertDialog(
                success && ret['transactionHash'] != null
                    ? AppLocalizations.of(context).withdrawTransactionSuccessful
                    : AppLocalizations.of(context).withdrawTransactionFailed,
                success ? "" : AppLocalizations.of(context).serverError,
                isWarning: false);
          }).catchError((err) {
            log.e('Withdraw catch $err');
            isShowErrorDetailsButton = true;
            serverError = err.toString();
          });
        } else {
          // withdraw function
          await walletService
              .withdrawDo(seed, coinName, coinAddress, tokenType, amount,
                  kanbanPrice, kanbanGasLimit, isSpeicalTronTokenWithdraw)
              .then((ret) {
            log.w(ret);
            bool success = ret["success"];
            if (success && ret['transactionHash'] != null) {
              String txId = ret['transactionHash'];
              log.i('txid $txId');
              amountController.text = '';
              serverError = '';
              isShowErrorDetailsButton = false;
              setMessage(txId);
            } else {
              serverError = ret['data'];
              if (serverError == null || serverError == '') {
                var errMsg = AppLocalizations.of(context).serverError;
                setErrorMessage(errMsg);
                isShowErrorDetailsButton = true;
              }
            }
            sharedService.alertDialog(
                success && ret['transactionHash'] != null
                    ? AppLocalizations.of(context).withdrawTransactionSuccessful
                    : AppLocalizations.of(context).withdrawTransactionFailed,
                success ? "" : AppLocalizations.of(context).serverError,
                isWarning: false);
          }).catchError((err) {
            log.e('Withdraw catch $err');
            isShowErrorDetailsButton = true;
            serverError = err.toString();
          });
        }
      } else if (!res.confirmed && res.returnedText == 'Closed') {
        print('else if close button pressed');
      } else {
        print('else');
        if (res.returnedText != 'Closed') {
          showNotification(context);
        }
      }
    } catch (err) {
      isShowErrorDetailsButton = true;
      serverError = err.toString();
      log.e('Withdraw catch $err');
    }
    setBusy(false);
  }

  showNotification(context) {
    setState(ViewState.Busy);
    sharedService.showInfoFlushbar(
        AppLocalizations.of(context).passwordMismatch,
        AppLocalizations.of(context).pleaseProvideTheCorrectPassword,
        Icons.cancel,
        red,
        context);
    setState(ViewState.Idle);
  }

  // update Transaction Fee

  updateTransFee() async {
    setBusy(true);
    var kanbanPrice = int.tryParse(kanbanGasPriceTextController.text);
    var kanbanGasLimit = int.tryParse(kanbanGasLimitTextController.text);

    var kanbanPriceBig = BigInt.from(kanbanPrice);
    var kanbanGasLimitBig = BigInt.from(kanbanGasLimit);
    var kanbanTransFeeDouble =
        bigNum2Double(kanbanPriceBig * kanbanGasLimitBig);
    print('Update trans fee $kanbanTransFeeDouble');

    kanbanTransFee = kanbanTransFeeDouble;
    setBusy(false);
  }

// Copy txid and display flushbar
  copyAndShowNotificatio(String message) {
    sharedService.copyAddress(context, message);
  }
}
