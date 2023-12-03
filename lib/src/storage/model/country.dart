// Copyright (c) 2023 Yang,Zhong
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:json_annotation/json_annotation.dart';
part 'country.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Country {
  final String name;
  final String cca2;
  final String cca3;
  final String fips;
  final String ioc;
  final String fifa;
  final String emoji;
  final int code;
  final int currency;
  final int capital;
  final List<int>? callingCode;
  final int domain;
  final int region;
  final List<String>? subdivisionCodes;

  const Country({
    required this.name,
    required this.cca2,
    required this.cca3,
    required this.fips,
    required this.ioc,
    required this.fifa,
    required this.emoji,
    required this.code,
    required this.currency,
    required this.capital,
    required this.domain,
    required this.region,
    this.subdivisionCodes,
    this.callingCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
