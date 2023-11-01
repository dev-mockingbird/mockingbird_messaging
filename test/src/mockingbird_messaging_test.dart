// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/src/mockingbird.dart';
import 'package:mockingbird_messaging/src/encoding/encoding.dart';
import 'package:mockingbird_messaging/src/event/channel.dart';
import 'package:mockingbird_messaging/src/event/event.dart';
import 'package:mockingbird_messaging/src/event/message.dart';
import 'package:mockingbird_messaging/src/http_helper.dart';
import 'package:mockingbird_messaging/src/protocol/miaoba/miaoba.dart';
import 'package:mockingbird_messaging/src/protocol/miaoba/server_options.dart';
import 'package:mockingbird_messaging/src/storage/sqlite.dart';
import 'package:mockingbird_messaging/src/transport/websocket.dart';
import 'package:mockingbird_messaging/src/user_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Mockingbird> installService(String token) async {
  var miaoba = Miaoba(
    transport: WebsocketTransport("ws://127.0.0.1:9000/ws"),
    encoding: JsonEncoding(),
    cryptoMethod: AcceptCrypto.methodAesRsaSha256,
    token: token,
  );
  miaoba.listen();
  Mockingbird.instance.addEventListener((Event e) {
    print("${e.type}: ${e.payload}");
  });
  await Mockingbird.instance.initialize(
    userId: "000004ydgqcv7aio",
    proto: miaoba,
    db: await Sqlite().getdb(),
    clientId: "xxxxxx",
  );
  return Mockingbird.instance;
}

getDioHelper() {
  return DioHelper(
      domain: "http://127.0.0.1:9000",
      onError: (e) {
        if (e is DioException) {
          print("${e.response?.data}, ${e.response?.statusCode}");
        } else {
          print(e);
        }
      });
}

void main() async {
  group("miaoba", () {
    test("send verify code", () async {
      UserManager um = HttpUserManager(helper: getDioHelper());
      await um.sendVerifyCode(ContactType.email, "958898012@qq.com");
    });
    test("signup", () async {
      UserManager um = HttpUserManager(helper: getDioHelper());
      try {
        await um.signup("yangzhong", "958898012@qq.com", ContactType.email,
            "588136", "yZ123456");
      } catch (e) {
        print(e);
      }
    });
    test("signin", () async {
      UserManager um = HttpUserManager(helper: getDioHelper());
      var loginUser = await um.login(
          "yangzhong", AccountType.username, PassType.password, "yZ123456");
      if (loginUser != null) {
        print(loginUser.user.id);
        print(loginUser.token);
      }
    });
    test("account info", () async {
      UserManager um = HttpUserManager(helper: getDioHelper());
      var accountType = await um.verifyAccount("yangzhong");
      print(accountType);
    });
    test("miaoba", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA0eWVnMG1jYnFwcw==");
      mockingbird.protocol.send(buildEvent(CreateChannel()));
      await Future.delayed(const Duration(hours: 1));
    });
    test("send message", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA0eWVnMG1jYnFwcw==");
      mockingbird.protocol.send(buildEvent(CreateMessage(
        channelId: "000005302j4jaygw",
        content: "hello world",
        contentType: "text",
      )));
      await Future.delayed(const Duration(hours: 1));
    });
    test("typing", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA0eWVnMG1jYnFwcw==");
      mockingbird.protocol.send(buildEvent(Typing(
        channelId: "000005302j4jaygw",
        content: "hello world",
        contentType: "text",
      )));
      await Future.delayed(const Duration(hours: 1));
    });
  });
}
