class CheckoutHomeDeliveryModel {
  dynamic gateway;
  int gatewayId;
  List<Product> product;
  String? note;
  String? couponCode;

  ShippingAddress? shippingAddress;
  int sameAsShipping;
  ShippingAddress? billingAddress;

  int? cardNumber;
  int? month;
  int? year;
  int? cardCVC;

  String? zipCode;
  int postalCode;
  CheckoutHomeDeliveryModel(
      {this.gateway,

      required this.product,
      this.note,
      required this.gatewayId,
      this.couponCode,
      required this.postalCode,
      this.zipCode,
      required this.sameAsShipping,
      this.shippingAddress,
      this.billingAddress,
      this.cardNumber,
      this.cardCVC,
      this.month,
      this.year});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['gateway'] = gateway;
    data['gateway_id'] = gatewayId;
    data['serving_method'] = 'home_delivery';
    data['ordered_from'] = 'mobile';
    data['zip_code'] = zipCode;
    data['order_notes'] = note;
    data['coupon'] = couponCode;
    data['postal_code'] = postalCode;
    data['same_as_shipping'] = sameAsShipping;
    data['products'] = product
        .map(
          (e) => e.toMap(),
        )
        .toList();
    data['shipping'] = shippingAddress?.toMap();
    data['billing'] = billingAddress?.toMap();


    if (cardNumber != null) {
      data['cardNumber'] = cardNumber;
      data['month'] = month;
      data['year'] = year;
      data['cardCVC'] = cardCVC;
    }

    return data;
  }
}

class ShippingAddress {
  String fname;
  String lname;
  String address;
  String city;
  String country;
  String email;

  String countryCode;
  String number;

  ShippingAddress(
      {required this.fname,
      required this.lname,
      required this.address,
      required this.city,
      required this.country,
      required this.email,
      required this.countryCode,
      required this.number});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fname': fname,
      'lname': lname,
      'address': address,
      'city': city,
      'country': country,
      'email': email,
      'country_code': countryCode,
      'number': number,
      'charge': '1'
    };
  }
}

class Product {
  int productId;
  int productQTY;

  List<Addons> addons;
  Addons? variant;

  Product({
    required this.productId,
    required this.productQTY,
    required this.addons,
    this.variant,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': productId,
      'qty': productQTY,
      'addons': addons
          .map(
            (e) => e.toMap(),
          )
          .toList(),
      'variant': variant?.toMap()
    };
  }
}

class Addons {
  String name;
  Addons({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }
}

class CheckoutPickUpModel {
  dynamic gateway;
  int gatewayId;
  List<Product> product;
  String? note;
  String? couponCode;

  ShippingAddress? billingAddress;

  String date;
  String time;

  int? cardNumber;
  int? month;
  int? year;
  int? cardCVC;

  CheckoutPickUpModel(
      {required this.gateway,
      required this.product,
      this.note,
      required this.gatewayId,
      this.couponCode,
      required this.billingAddress,
      required this.date,
      required this.time,
      this.cardNumber,
      this.cardCVC,
      this.month,
      this.year});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    data['gateway'] = gateway;
    data['gateway_id'] = gatewayId;
    data['serving_method'] = 'pick_up';
    data['ordered_from'] = 'mobile';

    data['order_notes'] = note;
    data['coupon'] = couponCode;

    data['products'] = product
        .map(
          (e) => e.toMap(),
    )
        .toList();

    data['billing'] = billingAddress?.toMap();

    if (cardNumber != null) {
      data['cardNumber'] = cardNumber;
      data['month'] = month;
      data['year'] = year;
      data['cardCVC'] = cardCVC;
    }

    return data;
  }
}
