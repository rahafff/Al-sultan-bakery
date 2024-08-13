import 'dart:convert';

class UpdateProfile {
  final String userName;

  final String phone;
  final String country;
  final String state;
  final String city;
  final String address;
  final String firstName;
  final String lastName;
  UpdateProfile({
    required this.userName,
    required this.phone,
    required this.country,
    required this.city,
    required this.state,
    required this.address,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phone': phone,
      'username': userName,
      'state': state,
      'country': country,
      'city': city,
      'address': address,
      'number': phone,
      'fname': firstName,
      'lname': lastName
    };
  }

  factory UpdateProfile.fromMap(Map<String, dynamic> map) {
    return UpdateProfile(
        userName: map['username'] as String,
        phone: map['phone'] as String,
        city: map['city'] as String,
        country: map['country'] as String,
        state: map['state'] as String,
        address: map['address'] as String,
        firstName: map['fname'] ?? '',
        lastName: map['lname'] ?? '');
  }

  String toJson() => json.encode(toMap());
}
