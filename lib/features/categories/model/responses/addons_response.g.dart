// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addons_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddonsResponse _$AddonsResponseFromJson(Map<String, dynamic> json) =>
    AddonsResponse(
      json['name'] as String,
      json['price'] as num,
      CurrencyResponse.fromJson(json['currency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AddonsResponseToJson(AddonsResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
    };
