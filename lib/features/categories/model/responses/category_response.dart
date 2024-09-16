import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
part 'category_response.g.dart';
@JsonSerializable()
class CategoryResponse {
  final int id;

  final String? name;
  final String? image;
  final List<SubCategoryResponse> subCategories;

  CategoryResponse(
      {required this.id, this.name, this.image, required this.subCategories});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}

@JsonSerializable()
class SubCategoryResponse {
  final int id;
  final String? name;
  final String? image;
  final List<ProductResponse>? products;
  SubCategoryResponse({
    required this.id,
    this.name,
    this.products  ,
    this.image  ,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryResponseFromJson(json);
}

