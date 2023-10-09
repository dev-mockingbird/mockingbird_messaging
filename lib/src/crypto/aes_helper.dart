// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class AESHelper {
  static const String password = "password_here";
  static const String algorithm = "AES";
  static FortunaRandom? _secureRandom;

  static Uint8List decrypt(Uint8List cipherText, Uint8List key) {
    CBCBlockCipher cipher = CBCBlockCipher(BlockCipher(algorithm));

    Uint8List ciphertextlist = cipherText;
    Uint8List iv = generateRandomBytes(128 ~/ 8);
    Uint8List encrypted = ciphertextlist.sublist(20 + 16);

    ParametersWithIV<KeyParameter> params =
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, KeyParameter>
        paddingParams = PaddedBlockCipherParameters<
            ParametersWithIV<KeyParameter>, KeyParameter>(params, null);
    PaddedBlockCipherImpl paddingCipher =
        PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddingCipher.init(false, paddingParams);

    return paddingCipher.process(encrypted);
  }

  static Uint8List encrypt(Uint8List plainText, Uint8List key) {
    final CBCBlockCipher cbcCipher = CBCBlockCipher(BlockCipher(algorithm));
    List<int> data = plainText;
    Uint8List iv = generateRandomBytes(128 ~/ 8);
    final ParametersWithIV<KeyParameter> ivParams =
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    final PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>,
            KeyParameter> paddingParams =
        PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>,
            KeyParameter>(ivParams, null);
    final PaddedBlockCipherImpl paddedCipher =
        PaddedBlockCipherImpl(PKCS7Padding(), cbcCipher);
    paddedCipher.init(true, paddingParams);

    try {
      return paddedCipher.process(Uint8List.fromList(data));
    } catch (e) {
      return Uint8List.fromList([]);
    }
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
