// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_feature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeFeature _$HomeFeatureFromJson(Map<String, dynamic> json) => HomeFeature(
      json['title'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => FeatureItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeFeatureToJson(HomeFeature instance) =>
    <String, dynamic>{
      'title': instance.title,
      'items': instance.items,
    };
