import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/addons_response.dart';
import 'package:grocerymart/features/categories/model/responses/pricing_response.dart';
import 'package:grocerymart/features/categories/model/responses/variation_response.dart';
part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse {
  final int? id;
  final String? title;

  @JsonKey(name: 'feature_image')
  final String? image;

  final String? rating;

  final String? summary;

  final List<AddonsResponse> addons;

  final List<VariationResponse> variations;

  final PricingResponse pricing;

  ProductResponse(this.id, this.title, this.image, this.rating, this.summary,
      this.variations ,this.addons,this.pricing);

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
}
