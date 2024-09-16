
import 'package:freezed_annotation/freezed_annotation.dart';
part 'postal_code.g.dart';
@JsonSerializable()
class PostalCode {
  int id ;
  String title;
  String postcode;
  String charge;

  Currency currency;

  @JsonKey(name: 'free_delivery')
  FreeDelivery? freeDelivery;

  PostalCode(this.id, this.title, this.postcode, this.charge, this.currency,
      this.freeDelivery);

  factory PostalCode.fromJson(Map<String, dynamic> json) =>
      _$PostalCodeFromJson(json);
}

@JsonSerializable()
class FreeDelivery {
  @JsonKey(name: 'is_enable')
  int isEnable;
  String title;
  num amount;

  FreeDelivery(this.isEnable, this.title, this.amount);

  factory FreeDelivery.fromJson(Map<String, dynamic> json) =>
      _$FreeDeliveryFromJson(json);
}

@JsonSerializable()
class Currency {
  String symbol;
  String position;

  Currency(this.symbol, this.position);

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

}