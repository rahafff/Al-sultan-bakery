// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_mode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfflineMode _$OfflineModeFromJson(Map<String, dynamic> json) => OfflineMode(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['is_receipt'] as num).toInt(),
    );

Map<String, dynamic> _$OfflineModeToJson(OfflineMode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_receipt': instance.isReceipt,
    };
