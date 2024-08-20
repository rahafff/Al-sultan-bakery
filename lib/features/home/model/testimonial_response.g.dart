// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'testimonial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestimonialResponse _$TestimonialResponseFromJson(Map<String, dynamic> json) =>
    TestimonialResponse(
      json['title'] as String?,
      (json['points'] as List<dynamic>)
          .map((e) => ClientComments.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TestimonialResponseToJson(
        TestimonialResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'points': instance.points,
    };
