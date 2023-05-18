import 'dart:typed_data';

import 'package:exchangilymobileapp/environments/coins.dart';
import 'package:exchangilymobileapp/environments/environment.dart';
import 'package:exchangilymobileapp/localizations.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/api_service.dart';
import 'package:exchangilymobileapp/services/coin_service.dart';
import 'package:exchangilymobileapp/services/dialog_service.dart';
import 'package:exchangilymobileapp/services/local_storage_service.dart';
import 'package:exchangilymobileapp/services/shared_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:exchangilymobileapp/utils/abi_util.dart';
import 'package:exchangilymobileapp/utils/kanban.util.dart';
import 'package:exchangilymobileapp/utils/keypair_util.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:hex/hex.dart';
import '../exchange_balance_service.dart';
import 'locker_model.dart';

class LockerViewModel extends ReactiveViewModel {
  final log = getLogger('LockerViewModel');

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_exchangeBalanceService!];

  late BuildContext context;
  SharedService? sharedService = locator<SharedService>();
  WalletService? walletService = locator<WalletService>();
  ApiService? apiService = locator<ApiService>();
  LocalStorageService? storageService = locator<LocalStorageService>();
  final DialogService? _dialogService = locator<DialogService>();
  final CoinService? coinService = locator<CoinService>();
  final ExchangeBalanceService? _exchangeBalanceService = locator<ExchangeBalanceService>();

  var abiUtils = AbiUtils();
  var kanbanUtils = KanbanUtils();

  List<LockerModel> get lockers => _exchangeBalanceService!.lockers;
  String? exgAddress = '';

  @override
  void dispose() {
    log.e('MyExchangeAssetsViewModel disposed');
    super.dispose();
  }

  void init() async {
    setBusy(true);
    exgAddress = await sharedService!.getExgAddressFromWalletDatabase();

    await getLockersData();
    setBusy(false);
  }

  getLockersData() async {
    setBusyForObject(lockers, true);
    if (exgAddress!.isEmpty) {
      exgAddress = await sharedService!.getExgAddressFromWalletDatabase();
    }

    await _exchangeBalanceService!.getLockers(exgAddress!);

    if (lockers.isNotEmpty) {
      for (var locker in lockers) {
        String tickerNameByCointype = newCoinTypeMap[locker.coinType] ?? '';
        if (tickerNameByCointype.isEmpty) {
          var tokenRes = (await coinService!.getSingleTokenData('',
              coinType: locker.coinType))!;
          if (tokenRes.tickerName!.isNotEmpty) {
            locker.tickerName = tokenRes.tickerName;
          }
        } else {
          locker.tickerName = tickerNameByCointype;
        }
      }
    }
    //log.i('updateTabSelection: lockers length ${lockers.first.toJson()}');
    setBusyForObject(lockers, false);
  }

  unlockCoins(LockerModel selectedLocker) async {
    var abiUtils = AbiUtils();
    var kanbanUtils = KanbanUtils();

    var res = await _dialogService!.showDialog(
        title: AppLocalizations.of(context)!.enterPassword,
        description:
            AppLocalizations.of(context)!.dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context)!.confirm);

    if (res.confirmed!) {
      String exgAddress = (await sharedService!.getExgAddressFromWalletDatabase())!;
      String? mnemonic = res.returnedText;
      Uint8List seed = walletService!.generateSeed(mnemonic);

      var keyPairKanban = getExgKeyPair(Uint8List.fromList(seed));
      debugPrint('keyPairKanban $keyPairKanban');

      int? kanbanGasPrice = environment["chains"]["KANBAN"]["gasPrice"];
      int? kanbanGasLimit = environment["chains"]["KANBAN"]["gasLimit"];

      var nonce = await kanbanUtils.getNonce(exgAddress);

      var abiHex =
          abiUtils.construcUnlockAbiHex(selectedLocker.id!, selectedLocker.user!);
      var txKanbanHex;
      try {
        txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
            abiHex,
            HEX.encode(keyPairKanban["privateKey"]),
            selectedLocker.address!,
            nonce,
            kanbanGasPrice,
            kanbanGasLimit);
      } catch (err) {
        setBusy(false);
        log.e('err $err');
      }
      var sendRawKanbanTxRes =
          kanbanUtils.sendRawKanbanTransaction(txKanbanHex);
      log.w('res $sendRawKanbanTxRes');
    }
  }

  lockCoins(LockerModel selectedLocker) async {
    var res = await _dialogService!.showDialog(
        title: AppLocalizations.of(context)!.enterPassword,
        description:
            AppLocalizations.of(context)!.dialogManagerTypeSamePasswordNote,
        buttonTitle: AppLocalizations.of(context)!.confirm);

    if (res.confirmed!) {
      String exgAddress = (await sharedService!.getExgAddressFromWalletDatabase())!;
      String? mnemonic = res.returnedText;
      Uint8List seed = walletService!.generateSeed(mnemonic);

      var keyPairKanban = getExgKeyPair(Uint8List.fromList(seed));
      debugPrint('keyPairKanban $keyPairKanban');

      int? kanbanGasPrice = environment["chains"]["KANBAN"]["gasPrice"];
      int? kanbanGasLimit = environment["chains"]["KANBAN"]["gasLimit"];

      var nonce = await kanbanUtils.getNonce(exgAddress);

      var abiHex =
          abiUtils.construcUnlockAbiHex(selectedLocker.id!, selectedLocker.user!);
      var txKanbanHex;
      try {
        txKanbanHex = await abiUtils.signAbiHexWithPrivateKey(
            abiHex,
            HEX.encode(keyPairKanban["privateKey"]),
            selectedLocker.address!,
            nonce,
            kanbanGasPrice,
            kanbanGasLimit);
      } catch (err) {
        setBusy(false);
        log.e('err $err');
      }
      var sendRawKanbanTxRes =
          kanbanUtils.sendRawKanbanTransaction(txKanbanHex);
      log.w('res $sendRawKanbanTxRes');
    }
  }
}
