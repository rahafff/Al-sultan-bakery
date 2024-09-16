import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class HiveCartModel {
  int id;

  String name;
  String productImage;
  num price;
  num priceWithTax;
  num tax;
  // num oldPrice;
  int productsQTY;

  List<HiveAddonsItem> addons;
   HiveAddonsItem?  variant;

  HiveCartModel({
    required this.id,
    required this.name,
    required this.productImage,
    required this.price,
    // required this.oldPrice,
    required this.productsQTY,
      this.variant,
    required this.addons,
    required this.priceWithTax,
    required this.tax,
  });

  Map<String, dynamic> toMap() {

    return <String, dynamic>{
      'id': id,
      'name': name,
      'productImage': productImage,
      'price': price,
      'price_tax': priceWithTax,
      'tax':tax,
      'productsQTY': productsQTY,
      'addons': addons.map((e) => e.toMap(),).toList(),
      'variant':variant?.toMap()
    };
  }

  factory HiveCartModel.fromMap(Map<dynamic, dynamic> map) {
    print(map['addons'].map((product) => HiveAddonsItem.fromMap(product)));
    print('from');

    return HiveCartModel(
        id: map['id'] as int,
        name: map['name'] as String,
        productImage: map['productImage'] as String,
        price: map['price'] as double,
        priceWithTax: map['price_tax'] as double,
        tax: map['tax'] ,
        productsQTY: map['productsQTY'] as int,
        addons:  map['addons'].map<HiveAddonsItem>((x) => HiveAddonsItem.fromMap(x)).toList() ,
      variant:map['variant'] != null ?  HiveAddonsItem.fromMap( map['variant']) : null,
     );
  }

  String toJson() => json.encode(toMap());

  factory HiveCartModel.fromJson(String source) =>
      HiveCartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class HiveCartModelAdapter extends TypeAdapter<HiveCartModel> {
  @override
  final typeId = 0;

  @override
  HiveCartModel read(BinaryReader reader) {
    return HiveCartModel.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, HiveCartModel obj) {
    writer.writeMap(obj.toMap());
  }
}


class HiveAddonsItemAdapter extends TypeAdapter<HiveAddonsItem> {
  @override
  final typeId = 1;

  @override
  HiveAddonsItem read(BinaryReader reader) {
    return HiveAddonsItem.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, HiveAddonsItem obj) {
    writer.writeMap(obj.toMap());
  }
}

class HiveAddonsItem {
  String name;
  num price;
  num priceWithTax;

  HiveAddonsItem({required this.name, required this.price , required this.priceWithTax});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'price_tax': priceWithTax,
    };
  }

  factory HiveAddonsItem.fromMap(Map<dynamic, dynamic> map) {
    return HiveAddonsItem(
      name: map['name'] as String,
      price: map['price'],
      priceWithTax: map['price_tax'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HiveAddonsItem.fromJson(String source) =>
      HiveAddonsItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
