import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SignUpCredential {

  String? email;
  String? userName;

  String password;
  String confirmPassword;
  SignUpCredential({
    required this.userName,
    this.email,
    required this.password,
    required this.confirmPassword,
  });


  SignUpCredential copyWith({

    String? userName,
    String? email,

    String? password,
    String? confirmPassword,
  }) {
    return SignUpCredential(

      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': userName,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
    };
  }

  // factory SignUpCredential.fromMap(Map<String, dynamic> map) {
  //   return SignUpCredential(
  //     firstName: map['first_name'] as String,
  //     lastName: map['last_name'] as String,
  //     email: map['email'] != null ? map['email'] as String : null,
  //     phoneNumber: map['phone'] as String,
  //     password: map['password'] as String,
  //     confirmPassword: map['password_confirmation'] as String,
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory SignUpCredential.fromJson(String source) => SignUpCredential.fromMap(json.decode(source) as Map<String, dynamic>);



  @override
  bool operator ==(covariant SignUpCredential other) {
    if (identical(this, other)) return true;
  
    return 

      other.userName == userName &&
      other.email == email &&

      other.password == password &&
      other.confirmPassword == confirmPassword;
  }

  // @override
  // int get hashCode {
  //   return firstName.hashCode ^
  //     lastName.hashCode ^
  //     email.hashCode ^
  //     phoneNumber.hashCode ^
  //     password.hashCode ^
  //     confirmPassword.hashCode;
  // }
}
