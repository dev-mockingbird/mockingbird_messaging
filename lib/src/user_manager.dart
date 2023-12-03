// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'http_helper.dart';
import 'storage/model/user.dart';

enum AccountType {
  email,
  phoneNumber,
  username,
  unkown,
}

enum ContactType {
  phoneNumber,
  email,
}

enum PassType {
  password,
  verifyCode,
}

class LoginUser {
  String token;
  User user;
  LoginUser({required this.token, required this.user});
}

abstract class UserManager {
  Future<LoginUser?> signup(
    String username,
    String countryCode,
    String contact,
    ContactType contactType,
    String verifyCode,
    String password, {
    HandleError? onError,
  });
  Future<LoginUser?> login(
    String account,
    AccountType accountType,
    PassType passType,
    String passcode, {
    HandleError? onError,
  });

  Future<bool> signout();

  Future<List<User>?> search(String keyword);

  Future<bool> sendVerifyCode(ContactType contactType, String contact);
  Future<AccountType?> verifyAccount(String account, {HandleError? onError});
  Future<bool> changePasswordByOldPassword(String password, String oldPassword,
      {HandleError? onError});

  Future<bool> changePasswordByVerifyCode(String password,
      ContactType contactType, String contact, String verifyCode,
      {HandleError? onError});
}

class HttpUserManager extends UserManager {
  static const Map<ContactType, String> contactTypes = {
    ContactType.email: "email",
    ContactType.phoneNumber: "phone_number",
  };

  static const Map<AccountType, String> accountTypes = {
    AccountType.email: "email",
    AccountType.username: "username",
    AccountType.phoneNumber: "phone_number",
  };

  static const Map<PassType, String> passTypes = {
    PassType.password: "password",
    PassType.verifyCode: "verify-code",
  };

  DioHelper helper;
  HttpUserManager({required this.helper});
  @override
  Future<bool> changePasswordByOldPassword(
    String password,
    String oldPassword, {
    HandleError? onError,
  }) async {
    return await helper.put("/password/by-old-password",
            data: {
              "old_password": oldPassword,
              "new_password": password,
            },
            showError: onError) !=
        null;
  }

  @override
  Future<bool> changePasswordByVerifyCode(
    String password,
    ContactType contactType,
    String contact,
    String verifyCode, {
    HandleError? onError,
  }) async {
    return await helper.put("/password/by-verify-code",
            data: {
              "new_password": password,
              "contact_type": contactTypes[contactType],
              "contact": contact,
              "verify_code": verifyCode,
            },
            showError: onError) !=
        null;
  }

  @override
  Future<LoginUser?> login(String account, AccountType accountType,
      PassType passType, String passcode,
      {HandleError? onError}) async {
    var res = await helper.post("/signin",
        data: {
          "account_type": accountTypes[accountType],
          "account": account,
          "pass_type": passTypes[passType],
          "passcode": passcode,
        },
        showError: onError);
    if (res != null) {
      return LoginUser(
          token: res['data']['token'],
          user: User.fromJson(res['data']['user']));
    }
    return null;
  }

  @override
  Future<List<User>> search(String keyword, {int limit = 20}) async {
    Map<String, dynamic> data = {};
    if (keyword != "") {
      data["keyword"] = keyword;
    }
    final res = await helper.get('/search-users', data: data);
    return (res['data'] as List).map((x) => User.fromJson(x)).toList();
  }

  @override
  Future<bool> sendVerifyCode(ContactType contactType, String contact) async {
    return await helper
            .post('/verify-code/${contactTypes[contactType]}/$contact') !=
        null;
  }

  @override
  Future<bool> signout() async {
    return await helper.post("/signout") != null;
  }

  @override
  Future<LoginUser?> signup(
    String username,
    String countryCode,
    String contact,
    ContactType contactType,
    String verifyCode,
    String password, {
    HandleError? onError,
  }) async {
    var res = await helper.post('/signup',
        data: {
          "name": username,
          "contact": contact,
          "country_code": countryCode,
          "contact_type": contactTypes[contactType],
          "verify_code": verifyCode,
          "password": password,
        },
        showError: onError);
    if (res != null) {
      return LoginUser(
        token: res['data']['token'],
        user: User.fromJson(res['data']['user']),
      );
    }
    return null;
  }

  @override
  Future<AccountType?> verifyAccount(String account,
      {HandleError? onError}) async {
    var res = await helper.get("/accounts/$account", onError: onError);
    if (res != null) {
      switch (res["data"]["type"]) {
        case "email":
          return AccountType.email;
        case "phone_number":
          return AccountType.phoneNumber;
        case "username":
          return AccountType.username;
        default:
          return AccountType.unkown;
      }
    }
    return null;
  }
}
