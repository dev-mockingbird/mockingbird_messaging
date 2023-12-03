// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      name: json['name'] as String,
      cca2: json['cca2'] as String,
      cca3: json['cca3'] as String,
      fips: json['fips'] as String,
      ioc: json['ioc'] as String,
      fifa: json['fifa'] as String,
      emoji: json['emoji'] as String,
      code: json['code'] as int,
      currency: json['currency'] as int,
      capital: json['capital'] as int,
      domain: json['domain'] as int,
      region: json['region'] as int,
      subdivisionCodes: (json['subdivision_codes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      callingCode: (json['calling_code'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'name': instance.name,
      'cca2': instance.cca2,
      'cca3': instance.cca3,
      'fips': instance.fips,
      'ioc': instance.ioc,
      'fifa': instance.fifa,
      'emoji': instance.emoji,
      'code': instance.code,
      'currency': instance.currency,
      'capital': instance.capital,
      'calling_code': instance.callingCode,
      'domain': instance.domain,
      'region': instance.region,
      'subdivision_codes': instance.subdivisionCodes,
    };
