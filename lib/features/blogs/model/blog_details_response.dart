import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/blogs/model/category_news_response.dart';
part 'blog_details_response.g.dart';

@JsonSerializable()
class BlogDetailsResponse {
  final int id;
  final String title;
  final String date;
  final String image;
  final String content;

  @JsonKey(name: 'category')
  final NewsCategoryResponse newsCategory;


  BlogDetailsResponse({
    required this.id,
    required this.title,
    required this.date,
    required this.image,
    required this.newsCategory,
    required this.content,
  });


  factory BlogDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogDetailsResponseFromJson(json);

}
