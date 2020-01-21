import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:encrypt/encrypt.dart' as prefix0;

class VaultService {
  final log = getLogger('VaultService');

  WalletService _walletService = locator<WalletService>();

  Future secureMnemonic(context, String pass, String mnemonic) async {
    _walletService.generateSeed(mnemonic);

    log.w(mnemonic);
    String userTypedKey = pass;
    final key = prefix0.Key.fromLength(32);
    final iv = prefix0.IV.fromUtf8(userTypedKey);
    final encrypter = prefix0.Encrypter(prefix0.AES(key));
    final encrypted = encrypter.encrypt(mnemonic, iv: iv);
    await _walletService.saveEncryptedData(encrypted.base64);
  }
}
