import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as prefix0;

class VaultService {
  final log = getLogger('VaultService');

  WalletService _walletService = locator<WalletService>();

  Future secureSeed(context, pass) async {
    String randomMnemonic = Provider.of<String>(context);
    _walletService.generateSeedFromUser(randomMnemonic);

    String userTypedKey = pass;

    final key = prefix0.Key.fromLength(32);
    final iv = prefix0.IV.fromUtf8(userTypedKey);
    final encrypter = prefix0.Encrypter(prefix0.AES(key));

    final encrypted = encrypter.encrypt(randomMnemonic, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
    // log.w('decrypted phrase - $decrypted');
    // log.w('encrypted phrase - ${encrypted.base64}');
    // log.w('decrypted phrase with user key - $decrypted');
    await _walletService.saveEncryptedData(encrypted.base64);
    //log.w('Printing encrypted data from vault service $test');
    // walletService
    //     .writeStorage(userTypedKey, encrypted.base64)
    //     .whenComplete(readKey());
  }
}
