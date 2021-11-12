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

import 'dart:convert';
import 'dart:io';
import 'package:exchangilymobileapp/logger.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart' as CryptoHash;

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

  Future test(String pass, String mnemonic) async {
    String userTypedKey = pass;
    int userKeyLength = userTypedKey.length;
    String fixed32CharKey = '';

    if (userKeyLength < 32)
      fixed32CharKey = fixed32Chars(userTypedKey, userKeyLength);
    print('fixed32CharKey $fixed32CharKey');
    print(fixed32CharKey.length);
    var bytes = utf8.encode(fixed32CharKey);
    var digest = CryptoHash.sha256.convert(bytes);
    final key = encrypt.Key.fromUtf8(digest.toString());

    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    // final encrypted = encrypter.encrypt(mnemonic, iv: iv);
    // await saveEncryptedData(encrypted.base64);
  }

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
      log.e("Couldn't read file -$e");
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
