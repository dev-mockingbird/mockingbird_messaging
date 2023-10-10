// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class AESHelper {
  static const String algorithm = "AES";
  static FortunaRandom? _secureRandom;

  static Uint8List decrypt(Uint8List ciphertext, Uint8List key) {
    BlockCipher cipher = CBCBlockCipher(BlockCipher(algorithm));
    final iv = ciphertext.sublist(0, 16);
    final params = PaddedBlockCipherParameters(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv), null);
    final paddingCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddingCipher.init(false, params);
    final encrypted = ciphertext.sublist(16);
    final plaintext = paddingCipher.process(encrypted);
    return plaintext;
  }

  static Uint8List encrypt(Uint8List plaintext, Uint8List key) {
    final iv = generateRandomBytes(16);
    final cipher = CBCBlockCipher(BlockCipher(algorithm));
    final params = PaddedBlockCipherParameters(
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv), null);
    final paddingCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddingCipher.init(true, params);
    final encrypted = paddingCipher.process(plaintext);
    final header = Uint8List(16)..setRange(0, 16, iv);
    final finalCiphertext = Uint8List.fromList(header + encrypted);
    return finalCiphertext;
  }

  /// [generateKey] Method
  /// Generates the key to Uint8List for encryption and description.
  static Uint8List generateKey(String passphrase, Uint8List salt) {
    Uint8List passphraseInt8List = Uint8List.fromList(passphrase.codeUnits);
    KeyDerivator derivator = PBKDF2KeyDerivator(HMac(SHA1Digest(), 64));
    Pbkdf2Parameters params = Pbkdf2Parameters(salt, 65556, 32);
    derivator.init(params);
    return derivator.process(passphraseInt8List);
  }

  static Uint8List generateRandomBytes(int numBytes) {
    if (_secureRandom == null) {
      _secureRandom = FortunaRandom();

      final seedSource = Random.secure();
      final seeds = <int>[];
      for (int i = 0; i < 32; i++) {
        seeds.add(seedSource.nextInt(256));
      }
      _secureRandom!.seed(KeyParameter(Uint8List.fromList(seeds)));
    }
    return _secureRandom!.nextBytes(numBytes);
  }
}
