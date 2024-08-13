
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/currency_response.dart';
part 'variation_items_response.g.dart';
@JsonSerializable()
class VariationItemsResponse{
  final String name;
  final num price;
  final CurrencyResponse currency;

  VariationItemsResponse(this.name, this.price,this.currency);


  factory VariationItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$VariationItemsResponseFromJson(json);
}