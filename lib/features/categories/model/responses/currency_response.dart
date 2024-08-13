
import 'package:freezed_annotation/freezed_annotation.dart';
part 'currency_response.g.dart';

@JsonSerializable()
class CurrencyResponse{
  final String symbol;
  final String position;

  CurrencyResponse(this.symbol, this.position);

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrencyResponseFromJson(json);
}