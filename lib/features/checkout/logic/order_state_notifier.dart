import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/checkout/logic/order_repo.dart';
import 'package:grocerymart/features/checkout/model/checkout/checkout_home_delivery.dart';
import 'package:grocerymart/features/checkout/model/offline_mode.dart';
import 'package:grocerymart/features/checkout/model/online_mode.dart';
import 'package:grocerymart/features/checkout/model/place_order.dart';

class OrderStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  OrderStateNotifier(this.ref) : super(false);

  // Future<int?> placeOrder({required PlaceOrderModel orderData}) async {
  //   try {
  //     state = true;
  //     final int orderId =
  //         await ref.read(orderRepo).placeOrder(orderData: orderData);
  //     state = false;
  //     return orderId;
  //   } catch (e) {
  //     state = false;
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return null;
  //   } finally {
  //     state = false;
  //   }
  // }

  Future<OnlineMode> getOnlinePayment() async {
    try {
      // state = true;
      final OnlineMode orderId =
      await ref.read(orderRepo).getOnline();
      // state = false;
      return orderId;
    } catch (e) {
      // state = false;
      if (kDebugMode) {
        print(e);
      }
      return OnlineMode(-1,-1,'');
    } finally {
      // state = false;
    }
  }

  Future<List<OfflineMode>> getOfflinePayment() async {
    try {
      // state = true;
      final List<OfflineMode> orderId =
          await ref.read(orderRepo).getOffline();
      // state = false;
      return orderId;
    } catch (e) {
      // state = false;
      if (kDebugMode) {
        print(e);
      }
      return [];
    } finally {
      // state = false;
    }
  }


Future<bool> checkOutHomeOnline({required CheckoutHomeDeliveryModel orderData}) async {
  try {
    state = true;
    final bool orderId =
        await ref.read(orderRepo).checkOutHomeDeliveryOnline(orderData);
    state = false;
    return orderId;
  } catch (e) {
    state = false;
    if (kDebugMode) {
      print(e);
    }
    return false;
  } finally {
    state = false;
  }
}
Future<bool> checkOutHomeOffline({required CheckoutHomeDeliveryModel orderData}) async {
  try {
    state = true;
    final bool orderId =
        await ref.read(orderRepo).checkOutHomeDeliveryOffline(orderData);
    state = false;
    return orderId;
  } catch (e) {
    state = false;
    if (kDebugMode) {
      print(e);
    }
    return false;
  } finally {
    state = false;
  }
}



  Future<bool> checkOutPickUpOnline({required CheckoutPickUpModel orderData}) async {
    try {
      state = true;
      final bool orderId =
      await ref.read(orderRepo).checkOutPickUpOnline(orderData);
      state = false;
      return orderId;
    } catch (e) {
      state = false;
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      state = false;
    }
  }
  Future<bool> checkOutPickUpOffline({required CheckoutPickUpModel orderData}) async {
    try {
      state = true;
      final bool orderId =
      await ref.read(orderRepo).checkOutPickUpOffline(orderData);
      state = false;
      return orderId;
    } catch (e) {
      state = false;
      if (kDebugMode) {
        print(e);
      }
      return false;
    } finally {
      state = false;
    }
  }
}
