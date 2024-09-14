import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final _key = encrypt.Key.fromLength(32); // Use a 32-byte key for AES
  static final _iv = encrypt.IV.fromLength(16); // 16-byte IV
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  static String encryptText(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  static String decryptText(String encryptedText) {
    return _encrypter.decrypt64(encryptedText, iv: _iv);
  }
}
