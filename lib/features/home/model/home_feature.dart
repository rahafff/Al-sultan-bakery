import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/features/home/model/feature_item.dart';
part 'home_feature.g.dart';

@JsonSerializable()
class HomeFeature{
  String title;
  List<FeatureItem> items;

  HomeFeature(this.title, this.items);

  factory HomeFeature.fromJson(Map<String, dynamic> json) =>
      _$HomeFeatureFromJson(json);
}