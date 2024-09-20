
import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_number_response.g.dart';

@JsonSerializable()
class OrderNumberResponse {

  @JsonKey(name: 'order_number')
  String orderNumber;

  num total;

  OrderNumberResponse(this.orderNumber, this.total);

  factory OrderNumberResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderNumberResponseFromJson(json);
}