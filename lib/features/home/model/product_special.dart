import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_special.g.dart';

@JsonSerializable()
class ProductSpecial{
  final String title;
  final String image;

  @JsonKey(name: 'special_product')
  final List<ProductResponse> specialProduct;

  ProductSpecial(this.title, this.image, this.specialProduct);


  factory ProductSpecial.fromJson(Map<String, dynamic> json) =>
      _$ProductSpecialFromJson(json);
}