// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postal_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostalCode _$PostalCodeFromJson(Map<String, dynamic> json) => PostalCode(
      (json['id'] as num).toInt(),
      json['title'] as String,
      json['postcode'] as String,
      json['charge'] as String,
      Currency.fromJson(json['currency'] as Map<String, dynamic>),
      json['free_delivery'] == null
          ? null
          : FreeDelivery.fromJson(
              json['free_delivery'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostalCodeToJson(PostalCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'postcode': instance.postcode,
      'charge': instance.charge,
      'currency': instance.currency,
      'free_delivery': instance.freeDelivery,
    };

FreeDelivery _$FreeDeliveryFromJson(Map<String, dynamic> json) => FreeDelivery(
      (json['is_enable'] as num).toInt(),
      json['title'] as String,
      json['amount'] as num,
    );

Map<String, dynamic> _$FreeDeliveryToJson(FreeDelivery instance) =>
    <String, dynamic>{
      'is_enable': instance.isEnable,
      'title': instance.title,
      'amount': instance.amount,
    };

Currency _$CurrencyFromJson(Map<String, dynamic> json) => Currency(
      json['symbol'] as String,
      json['position'] as String,
    );

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'symbol': instance.symbol,
      'position': instance.position,
    };
