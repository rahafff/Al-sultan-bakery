import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/products/logic/product_repo.dart';
import 'package:grocerymart/features/products/model/product_details.dart';
import 'package:grocerymart/features/products/model/product_model.dart';

class ProductStateNotifier extends StateNotifier<bool> {
  final Ref ref;

  ProductStateNotifier(this.ref) : super(false);

  Future<ProductModel> getProducts({
      int? categoryId,
      int? subcategoryId,
      String? search,
    required int? count,
      int? maxPrice,
      int? minPrice,
      String? type,
  }) async {
    state = true;
    try {
      final products = await ref.read(productRepo).getProducts(
        maxPrice: maxPrice,
          categoryId: categoryId,
          search: search,
          count: count,
        type: type,
        minPrice: minPrice,
        subcategoryId: subcategoryId
          );
      state = false;
      return products;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      state = false;
      return ProductModel(productList: []);
    } finally {
      state = false;
    }
  }

  Future<ProductDetails?> getProductDetails({required int productId}) async {
    // state = true;
    try {
      final productDetails =
          await ref.read(productRepo).getProductDetails(productId: productId);
      state = false;
      return productDetails;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      state = false;
      return null;
    } finally {
      state = false;
    }
  }
}
