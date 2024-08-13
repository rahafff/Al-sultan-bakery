// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogResponse _$BlogResponseFromJson(Map<String, dynamic> json) => BlogResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      date: json['date'] as String,
      image: json['image'] as String,
      newsCategory: NewsCategoryResponse.fromJson(
          json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BlogResponseToJson(BlogResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'image': instance.image,
      'category': instance.newsCategory,
    };
