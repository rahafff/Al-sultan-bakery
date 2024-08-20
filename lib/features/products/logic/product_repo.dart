import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/config/parameter_constants.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/model/product_special.dart';
import 'package:grocerymart/features/products/model/product_details.dart';
import 'package:grocerymart/features/products/model/product_model.dart';
import 'package:grocerymart/utils/api_client.dart';

class ProductRepo {
  final Ref ref;

  ProductRepo(this.ref);

  Future<ProductModel> getProducts({
    required int? categoryId,
    required int? subcategoryId,
    required String? search,
    required String? type,
    required num? minPrice,
    required num? maxPrice,
    required int? count,
  }) async {
    Map<String, String> queryParams = {};

    if (search != null) queryParams['search'] = search;
    if (type != null) queryParams['type'] = type;

    if (minPrice != null) queryParams['minprice'] = minPrice.toString();
    if (maxPrice != null) queryParams['maxprice'] = maxPrice.toString();

    if (count != null) queryParams['page'] = count.toString();
    queryParams['limit'] = ParameterConstants.itemsLimit;

    final response = await ref
        .read(apiClientProvider)
        .get(AppConstant.getProducts, query: queryParams);

    final List<dynamic> productsData = response.data['data'];

    final List<ProductResponse> products = productsData
        .map(
          (product) => ProductResponse.fromJson(product),
        )
        .toList();

    print(products.length);
    print('--------------------------');
    return ProductModel(productList: products);
  }

  // Future<ProductDetails> getProductDetails({required int productId}) async {
  //   final response = await ref
  //       .read(apiClientProvider)
  //       .get("${AppConstant.getProductDetails}/$productId");
  //   final productDetails = ProductDetails.fromMap(response.data['data']);
  //   return productDetails;
  // }
}

final productRepo = Provider((ref) => ProductRepo(ref));
