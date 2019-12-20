import 'package:exchangilymobileapp/logger.dart';
import 'package:exchangilymobileapp/models/wallet.dart';
import 'package:exchangilymobileapp/services/wallet_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../shared/globals.dart' as globals;
import 'package:encrypt/encrypt.dart' as prefix0;

class CreateWalletViewModel extends ChangeNotifier {
  List<WalletInfo> _walletInfo;
  final log = getLogger('Create Wallet View Model');
  WalletService _walletService;
  final storage = new FlutterSecureStorage(); // Create Storage
  bool _busy;

  CreateWalletViewModel({@required WalletService walletService})
      : _walletService = walletService;

  bool get busy => _busy;

  Future<List<WalletInfo>> getAllCoins() async {
    setBusy(true);
    var success = await _walletService.getAllCoins();
    setBusy(false);
    return success;
  }

  validatePassword(pass, confirmPass, context) {
    Pattern pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(pattern);
    log.w(pass);
    if (pass.isEmpty) {
      showInfoFlushbar('Empty Password', 'Please fill both password fields',
          Icons.cancel, Colors.red, context);
    } else {
      if (!regex.hasMatch(pass))
        showInfoFlushbar(
            'Password Conditions Mismatch,',
            'Please enter the password that satisfy above conditions',
            Icons.cancel,
            Colors.red,
            context);
      else if (pass != confirmPass) {
        showInfoFlushbar(
            'Password Mismatch',
            'Please retype the same password in both fields',
            Icons.cancel,
            Colors.red,
            context);
      } else {
        //  var walletSuccess = await getAllCoins();

        // log.w('in else condition passed');
        // getBalances();
        secureSeed(context, pass);
        log.w('In else');
        return true;
      }
    }
  }

  getBalances(context, pass) async {
    // var mnemonic = Provider.of<String>(context);
    _walletInfo = await getAllCoins();
    log.w('wallet info length ${_walletInfo.length}');
    Navigator.pushNamed(context, '/totalBalance', arguments: _walletInfo);
  }

  secureSeed(context, pass) {
    String randomMnemonic = Provider.of<String>(context);
    _walletService.generateSeedFromUser(randomMnemonic);

    String userTypedKey = pass;

    final key = prefix0.Key.fromLength(32);
    final iv = prefix0.IV.fromUtf8(userTypedKey);
    final encrypter = prefix0.Encrypter(prefix0.AES(key));

    final encrypted = encrypter.encrypt(randomMnemonic, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    log.w('decrypted phrase - $decrypted');
    log.w('encrypted phrase - ${encrypted.base64}');
    log.w('decrypted phrase with user key - $decrypted');
    _walletService.saveEncryptedData(encrypted.base64);
    // walletService.readEncryptedData();
    // walletService
    //     .writeStorage(userTypedKey, encrypted.base64)
    //     .whenComplete(readKey());
  }

  void showInfoFlushbar(String title, String message, IconData iconData,
      Color leftBarColor, BuildContext context) {
    Flushbar(
      backgroundColor: globals.secondaryColor.withOpacity(0.75),
      title: title,
      message: message,
      icon: Icon(
        iconData,
        size: 24,
        color: globals.primaryColor,
      ),
      leftBarIndicatorColor: leftBarColor,
      duration: Duration(seconds: 3),
    ).show(context);
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
