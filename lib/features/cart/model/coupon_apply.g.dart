// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_apply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponCode _$CouponCodeFromJson(Map<String, dynamic> json) => CouponCode(
      id: (json['id'] as num).toInt(),
      value: json['value'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$CouponCodeToJson(CouponCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'type': instance.type,
    };
