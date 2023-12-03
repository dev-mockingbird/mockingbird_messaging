// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:mockingbird_messaging/src/http_helper.dart';

import 'storage/model/country.dart';

abstract class CountryFetcher {
  Future<List<Country>> fetchCountries();
}

class HttpCountryFetcher extends CountryFetcher {
  final DioHelper helper;
  HttpCountryFetcher(this.helper);
  @override
  Future<List<Country>> fetchCountries() async {
    var res = await helper.get("/countries");
    List<Country> ret = [];
    for (var item in (res["data"] ?? [])) {
      ret.add(Country.fromJson(item));
    }
    return ret;
  }
}
