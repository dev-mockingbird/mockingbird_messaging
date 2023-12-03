// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/mockingbird_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Mockingbird> installService(String token) async {
  var transport = TcpTransport(ip: "127.0.0.1", port: 7001);
  // var transport = WebsocketTransport("ws://127.0.0.1:9000/ws");
  return await installServiceWithTransport(token, transport);
}

Future<Mockingbird> installServiceWithTransport(
  String token,
  Transport transport,
) async {
  var miaoba = Miaoba(
    transport: transport,
    encoding: JsonEncoding(),
    cryptoMethod: AcceptCrypto.methodAesRsaSha256,
    token: token,
  );
  var completer = Completer();
  Mockingbird.instance.addListener(() {
    switch (Mockingbird.instance.state) {
      case MockingbirdState.unconnect:
        print("unconnect");
        break;
      case MockingbirdState.connecting:
        print("connecting");
        break;
      case MockingbirdState.connected:
        print("connected");
        break;
      case MockingbirdState.modelSyncing:
        print("model syncing");
        break;
      case MockingbirdState.modelSynced:
        print("model synced");
        completer.complete();
        break;
    }
  });
  Mockingbird.instance.addEventListener((Event e) {
    print("${e.type}: ${e.payload}");
  });
  var r = await Mockingbird.instance.initialize(
    userId: "000004ydgqcv7aio",
    proto: miaoba,
    db: await Sqlite().getdb(),
    clientId: "xxxxxx",
  );
  if (!r) {
    print(
        "${Mockingbird.instance.lastCode}: ${Mockingbird.instance.lastError}");
    throw Mockingbird.instance.lastError;
  }
  await completer.future;
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
        await um.signup(
          "yangzhong",
          "CN",
          "958898012@qq.com",
          ContactType.email,
          "588136",
          "yZ123456",
        );
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
    test("test file id", () async {
      FileManager um = HttpFileManager(helper: getDioHelper());
      var fileId = await um.createFileId();
      print(fileId);
    });
    test("miaoba", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA1cjBubWhjYnVvMA==");
      Event? r = await mockingbird.send(
        buildEvent(CreateChannel(
          one2one: false,
          parentId: "000005qz8up72ebk",
          parentType: "message",
        )),
        waitResult: true,
        timeout: const Duration(seconds: 20),
      );
      if (r != null) {
        print("${r.type} ${r.payload}");
      } else {
        print("timeout or failed");
      }
      await Future.delayed(const Duration(hours: 1));
    });
    test("send message", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA0eWVnMG1jYnFwcw==");
      mockingbird.send(buildEvent(CreateMessage(
        channelId: "000005302j4jaygw",
        content: "你好",
        contentType: "text",
      )));
      await Future.delayed(const Duration(hours: 1));
    });
    test("typing", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA1cjBqdHhpNWwzNB==");
      mockingbird.send(buildEvent(TypeMessage(
        channelId: "000005302j4jaygw",
        content: "你好",
        contentType: "text",
        userId: '',
      )));
      await Future.delayed(const Duration(hours: 1));
    });
    test("move to folder", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA0eWVnMG1jYnFwcw==");
      mockingbird.send(buildEvent(UpdateChannelFolder(
        channelIds: ["000005302j4jaygw"],
        folder: "Hello World",
      )));
      await Future.delayed(const Duration(hours: 1));
    });
    test("like message", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA1ZXAycHVpaXRqNA==");
      var r = await mockingbird.send(
        buildEvent(LikeMessage.unlike(messageId: "00000531kypbp79c")),
        waitResult: true,
      );
      await Future.delayed(const Duration(hours: 1));
    });
    test("tag message", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA1ZXAycHVpaXRqNA==");
      var r = await mockingbird.send(
        buildEvent(
            TagMessage(messageId: "00000531kypbp79c", tag: 'hello world')),
        waitResult: true,
      );
      await Future.delayed(const Duration(hours: 1));
    });
    test("reconnect", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      Mockingbird mockingbird =
          await installService("MDAwMDA1ZXAycHVpaXRqNA==");
      await mockingbird.stop();
      var miaoba = Miaoba(
        transport: WebsocketTransport("ws://127.0.0.1:9000/ws"),
        encoding: JsonEncoding(),
        cryptoMethod: AcceptCrypto.methodAesRsaSha256,
        token: "MDAwMDA1ZXAycHVpaXRqNA==",
      );
      await mockingbird.initialize(
        userId: "000004ydgqcv7aio",
        proto: miaoba,
        db: await Sqlite().getdb(),
        clientId: "xxxxxx",
      );
      await mockingbird.stop();
      await Future.delayed(const Duration(hours: 1));
    });

    test("download", () async {
      SharedPreferences.setMockInitialValues({});
      WidgetsFlutterBinding.ensureInitialized();
      var fileManger = HttpFileManager(
        helper: DioHelper(domain: "http://127.0.0.1:9000"),
      );
      try {
        await fileManger.download(
          "/hello/world",
          "/hello/world",
        );
      } catch (e) {
        print(e);
      }
    });
  });
}
