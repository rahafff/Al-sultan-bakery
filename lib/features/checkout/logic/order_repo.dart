import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/features/checkout/model/checkout/checkout_home_delivery.dart';
import 'package:grocerymart/features/checkout/model/offline_mode.dart';
import 'package:grocerymart/features/checkout/model/online_mode.dart';
import 'package:grocerymart/features/checkout/model/order.dart';
import 'package:grocerymart/features/checkout/model/order_details.dart';
import 'package:grocerymart/features/checkout/model/order_number_response.dart';
import 'package:grocerymart/features/checkout/model/order_response.dart';
import 'package:grocerymart/features/checkout/model/place_order.dart';
import 'package:grocerymart/utils/api_client.dart';

class OrderRepo {
  final Ref ref;

  OrderRepo(this.ref);

  // Future<int> placeOrder({required PlaceOrderModel orderData}) async {
  //   final response = await ref.read(apiClientProvider).post(
  //         AppConstant.placeOrder,
  //         data: orderData.toMap(),
  //       );
  //   final int orderId = response.data['data']['order']['id'];
  //   return orderId;
  // }

  Future<List<OrderResponse>> getOrders() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstant.getOrders);
    final List<dynamic> ordersData = response.data['data'];
    final List<OrderResponse> orders =
        ordersData.map((order) => OrderResponse.fromJson(order)).toList();

    return orders;
  }

  Future<OnlineMode> getOnline() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstant.getPaymentOnLine);
    dynamic addressesData = response.data['data']['stripe'];
    OnlineMode userAddresses = OnlineMode.fromJson(addressesData);

    return userAddresses;
  }

  Future<List<OfflineMode>> getOffline() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstant.getPaymentOffline);
    List<dynamic> offlineData = response.data['data'];

    final List<OfflineMode> orders =
        offlineData.map((order) => OfflineMode.fromJson(order)).toList();

    return orders;
  }

  ///checkOut online / offline

  Future<OrderNumberResponse> checkOutHomeDeliveryOnline(
      CheckoutHomeDeliveryModel checkOut) async {
    final response = await ref
        .read(apiClientProvider)
        .post(AppConstant.checkOutOnline, data: checkOut.toMap());

    dynamic addressesData = response.data['data'];
    OrderNumberResponse orderNumber =
        OrderNumberResponse.fromJson(addressesData);
    return orderNumber;
  }

  Future<OrderNumberResponse> checkOutHomeDeliveryOffline(
      CheckoutHomeDeliveryModel checkOut) async {
    final response = await ref
        .read(apiClientProvider)
        .post(AppConstant.checkOutOffline, data: checkOut.toMap());
    dynamic addressesData = response.data['data'];
    OrderNumberResponse orderNumber =
        OrderNumberResponse.fromJson(addressesData);
    return orderNumber;
  }

  Future<OrderNumberResponse> checkOutPickUpOnline(
      CheckoutPickUpModel checkOut) async {
    final response = await ref
        .read(apiClientProvider)
        .post(AppConstant.checkOutOnline, data: checkOut.toMap());
    dynamic addressesData = response.data['data'];
    OrderNumberResponse orderNumber =
        OrderNumberResponse.fromJson(addressesData);
    return orderNumber;
  }

  Future<OrderNumberResponse> checkOutPickUpOffline(
      CheckoutPickUpModel checkOut) async {
    final response = await ref
        .read(apiClientProvider)
        .post(AppConstant.checkOutOffline, data: checkOut.toMap());
    dynamic addressesData = response.data['data'];
    OrderNumberResponse orderNumber =
        OrderNumberResponse.fromJson(addressesData);
    return orderNumber;
  }
}

final orderRepo = Provider((ref) => OrderRepo(ref));
