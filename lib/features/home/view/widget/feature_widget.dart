import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/features/home/model/feature_item.dart';
import 'package:grocerymart/util/entensions.dart';

class FeatureWidget extends StatelessWidget {
  final FeatureItem item;
  const FeatureWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration:  BoxDecoration(
          color: AppStaticColor.accentColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: SizedBox(
                height: 78.h,
                width: 78.w,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: item.image ?? 'https://alsultanbakkerij.nl/assets/front/img/product/featured/1721036529.jpg',
                  placeholder: (context, url) => const Icon(Icons.image),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            8.ph,
            Text(
              item.title ?? '',
              overflow: TextOverflow.ellipsis,
              style:
              textStyle.bodyTextSmall.copyWith(fontWeight: FontWeight.w500,color: AppStaticColor.blackColor),
            )
          ],),
        ),
      ),
    );
  }
}
