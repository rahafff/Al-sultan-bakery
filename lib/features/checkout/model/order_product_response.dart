import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_product_response.g.dart';

@JsonSerializable()
class OrderProductResponse {
  int id;
  String title;

  @JsonKey(name: 'feature_image')
  String image;

  num qty;
  num total;

  @JsonKey(name: 'variations_price')
  num variationsPrice;
  @JsonKey(name: 'addons_price')
  num addonsPrice;
  @JsonKey(name: 'product_price')
  num productPrice;

  OrderProductResponse(this.id, this.title, this.image, this.qty, this.total,
      this.variationsPrice, this.addonsPrice, this.productPrice);

  factory OrderProductResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderProductResponseFromJson(json);
}
