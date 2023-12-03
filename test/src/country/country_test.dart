// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter_test/flutter_test.dart';
import 'package:mockingbird_messaging/mockingbird_messaging.dart';

main() {
  group("test country fetch", () {
    test("aes decrypt with client", () async {
      DioHelper helper = DioHelper(domain: "http://127.0.0.1:9000");
      var fetcher = HttpCountryFetcher(helper);
      var res = await fetcher.fetchCountries();
      print(res);
    });
  });
}
