class CheckoutHomeDeliveryModel {
  String? gateway;
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
      {  this.gateway,
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
    return <String, dynamic>{
      'gateway': gateway,
      'gateway_id': gatewayId,
      'serving_method': 'home_delivery',
      'ordered_from': 'mobile',
      'zip_code': zipCode,
      'order_notes': note,
      'coupon': couponCode,
      'postal_code': postalCode,
      'same_as_shipping': sameAsShipping,

      'products': product
          .map(
            (e) => e.toMap(),
          )
          .toList(),

      'shipping': shippingAddress?.toMap(),
      'billing': billingAddress?.toMap(),

      ///for online

      "cardNumber": cardNumber,
      "month": month,
      "year": year,
      "cardCVC": cardCVC,
    };
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
      'email': 'email',
      'country_code': countryCode,
      'number': number,
      'charge':'1'
    };
  }
}
class Product {
  int productId;
  int productQTY;

  List<Addons> addons;
  Addons?  variant;


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
      'addons':addons.map((e) => e.toMap(),).toList(),
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
  String gateway;
  int gatewayId;
  List<Product> product;
  String? note;
  String? couponCode;

  String email;
  String name;

  String countryCode;
  String number;

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

        required this.name,
        required this.email,

        required this.countryCode,
        required this.number,

        required this.date,
        required this.time,

        this.cardNumber,
        this.cardCVC,
        this.month,
        this.year});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gateway': gateway,
      'gateway_id': gatewayId,
      'serving_method': 'pick_up',
      'ordered_from': 'mobile',
      'order_notes': note,
      'coupon': couponCode,
      'products': product
          .map(
            (e) => e.toMap(),
      )
          .toList(),

      'billing_fname': name,
      'billing_email': email,
      "billing_country_code":countryCode,
      "billing_number":number,
      "pick_up_date":date,
      "pick_up_time":time,



      ///for online

      "cardNumber": cardNumber,
      "month": month,
      "year": year,
      "cardCVC": cardCVC,
    };
  }
}