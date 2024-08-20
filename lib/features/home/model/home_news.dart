import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
part 'home_news.g.dart';

@JsonSerializable()
class HomeNews{
  String title;
  List<BlogResponse> blogs;

  HomeNews(this.title, this.blogs);

  factory HomeNews.fromJson(Map<String, dynamic> json) =>
      _$HomeNewsFromJson(json);
}