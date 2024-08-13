// import 'dart:convert';
//
// class Product {
//   final int? id;
//   final String? title;
//   final String? summary;
//   final String? image;
//   final Pricing? pricing;
//
//   Product({
//     required this.id,
//     required this.title,
//     this.summary,
//     required this.image,
//     this.pricing,
//   });
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'title': title,
//       'summary': summary,
//       'image': image,
//     };
//   }
//
//   factory Product.fromMap(Map<String, dynamic> map) {
//     return Product(
//       id: map['id'] as int,
//       title: map['title'] as String?,
//       summary: map['description'] as String?,
//       image: map['feature_image'] as String?,
//       pricing: Pricing.fromMap(map['pricing']),
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory Product.fromJson(String source) =>
//       Product.fromMap(json.decode(source) as Map<String, dynamic>);
// }
//
// class Pricing {
//   final num? price;
//   final num? oldPrice;
//
//   Pricing({
//     this.price,
//     this.oldPrice,
//   });
//
//   factory Pricing.fromMap(Map<String, dynamic> map) {
//     return Pricing(
//       price: map['current'],
//       oldPrice: map['previous'],
//     );
//   }
//
//   factory Pricing.fromJson(String source) =>
//       Pricing.fromMap(json.decode(source) as Map<String, dynamic>);
// }
