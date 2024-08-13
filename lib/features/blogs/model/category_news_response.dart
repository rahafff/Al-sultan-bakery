
import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_news_response.g.dart';
@JsonSerializable()
class NewsCategoryResponse{
  int id;
  String name;

  NewsCategoryResponse(this.id, this.name);

  factory NewsCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsCategoryResponseFromJson(json);

}