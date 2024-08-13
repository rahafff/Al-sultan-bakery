import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
part 'category_response.g.dart';
@JsonSerializable()
class CategoryResponse {
  final int id;

  final String? name;
  final String? icon;
  final List<SubCategoryResponse> subCategories;

  CategoryResponse(
      {required this.id, this.name, this.icon, required this.subCategories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}

@JsonSerializable()
class SubCategoryResponse {
  final int id;
  final String? name;
  final List<ProductResponse>? products;
  SubCategoryResponse({
    required this.id,
    this.name,
    this.products  ,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryResponseFromJson(json);
}

