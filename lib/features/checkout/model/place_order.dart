// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


// class PlaceOrderModel {
//
//
//   String paymentMethod;
//   List<Product> product;
//   String? note;
//   int deliveryCharge;
//   String? couponCode;
//   String paymentVia;
//   PlaceOrderModel({
//
//
//     required this.paymentMethod,
//     required this.product,
//     this.note,
//     required this.deliveryCharge,
//     this.couponCode,
//     required this.paymentVia,
//   });
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//
//
//       'payment_method': paymentMethod,
//       'product': product.map((x) => x.toMap()).toList(),
//       'note': note,
//       'delivery_charge': deliveryCharge,
//       'coupon': couponCode,
//       'payment_via': paymentVia,
//     };
//   }
//
//   factory PlaceOrderModel.fromMap(Map<String, dynamic> map) {
//     return PlaceOrderModel(
//
//
//       paymentMethod: map['paymentMethod'] as String,
//       product: List<Product>.from(
//         (map['product'] as List<int>).map<Product>(
//           (x) => Product.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//       note: map['note'] != null ? map['note'] as String : null,
//       deliveryCharge: map['deliveryCharge'] as int,
//       couponCode: map['coupon'] != null ? map['coupon'] as String : null,
//       paymentVia: map['payment_via'] as String,
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory PlaceOrderModel.fromJson(String source) =>
//       PlaceOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
// }


