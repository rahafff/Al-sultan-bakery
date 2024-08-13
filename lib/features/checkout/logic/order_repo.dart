import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/features/checkout/model/order.dart';
import 'package:grocerymart/features/checkout/model/order_details.dart';
import 'package:grocerymart/features/checkout/model/order_response.dart';
import 'package:grocerymart/features/checkout/model/place_order.dart';
import 'package:grocerymart/utils/api_client.dart';

class OrderRepo {
  final Ref ref;

  OrderRepo(this.ref);

  Future<int> placeOrder({required PlaceOrderModel orderData}) async {
    final response = await ref.read(apiClientProvider).post(
          AppConstant.placeOrder,
          data: orderData.toMap(),
        );
    final int orderId = response.data['data']['order']['id'];
    return orderId;
  }

  Future<List<OrderResponse>> getOrders() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstant.getOrders);
    final List<dynamic> ordersData = response.data['data'];
    print(ordersData.isNotEmpty);
    final List<OrderResponse> orders =
        ordersData.map((order) => OrderResponse.fromJson(order)).toList();
    print(orders.first.shipping.countryCode);
    return orders;
  }

  // Future<OrderDetails> getOrderDetails({required int orderId}) async {
  //   final response = await ref
  //       .read(apiClientProvider)
  //       .get("${AppConstant.getOrderDetails}/$orderId");
  //
  //   final OrderDetails orderDetails =
  //       OrderDetails.fromMap(response.data['data']);
  //   return orderDetails;
  // }
  //
  // Future<String> cancelOrder({required int orderId}) async {
  //   final response = await ref
  //       .read(apiClientProvider)
  //       .post("${AppConstant.orderCancel}/$orderId");
  //
  //   final String messages = response.data['message'];
  //   return messages;
  // }
}

final orderRepo = Provider((ref) => OrderRepo(ref));
