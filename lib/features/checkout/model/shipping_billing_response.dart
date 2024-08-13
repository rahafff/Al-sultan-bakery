
import 'package:freezed_annotation/freezed_annotation.dart';
part 'shipping_billing_response.g.dart';
@JsonSerializable()
class ShippingBillingResponse {

  @JsonKey(name: 'fname')
  final String? fName;

  @JsonKey(name: 'lname')
  final String? lName;

  final String? email;
  final String? number;

  @JsonKey(name: 'country_code')
  final String? countryCode;

  final String? city;
  final String? state;
  final String? address;
  final String? country;
  bool? isShipping;

  ShippingBillingResponse({this.fName, this.lName, this.email, this.number,
      this.countryCode, this.city, this.state, this.address, this.country});

  factory ShippingBillingResponse.fromJson(Map<String, dynamic> json) =>
      _$ShippingBillingResponseFromJson(json);


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fName': fName,
      'lName': lName,
      'email': email,
      'number':number,
      'countryCode':countryCode,
      'city':city,
      'state':state,
      'address':address,
      'country':country,
    };
  }
}