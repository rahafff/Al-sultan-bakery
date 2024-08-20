// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineMode _$OnlineModeFromJson(Map<String, dynamic> json) => OnlineMode(
      (json['id'] as num).toInt(),
      (json['status'] as num).toInt(),
      json['type'] as String,
    );

Map<String, dynamic> _$OnlineModeToJson(OnlineMode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'type': instance.name,
    };
