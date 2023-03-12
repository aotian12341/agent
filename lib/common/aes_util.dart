import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class AesUtil {
  static String aesD(String content, String ivStr) {
    String keyStr = "SY3N9szGvoAZS1LqB2sTx8rZco451auV";
    final key = Key.fromUtf8(keyStr);
    final iv = IV.fromUtf8(ivStr);

    final encryptor = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encryptor.decrypt64(content, iv: iv);

    return decrypted;
  }

  //AES解密
  static dynamic aesDecrypt(encrypted, String ivStr) {
    try {
      final key = Key.fromUtf8("SY3N9szGvoAZS1LqB2sTx8rZco451auV");
      final iv = IV.fromUtf8(ivStr);
      final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt64(encrypted, iv: iv);
      return decrypted;
    } catch (err) {
      print("aes decode error:$err");
      return encrypted;
    }
  }
}
