// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      image: json['image'] as String?,
      subCategories: (json['subCategories'] as List<dynamic>)
          .map((e) => SubCategoryResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'subCategories': instance.subCategories,
    };

SubCategoryResponse _$SubCategoryResponseFromJson(Map<String, dynamic> json) =>
    SubCategoryResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubCategoryResponseToJson(
        SubCategoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'products': instance.products,
    };
