// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pages_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagesModel _$PagesModelFromJson(Map<String, dynamic> json) => PagesModel(
      (json['id'] as num?)?.toInt(),
      json['title'] as String?,
      json['subtitle'] as String?,
      json['body'] as String?,
    );

Map<String, dynamic> _$PagesModelToJson(PagesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'body': instance.body,
    };
