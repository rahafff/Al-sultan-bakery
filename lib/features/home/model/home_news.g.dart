// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeNews _$HomeNewsFromJson(Map<String, dynamic> json) => HomeNews(
      json['title'] as String,
      (json['blogs'] as List<dynamic>)
          .map((e) => BlogResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeNewsToJson(HomeNews instance) => <String, dynamic>{
      'title': instance.title,
      'blogs': instance.blogs,
    };
