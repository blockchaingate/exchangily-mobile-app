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

import 'dart:io';
import 'package:exchangilymobileapp/constants/constants.dart';
import 'package:exchangilymobileapp/logger.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';

class VaultService {
  final log = getLogger('VaultService');
  final String authCode = 'encrypted by crypto-js|';

  Future secureMnemonic(String pass, String mnemonic) async {
    String userTypedKey = pass;
    int userKeyLength = userTypedKey.length;
    String fixed32CharKey = '';

    if (userKeyLength < 32)
      fixed32CharKey = fixed32Chars(userTypedKey, userKeyLength);
    final key = encrypt.Key.fromUtf8(
        fixed32CharKey.isEmpty ? userTypedKey : fixed32CharKey);

    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(mnemonic, iv: iv);
    await saveEncryptedData(encrypted.base64);
  }

  Future secureMnemonicV1(String pass, String mnemonic) async {
    String userTypedKey = pass;

    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromUtf8(userTypedKey);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(mnemonic, iv: iv);
    await saveEncryptedData(encrypted.base64);
  }

  // encrypt mnemonic

  String encryptMnemonic(String pass, String mnemonic) {
    String userTypedKey = pass;
    int userKeyLength = userTypedKey.length;
    String fixed32CharKey = '';

    if (userKeyLength < 32)
      fixed32CharKey = fixed32Chars(userTypedKey, userKeyLength);
    final key = encrypt.Key.fromUtf8(
        fixed32CharKey.isEmpty ? userTypedKey : fixed32CharKey);

    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(mnemonic, iv: iv);
    return encrypted.base64;
  }

// --------- decrypt mnemonic start here

  Future<String> decryptMnemonic(
    String userTypedKey,
    String encryptedBase64Mnemonic,
  ) async {
    try {
      encrypt.Encrypted encryptedText =
          encrypt.Encrypted.fromBase64(encryptedBase64Mnemonic);

      int userKeyLength = userTypedKey.length;
      String fixed32CharKey = '';

      if (userKeyLength < 32)
        fixed32CharKey = fixed32Chars(userTypedKey, userKeyLength);
      final key = encrypt.Key.fromUtf8(
          fixed32CharKey.isEmpty ? userTypedKey : fixed32CharKey);

      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt(encryptedText, iv: iv);
      return decrypted;
    } catch (e) {
      log.e(
          "decryptMnemonic Couldn't read file -$e -- moving to decryptMnemonicV1");
      return await decryptMnemonicV1(
        userTypedKey,
        encryptedBase64Mnemonic,
      );
    }
  }

  Future<String> decryptMnemonicV1(
      String userTypedKey, String encryptedBase64Mnemonic,
      {bool isDeleteWalletReq = false}) async {
    try {
      encrypt.Encrypted encryptedText =
          encrypt.Encrypted.fromBase64(encryptedBase64Mnemonic);
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromUtf8(userTypedKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt(encryptedText, iv: iv);
      return Future.value(decrypted);
    } catch (e) {
      log.e(
          "decryptMnemonicV1 -- Couldn't read file -$e -- -- moving to decryptMnemonicV0");
      return await decryptMnemonicV0(
        userTypedKey,
        encryptedBase64Mnemonic,
      );
    }
  }

  Future<String> decryptMnemonicV0(
      String userTypedKey, String encryptedBase64Mnemonic) async {
    try {
      encrypt.Encrypted encryptedText =
          encrypt.Encrypted.fromBase64(encryptedBase64Mnemonic);
      final key = encrypt.Key.fromLength(16);
      final iv = encrypt.IV.fromUtf8(userTypedKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt(encryptedText, iv: iv);
      return Future.value(decrypted);
    } catch (e) {
      log.e(
          "decryptMnemonicV0 Couldn't read file -$e - moving to decryt data func which uses old method of file storage");

      return await decryptData(userTypedKey);
    }
  }

  // --------decrypt mnemonic functions ended here

  String fixed32Chars(String input, int keyLength) {
    if (input.length < 32) {
      int diff = 32 - keyLength;
      for (var i = 0; i < diff; i++) {
        input += '0';
      }
    }
    return input;
  }

  //  Read Encrypted Data from Storage

  Future<String> decryptData(String userTypedKey) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.byte');

      String fileContent = await file.readAsString();
      encrypt.Encrypted encryptedText =
          encrypt.Encrypted.fromBase64(fileContent);

      int userKeyLength = userTypedKey.length;
      String fixed32CharKey = '';
      if (userKeyLength < 32)
        fixed32CharKey = fixed32Chars(userTypedKey, userKeyLength);
      final key = encrypt.Key.fromUtf8(
          fixed32CharKey.isEmpty ? userTypedKey : fixed32CharKey);
      final iv = encrypt.IV.fromLength(16);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt(encryptedText, iv: iv);
      return Future.value(decrypted);
    } catch (e) {
      log.e(
          "decryptData -- Couldn't read file -$e ---- moving to decryptDataV1 ");
      return await decryptDataV1(userTypedKey);
    }
  }

  Future<String> decryptDataV1(String userTypedKey) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.byte');

      String fileContent = await file.readAsString();
      encrypt.Encrypted encryptedText =
          encrypt.Encrypted.fromBase64(fileContent);
      final key = encrypt.Key.fromLength(32);
      final iv = encrypt.IV.fromUtf8(userTypedKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt(encryptedText, iv: iv);
      return Future.value(decrypted);
    } catch (e) {
      log.e(
          "decryptDataV1 -- Couldn't read file -$e -- -- moving to decryptDataV0");
      return await decryptDataV0(userTypedKey);
    }
  }

  Future<String> decryptDataV0(String userTypedKey) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.byte');

      String fileContent = await file.readAsString();
      encrypt.Encrypted encryptedText =
          encrypt.Encrypted.fromBase64(fileContent);
      final key = encrypt.Key.fromLength(16);
      final iv = encrypt.IV.fromUtf8(userTypedKey);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt(encryptedText, iv: iv);
      return Future.value(decrypted);
    } catch (e) {
      log.e("Couldn't read file -$e");
      return Future.value('');
    }
  }
/*----------------------------------------------------------------------
                Save Encrypted Data to Storage
----------------------------------------------------------------------*/

  Future saveEncryptedData(String data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/my_file.byte');
      await deleteEncryptedData();
      await file.writeAsString(data);
      log.w('Encrypted data saved in storage');
    } catch (e) {
      log.e("Couldn't write encrypted datra to file!! $e");
    }
  }
/*----------------------------------------------------------------------
                Delete Encrypted Data
----------------------------------------------------------------------*/

  Future deleteEncryptedData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.byte');
    await file
        .delete()
        .then((res) => log.w('Previous data in the stored file deleted $res'))
        .catchError((error) => log.e('Previous data deletion failed $error'));
  }
}
