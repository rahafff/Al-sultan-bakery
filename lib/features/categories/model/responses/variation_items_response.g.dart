// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VariationItemsResponse _$VariationItemsResponseFromJson(
        Map<String, dynamic> json) =>
    VariationItemsResponse(
      json['name'] as String,
      json['price'] as num,
      CurrencyResponse.fromJson(json['currency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VariationItemsResponseToJson(
        VariationItemsResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
    };
