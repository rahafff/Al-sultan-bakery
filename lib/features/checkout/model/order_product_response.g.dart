// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProductResponse _$OrderProductResponseFromJson(
        Map<String, dynamic> json) =>
    OrderProductResponse(
      (json['id'] as num).toInt(),
      json['title'] as String,
      json['feature_image'] as String,
      json['qty'] as num,
      json['total'] as num,
      json['variations_price'] as num,
      json['addons_price'] as num,
      json['product_price'] as num,
    );

Map<String, dynamic> _$OrderProductResponseToJson(
        OrderProductResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'feature_image': instance.image,
      'qty': instance.qty,
      'total': instance.total,
      'variations_price': instance.variationsPrice,
      'addons_price': instance.addonsPrice,
      'product_price': instance.productPrice,
    };
