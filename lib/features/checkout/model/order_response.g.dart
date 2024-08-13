// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      (json['id'] as num).toInt(),
      json['total'] as num,
      json['method'] as String,
      json['shipping_charge'] as num,
      json['payment_status'] as String,
      json['order_status'] as String,
      json['invoice_number'] as String,
      CurrencyResponse.fromJson(json['currency'] as Map<String, dynamic>),
      json['serving_method'] as String,
      ShippingBillingResponse.fromJson(json['billing'] as Map<String, dynamic>),
      ShippingBillingResponse.fromJson(
          json['shipping'] as Map<String, dynamic>),
      (json['items'] as List<dynamic>)
          .map((e) => OrderProductResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total': instance.total,
      'method': instance.method,
      'shipping_charge': instance.shippingCharge,
      'payment_status': instance.paymentStatus,
      'order_status': instance.orderStatus,
      'serving_method': instance.servingMethod,
      'invoice_number': instance.invoiceNumber,
      'currency': instance.currencyResponse,
      'billing': instance.billing,
      'shipping': instance.shipping,
      'items': instance.items,
    };
