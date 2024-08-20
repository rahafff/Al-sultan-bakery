// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientComments _$ClientCommentsFromJson(Map<String, dynamic> json) =>
    ClientComments(
      json['image'] as String,
      json['name'] as String,
      json['rating'] as num,
      json['comment'] as String,
    );

Map<String, dynamic> _$ClientCommentsToJson(ClientComments instance) =>
    <String, dynamic>{
      'image': instance.image,
      'name': instance.name,
      'rating': instance.rating,
      'comment': instance.comment,
    };
