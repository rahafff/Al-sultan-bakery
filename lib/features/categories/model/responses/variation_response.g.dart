// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VariationResponse _$VariationResponseFromJson(Map<String, dynamic> json) =>
    VariationResponse(
      json['name'] as String,
      (json['items'] as List<dynamic>)
          .map(
              (e) => VariationItemsResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VariationResponseToJson(VariationResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'items': instance.items,
    };
