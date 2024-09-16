import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/features/cart/model/coupon_apply.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/features/cart/model/postal_code.dart';
import 'package:grocerymart/utils/api_client.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartRepo {
  final Ref ref;
  CartRepo(this.ref);

  void incrementProductQuantity(
      {required HiveCartModel cartItem,
      required Box<HiveCartModel> box,
      required int index}) {

    cartItem.productsQTY++;
    box.putAt(index, cartItem);
    }

  void decrementProductQuantity(
      {required HiveCartModel cartItem,
      required Box<HiveCartModel> cartBox,
      required int index}) {
    if (cartItem.productsQTY > 1) {
      cartItem.productsQTY--;
      cartBox.putAt(index, cartItem);
    } else {
      cartBox.deleteAt(index);
    }
    }

  // HiveCartModel? getCartItemById(
  //     {required int productId, required Box<HiveCartModel> cartBox}) {
  //   final HiveCartModel cartItem = cartBox.values.firstWhere((product) {
  //     return product.id == productId;
  //   });
  //
  //   return cartItem;
  // }

  Future<CouponCode?> applyCouponCode({
    required String couponCode,
    required double amount,
  }) async {
    final response = await ref.read(apiClientProvider).post(
      AppConstant.applyCouponCode,
      data: {
        "coupon": couponCode,
        "total": amount,
      },
    );
    if (response.statusCode == 200) {
      print('200000');
      final Map<String, dynamic> data = response.data['data'];
      final CouponCode couponCodeResponse = CouponCode.fromJson(data);
      print('done');
      return couponCodeResponse;
    }
    return null;
  }


  Future<List<PostalCode>> getPostalCode() async {
    final response =
    await ref.read(apiClientProvider).get(AppConstant.getPostalCode);
    List<dynamic> postal = response.data['data'];
    print(postal);
     final List<PostalCode> postalList =
    postal.map((order) => PostalCode.fromJson(order)).toList();

    return postalList;
  }
}

final cartRepo = Provider((ref) => CartRepo(ref));
