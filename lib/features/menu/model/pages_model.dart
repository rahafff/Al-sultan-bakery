import 'package:freezed_annotation/freezed_annotation.dart';
part 'pages_model.g.dart';
@JsonSerializable()
class PagesModel{
  int? id;
  String? title;
  String? subtitle;
  String? body;

  PagesModel(this.id,this.title, this.subtitle, this.body);

  factory PagesModel.fromJson(Map<String, dynamic> json) =>
      _$PagesModelFromJson(json);
}