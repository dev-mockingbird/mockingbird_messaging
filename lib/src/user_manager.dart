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

typedef Token = String;

abstract class UserManager {
  Future<Token> signup(
    String username,
    String contact,
    ContactType contactType,
    String verifyCode,
    String password,
  );
  Future<Token> login(
    String account,
    AccountType accountType,
    PassType passType,
    String passcode,
  );
  Future<void> signout();

  Future<List<User>> search(String keyword);

  Future<void> sendVerifyCode(ContactType contactType, String contact);
  Future<AccountType> verifyAccount(String account);
  Future<void> changePasswordByOldPassword(String password, String oldPassword);

  Future<void> changePasswordByVerifyCode(String password,
      ContactType contactType, String contact, String verifyCode);
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
  Future<void> changePasswordByOldPassword(
      String password, String oldPassword) async {
    await helper.put("/password/by-old-password", data: {
      "old_password": oldPassword,
      "new_password": password,
    });
  }

  @override
  Future<void> changePasswordByVerifyCode(String password,
      ContactType contactType, String contact, String verifyCode) async {
    await helper.put("/password/by-verify-code", data: {
      "new_password": password,
      "contact_type": contactTypes[contactType],
      "contact": contact,
      "verify_code": verifyCode,
    });
  }

  @override
  Future<Token> login(String account, AccountType accountType,
      PassType passType, String passcode) async {
    var res = await helper.post("/signin", data: {
      "account_type": accountTypes[accountType],
      "account": account,
      "pass_type": passTypes[passType],
      "passcode": passcode,
    });
    return res['data']['token'];
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
  Future<void> sendVerifyCode(ContactType contactType, String contact) async {
    await helper.post('/verify-code/${contactTypes[contactType]}/$contact');
  }

  @override
  Future<void> signout() async {
    await helper.post("/signout");
  }

  @override
  Future<Token> signup(String username, String contact, ContactType contactType,
      String verifyCode, String password,
      {Function(dynamic)? onError}) async {
    return await helper.post('/signup',
        data: {
          "name": username,
          "contact": contact,
          "contact_type": contactTypes[contactType],
          "verify_code": verifyCode,
          "password": password,
        },
        showError: onError);
  }

  @override
  Future<AccountType> verifyAccount(String account) async {
    var res = await helper.get("/accounts/$account");
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
}
