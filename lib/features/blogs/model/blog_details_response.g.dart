// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlogDetailsResponse _$BlogDetailsResponseFromJson(Map<String, dynamic> json) =>
    BlogDetailsResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      date: json['date'] as String,
      image: json['image'] as String,
      newsCategory: NewsCategoryResponse.fromJson(
          json['category'] as Map<String, dynamic>),
      content: json['content'] as String,
    );

Map<String, dynamic> _$BlogDetailsResponseToJson(
        BlogDetailsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'image': instance.image,
      'content': instance.content,
      'category': instance.newsCategory,
    };
