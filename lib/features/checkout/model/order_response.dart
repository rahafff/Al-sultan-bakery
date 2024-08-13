

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/categories/model/responses/currency_response.dart';
import 'package:grocerymart/features/checkout/model/order_product_response.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
part 'order_response.g.dart';
@JsonSerializable()
class OrderResponse {
  int id;
  num total;
  String method;

  @JsonKey(name: 'shipping_charge')
  num shippingCharge;



  @JsonKey(name: 'payment_status')
  String paymentStatus;

  @JsonKey(name: 'order_status')
  String orderStatus;


  @JsonKey(name: 'serving_method')
  String servingMethod;

  @JsonKey(name: 'invoice_number')
  String invoiceNumber;

  @JsonKey(name: 'currency')
  CurrencyResponse currencyResponse;

  ShippingBillingResponse billing;

  ShippingBillingResponse shipping;

  List<OrderProductResponse> items;



  OrderResponse(this.id, this.total, this.method, this.shippingCharge,
      this.paymentStatus, this.orderStatus, this.invoiceNumber,this.currencyResponse,
      this.servingMethod,this.billing,this.shipping,this.items);


  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}