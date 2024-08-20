
import 'package:freezed_annotation/freezed_annotation.dart';
part 'offline_mode.g.dart';
@JsonSerializable()
class OfflineMode{
  int id;
  String name;

  @JsonKey(name: 'is_receipt')
  int isReceipt;

  OfflineMode(this.id, this.name, this.isReceipt);


  factory OfflineMode.fromJson(Map<String, dynamic> json) =>
      _$OfflineModeFromJson(json);
}