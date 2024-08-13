import 'dart:convert';

class User {
  // final int id;
  final String username;
  final String email;
  final String number;
  final String photo;
  final String city;
  final String state;
  final String address;
  final String country;
  User({
    required this.username,
    required this.email,
    required this.number,
    required this.photo,
    required this.city,
    required this.address,
    required this.state,
    required this.country
  });


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] ??'',
      email: map['email'] ?? '',
      number: map['number'] ??'',
      photo: map['photo'] ?? '',
      address: map['address'] ?? '',
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ??'',
    );
  }


  Map<String, String> toMap() {
    return <String, String>{
      'username': username,
      'email': email,
      'phone': number,
      'photo': photo,
      'city': city,
      'country': country,
      'state': state,
      'address': address,
    };
  }
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

}
