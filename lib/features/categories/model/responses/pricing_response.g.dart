// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PricingResponse _$PricingResponseFromJson(Map<String, dynamic> json) =>
    PricingResponse(
      price: json['current'] as num?,
      oldPrice: json['previous'] as num?,
      currency: json['currency'] == null
          ? null
          : CurrencyResponse.fromJson(json['currency'] as Map<String, dynamic>),
      isPrevious: (json['is_previous'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PricingResponseToJson(PricingResponse instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'current': instance.price,
      'previous': instance.oldPrice,
      'is_previous': instance.isPrevious,
    };
