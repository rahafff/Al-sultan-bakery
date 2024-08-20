import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/features/home/model/client_comments.dart';

class TestimonialWidget extends StatelessWidget {
  final ClientComments clientComments;
  const TestimonialWidget({super.key, required this.clientComments});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.w,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(39.r),
                  child: SizedBox(
                    height: 50.h,
                    width: 50.w,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: clientComments.image ?? 'https://alsultanbakkerij.nl/assets/front/img/product/featured/1721036529.jpg',
                      placeholder: (context, url) => const Icon(Icons.image),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(clientComments.name),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          clientComments.rating.toInt(),
                              (index) => const Icon(
                            Icons.star,
                            size: 16,
                            color: Color(0xFFf4b30c),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],),
              10.verticalSpace,
              Text(clientComments.comment),

            ],
          ),
        ),
      ),
    );
  }
}
