import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_apply.g.dart';
@JsonSerializable()
class CouponCode {
  final int id;
  final String value;
  final String type;

  CouponCode({
    required this.id,
    required this.value,
    required this.type,
  });



  factory CouponCode.fromJson(Map<String, dynamic> json) =>
      _$CouponCodeFromJson(json);
}

