
class AddressRequest{
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String country;
  final String countryCode;
  final String state;
  final String city;
  final String address;

  AddressRequest({required this.firstName,required this.lastName, required this.phone,required this.email,required  this.country,required
  this.countryCode,
    required  this.state,required this.city,required this.address});


  Map<String, dynamic> toMapShipping() {
    return <String, dynamic>{
      'shpping_country_code': countryCode,
      'shpping_state': state,
      'shpping_country': country,
      'shpping_city': city,
      'shpping_address': address,

      'shpping_number': phone,

      'shpping_fname': firstName,
      'shpping_lname': lastName,
      'shpping_email': email,
    };
  }
  Map<String, dynamic> toMapBilling() {
    return <String, dynamic>{
      'billing_country_code': countryCode,
      'billing_state': state,
      'billing_country': country,
      'billing_city': city,
      'billing_address': address,

      'billing_number': phone,

      'billing_fname': firstName,
      'billing_lname': lastName,
      'billing_email': email,
    };
  }

}