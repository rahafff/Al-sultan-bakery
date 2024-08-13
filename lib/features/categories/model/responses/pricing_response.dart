import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/currency_response.dart';
part 'pricing_response.g.dart';
@JsonSerializable()
class PricingResponse {
  final CurrencyResponse? currency;
  @JsonKey(name: 'current')
  final num? price;

  @JsonKey(name: 'previous')
  final num? oldPrice;

  @JsonKey(name: 'is_previous')
  final  int? isPrevious;

  PricingResponse({this.price, this.oldPrice, this.currency, this.isPrevious});

  factory PricingResponse.fromJson(Map<String, dynamic> json) =>
      _$PricingResponseFromJson(json);
}
