// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_billing_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingBillingResponse _$ShippingBillingResponseFromJson(
        Map<String, dynamic> json) =>
    ShippingBillingResponse(
      fName: json['fname'] as String?,
      lName: json['lname'] as String?,
      email: json['email'] as String?,
      number: json['number'] as String?,
      countryCode: json['country_code'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      address: json['address'] as String?,
      country: json['country'] as String?,
      isShipping: json['isShipping'] as bool?,
    );

Map<String, dynamic> _$ShippingBillingResponseToJson(
        ShippingBillingResponse instance) =>
    <String, dynamic>{
      'fname': instance.fName,
      'lname': instance.lName,
      'email': instance.email,
      'number': instance.number,
      'country_code': instance.countryCode,
      'city': instance.city,
      'state': instance.state,
      'address': instance.address,
      'country': instance.country,
      'isShipping': instance.isShipping,
    };
