import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/service_locator.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as prefix0;

class VaultService {
  final log = getLogger('VaultService');

  WalletService _walletService = locator<WalletService>();

  Future secureSeed(context, pass, String mnemonic) async {
    var seed;
    String randomMnemonic;
    if (mnemonic == '' || mnemonic == null) {
      log.e('import mnemonic is: $mnemonic');
      randomMnemonic = Provider.of<String>(context);
      seed = _walletService.generateSeed(randomMnemonic);
      log.w(seed);
      // final storage = new FlutterSecureStorage();
      // log.e('seed 1');
      // await storage.write(key: 'seed', value: seed);
      // log.i('seed 2');
      // var test = await storage.read(key: 'seed');
      // log.e(test);
    } else {
      randomMnemonic = mnemonic;
      log.e('random and import mnemonic - $randomMnemonic = $mnemonic');
    }

    String userTypedKey = pass;
    final key = prefix0.Key.fromLength(32);
    final iv = prefix0.IV.fromUtf8(userTypedKey);
    final encrypter = prefix0.Encrypter(prefix0.AES(key));
    final encrypted = encrypter.encrypt(randomMnemonic, iv: iv);
    await _walletService.saveEncryptedData(encrypted.base64);
    randomMnemonic = '';
  }
}
