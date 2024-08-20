
import 'package:freezed_annotation/freezed_annotation.dart';
part 'feature_item.g.dart';
@JsonSerializable()
class FeatureItem{
  String title;

  @JsonKey(name: 'img')
  String image;

  FeatureItem(this.title, this.image);

  factory FeatureItem.fromJson(Map<String, dynamic> json) =>
      _$FeatureItemFromJson(json);
}
