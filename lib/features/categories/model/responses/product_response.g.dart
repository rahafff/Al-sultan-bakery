// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      (json['id'] as num).toInt(),
      json['title'] as String?,
      json['feature_image'] as String?,
      json['rating'] as String?,
      json['summary'] as String?,
      (json['variations'] as List<dynamic>)
          .map((e) => VariationResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['addons'] as List<dynamic>)
          .map((e) => AddonsResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      PricingResponse.fromJson(json['pricing'] as Map<String, dynamic>),
      json['tax'] as num?,
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'feature_image': instance.image,
      'rating': instance.rating,
      'tax': instance.tax,
      'summary': instance.summary,
      'addons': instance.addons,
      'variations': instance.variations,
      'pricing': instance.pricing,
    };
