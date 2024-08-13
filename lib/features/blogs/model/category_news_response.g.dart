// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_news_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsCategoryResponse _$NewsCategoryResponseFromJson(
        Map<String, dynamic> json) =>
    NewsCategoryResponse(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$NewsCategoryResponseToJson(
        NewsCategoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
