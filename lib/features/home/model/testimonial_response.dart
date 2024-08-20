import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grocerymart/features/home/model/client_comments.dart';
part 'testimonial_response.g.dart';


@JsonSerializable()
class TestimonialResponse {
  String? title;

  List<ClientComments> points;

  TestimonialResponse(this.title, this.points);

  factory TestimonialResponse.fromJson(Map<String, dynamic> json) =>
      _$TestimonialResponseFromJson(json);
}
