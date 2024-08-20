// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_special.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSpecial _$ProductSpecialFromJson(Map<String, dynamic> json) =>
    ProductSpecial(
      json['title'] as String,
      json['image'] as String,
      (json['special_product'] as List<dynamic>)
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductSpecialToJson(ProductSpecial instance) =>
    <String, dynamic>{
      'title': instance.title,
      'image': instance.image,
      'special_product': instance.specialProduct,
    };
