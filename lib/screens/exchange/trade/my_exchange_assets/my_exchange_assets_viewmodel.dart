import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/db/wallet_database_service.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:stacked/stacked.dart';

class MyExchangeAssetsViewModel extends FutureViewModel {
  WalletService walletService = locator<WalletService>();
  WalletDataBaseService walletDataBaseService =
      locator<WalletDataBaseService>();

  @override
  Future futureToRun() async {
    String exgAddress = await getExgAddress();
    print(exgAddress);
    return walletService.assetsBalance(exgAddress);
  }

  Future<String> getExgAddress() async {
    var exgWallet = await walletDataBaseService.getBytickerName('EXG');
    return exgWallet.address;
  }
}
