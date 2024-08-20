
import 'package:freezed_annotation/freezed_annotation.dart';
part 'online_mode.g.dart';
@JsonSerializable()
class OnlineMode{
  int id;
  int status;

  @JsonKey(name: 'type')
  String name;
  OnlineMode(this.id, this.status ,this.name);

  factory OnlineMode.fromJson(Map<String, dynamic> json) =>
      _$OnlineModeFromJson(json);
}