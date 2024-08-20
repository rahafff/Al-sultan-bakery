
import 'package:freezed_annotation/freezed_annotation.dart';
part 'client_comments.g.dart';

@JsonSerializable()
class ClientComments{
  String image;
  String name;
  num rating;
  String comment;

  ClientComments(this.image, this.name, this.rating, this.comment);


  factory ClientComments.fromJson(Map<String, dynamic> json) =>
      _$ClientCommentsFromJson(json);
}