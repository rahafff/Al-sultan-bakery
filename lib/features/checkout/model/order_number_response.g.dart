// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_number_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderNumberResponse _$OrderNumberResponseFromJson(Map<String, dynamic> json) =>
    OrderNumberResponse(
      json['order_number'] as String,
      json['total'] as num,
    );

Map<String, dynamic> _$OrderNumberResponseToJson(
        OrderNumberResponse instance) =>
    <String, dynamic>{
      'order_number': instance.orderNumber,
      'total': instance.total,
    };
