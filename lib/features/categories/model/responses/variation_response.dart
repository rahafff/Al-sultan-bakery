import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/addons_response.dart';
import 'package:grocerymart/features/categories/model/responses/variation_items_response.dart';
part 'variation_response.g.dart';


@JsonSerializable()
class VariationResponse{

  final String name;
  final List<VariationItemsResponse> items;

  VariationResponse(this.name,this.items);

  factory VariationResponse.fromJson(Map<String, dynamic> json) =>
      _$VariationResponseFromJson(json);
}