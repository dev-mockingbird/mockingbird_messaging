// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/src/encoding/encoding.dart';
import 'package:mockingbird_messaging/src/protocol/miaoba/miaoba.dart';
import 'package:mockingbird_messaging/src/protocol/miaoba/server_options.dart';
import 'package:mockingbird_messaging/src/transport/websocket.dart';

void main() async {
  group("miaoba", () {
    test("miaoba", () async {
      var miaoba = Miaoba(
        transport: WebsocketTransport("ws://127.0.0.1:7001"),
        encoding: JsonEncoding(),
        cryptoMethod: AcceptCrypto.methodAesRsaSha256,
      );
      miaoba.listen();
      await Future.delayed(const Duration(hours: 1), () {});
    });
  });
}
