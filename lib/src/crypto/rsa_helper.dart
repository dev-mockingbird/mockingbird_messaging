// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import "package:pointycastle/export.dart";
import 'package:pointycastle/pointycastle.dart';

class RSAHelper {
  static Uint8List decodePEM(String pem) {
    pem = pem.trim();
    var startsWith = [
      "-----BEGIN PUBLIC KEY-----",
      "-----BEGIN PRIVATE KEY-----",
      "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
      "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    ];
    var endsWith = [
      "-----END PUBLIC KEY-----",
      "-----END PRIVATE KEY-----",
      "-----END PGP PUBLIC KEY BLOCK-----",
      "-----END PGP PRIVATE KEY BLOCK-----",
    ];
    bool isOpenPgp = pem.contains('BEGIN PGP');

    for (var s in startsWith) {
      if (pem.startsWith(s)) {
        pem = pem.substring(s.length);
      }
    }

    for (var s in endsWith) {
      if (pem.endsWith(s)) {
        pem = pem.substring(0, pem.length - s.length);
      }
    }

    if (isOpenPgp) {
      var index = pem.indexOf('\r\n');
      pem = pem.substring(0, index);
    }

    pem = pem.replaceAll('\n', '');
    pem = pem.replaceAll('\r', '');

    return base64.decode(pem);
  }

  static AsymmetricKeyPair<PublicKey, PrivateKey> generateKeyPair() {
    var keyParams = RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 12);

    var secureRandom = FortunaRandom();
    var random = Random.secure();
    List<int> seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    var rngParams = ParametersWithRandom(keyParams, secureRandom);
    var k = RSAKeyGenerator();
    k.init(rngParams);

    return k.generateKeyPair();
  }

  static Uint8List encrypt(
      Uint8List plaintext, RSAPublicKey publicKey, DigestFactory f) {
    var cipher = OAEPEncoding.withCustomDigest(f, RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    String name = f().algorithmName;
    var chunkSize = getChunkSize(name);
    final numChunks = (plaintext.length / chunkSize).ceil();
    final chunks = List<Uint8List>.generate(numChunks, (i) {
      final start = i * chunkSize;
      int end = (i + 1) * chunkSize;
      if (end > plaintext.length) {
        end = plaintext.length;
      }
      return plaintext.sublist(start, end);
    });
    List<int> encrypted = [];
    for (final chunk in chunks) {
      encrypted.addAll(cipher.process(chunk));
    }
    return Uint8List.fromList(encrypted);
  }

  static int getChunkSize(String name) {
    switch (name) {
      case "SHA-1":
        return 256;
      case "SHA-224":
      case "SHA-256":
        return 256;
      case "SHA-384":
      case "SHA-512":
        return 512;
      default:
        return 512;
    }
  }

  static Uint8List decrypt(
      Uint8List ciphertext, RSAPrivateKey privateKey, DigestFactory f) {
    var cipher = OAEPEncoding.withCustomDigest(f, RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    String name = f().algorithmName;
    var chunkSize = getChunkSize(name);
    final numChunks = (ciphertext.length / chunkSize).ceil();
    final chunks = List<Uint8List>.generate(numChunks, (i) {
      final start = i * chunkSize;
      int end = (i + 1) * chunkSize;
      if (end > ciphertext.length) {
        end = ciphertext.length;
      }
      return ciphertext.sublist(start, end);
    });
    List<int> decrypted = [];
    for (final chunk in chunks) {
      decrypted.addAll(cipher.process(chunk));
    }
    return Uint8List.fromList(decrypted);
  }

  static RSAPublicKey? parsePublicKeyFromPem(String pem) {
    Uint8List publicKeyDER = decodePEM(pem);
    var asn1Parser = ASN1Parser(publicKeyDER);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    ASN1Integer modulus, exponent;
    // Depending on the first element type, we either have PKCS1 or 2
    if (topLevelSeq.elements![0].runtimeType == ASN1Integer) {
      modulus = topLevelSeq.elements![0] as ASN1Integer;
      exponent = topLevelSeq.elements![1] as ASN1Integer;
    } else {
      var publicKeyBitString = topLevelSeq.elements![1];

      var publicKeyAsn = ASN1Parser(publicKeyBitString.valueBytes);
      ASN1Sequence publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
      modulus = publicKeySeq.elements![0] as ASN1Integer;
      exponent = publicKeySeq.elements![1] as ASN1Integer;
    }

    RSAPublicKey rsaPublicKey =
        RSAPublicKey(modulus.integer!, exponent.integer!);

    return rsaPublicKey;
  }

  static RSAPrivateKey? parsePrivateKeyFromPem(String pem) {
    Uint8List privateKeyDER = decodePEM(pem);
    var asn1Parser = ASN1Parser(privateKeyDER);
    var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    ASN1Integer modulus, privateExponent, p, q;
    // Depending on the number of elements, we will either use PKCS1 or PKCS8
    if (topLevelSeq.elements!.length == 3) {
      var privateKey = topLevelSeq.elements![2];
      asn1Parser = ASN1Parser(privateKey.valueBytes);
      var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

      modulus = pkSeq.elements![1] as ASN1Integer;
      privateExponent = pkSeq.elements![3] as ASN1Integer;
      p = pkSeq.elements![4] as ASN1Integer;
      q = pkSeq.elements![5] as ASN1Integer;
    } else {
      modulus = topLevelSeq.elements![1] as ASN1Integer;
      privateExponent = topLevelSeq.elements![3] as ASN1Integer;
      p = topLevelSeq.elements![4] as ASN1Integer;
      q = topLevelSeq.elements![5] as ASN1Integer;
    }

    RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
        modulus.integer!, privateExponent.integer!, p.integer!, q.integer!);

    return rsaPrivateKey;
  }

  static String encodePublicKeyToPem(RSAPublicKey publicKey) {
    var topLevel = ASN1Sequence();
    topLevel.add(ASN1Integer(publicKey.modulus));
    topLevel.add(ASN1Integer(publicKey.exponent));
    var dataBase64 = base64.encode(topLevel.encode());
    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  static String encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    var topLevel = ASN1Sequence();

    var version = ASN1Integer(BigInt.from(0));
    var modulus = ASN1Integer(privateKey.n);
    var publicExponent = ASN1Integer.fromtInt(privateKey.exponent!.toInt());
    var privateExponent = ASN1Integer(privateKey.privateExponent);
    var p = ASN1Integer(privateKey.p);
    var q = ASN1Integer(privateKey.q);
    var dP = privateKey.privateExponent! % (privateKey.p! - BigInt.from(1));
    var exp1 = ASN1Integer(dP);
    var dQ = privateKey.privateExponent! % (privateKey.q! - BigInt.from(1));
    var exp2 = ASN1Integer(dQ);
    var iQ = privateKey.q!.modInverse(privateKey.p!);
    var co = ASN1Integer(iQ);

    topLevel.add(version);
    topLevel.add(modulus);
    topLevel.add(publicExponent);
    topLevel.add(privateExponent);
    topLevel.add(p);
    topLevel.add(q);
    topLevel.add(exp1);
    topLevel.add(exp2);
    topLevel.add(co);

    var dataBase64 = base64.encode(topLevel.encode());

    return """-----BEGIN PRIVATE KEY-----\r\n$dataBase64\r\n-----END PRIVATE KEY-----""";
  }
}
