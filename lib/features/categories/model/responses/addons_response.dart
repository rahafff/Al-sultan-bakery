import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/currency_response.dart';
part 'addons_response.g.dart';

@JsonSerializable()
class AddonsResponse{
  final String name;
  final num price;
  final CurrencyResponse currency;

  AddonsResponse(this.name, this.price, this.currency);


  factory AddonsResponse.fromJson(Map<String, dynamic> json) =>
      _$AddonsResponseFromJson(json);
}