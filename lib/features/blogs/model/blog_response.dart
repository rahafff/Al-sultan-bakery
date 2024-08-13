import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/blogs/model/category_news_response.dart';
part 'blog_response.g.dart';

@JsonSerializable()
class BlogResponse {
  final int id;
  final String title;
  final String date;
  final String image;

  @JsonKey(name: 'category')
  final NewsCategoryResponse newsCategory;


  BlogResponse({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.newsCategory,
  });


  factory BlogResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogResponseFromJson(json);

}
