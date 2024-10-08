import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/addons_response.dart';
import 'package:grocerymart/features/categories/model/responses/pricing_response.dart';
import 'package:grocerymart/features/categories/model/responses/variation_response.dart';
part 'product_response.g.dart';

@JsonSerializable()
class ProductResponse {
  final int  id;
  final String? title;

  @JsonKey(name: 'feature_image')
  final String? image;

  final String? rating;

  final num? tax;

  final String? summary;

  final List<AddonsResponse> addons;

  final List<VariationResponse> variations;

  final PricingResponse pricing;

  ProductResponse(this.id, this.title, this.image, this.rating, this.summary,
      this.variations ,this.addons,this.pricing,this.tax);

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  num get priceWithTax =>  ( (((tax ?? 0.0) * (pricing.price    ?? 0) )/ 100 ) + (pricing.price    ?? 0) );
  num get oldPriceWithTax=>( (((tax ?? 0.0) * (pricing.oldPrice ?? 0) )/ 100 ) + (pricing.oldPrice ?? 0) );

  String get discountPercentage => (pricing.isPrevious == 1 && (pricing.oldPrice ?? 0) > 0 )? ((((oldPriceWithTax ?? 0) - (priceWithTax ?? 0)) * 100) / (oldPriceWithTax ?? 1) ).toStringAsFixed(0):'';
}
