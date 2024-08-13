import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/misc.dart';

class NewsCard extends StatelessWidget {
  final BlogResponse shop;
  final Color? cardColor;
  const NewsCard({
    Key? key,
    this.cardColor = AppStaticColor.accentColor,
    required this.shop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return GestureDetector(
      onTap: () {
        context.nav.pushNamed(
          Routes.blogsDetailsScreen,
          arguments: shop,
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: cardColor,
        ),
        child: Row(
          children: [
            Container(
              height: 72.h,
              width: 72.w,
              decoration: BoxDecoration(
                color: AppStaticColor.accentColor,
                border: Border.all(
                    color: AppStaticColor.grayColor.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  fit: BoxFit.cover,

                    image: CachedNetworkImageProvider(
                        shop.image,
                ))
              ),
              // child: CachedNetworkImage(
              //   fit: BoxFit.cover,
              //   imageUrl: shop.image,
              //   placeholder: (context, url) => const Icon(Icons.image),
              //   errorWidget: (context, url, error) =>
              //       const Icon(Icons.error),
              // ),
            ),
            16.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop.title,
                              style: textStyle.bodyTextSmall.copyWith(
                                color: AppStaticColor.blackColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            5.ph,
                            Text(
                              shop.newsCategory.name,
                              style: textStyle.bodyTextSmall.copyWith(
                                fontSize: 10.sp,
                                color: AppStaticColor.grayColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: AppStaticColor.grayColor,
                      )
                    ],
                  ),
                  12.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            color: Colors.amber,
                            size: 16.h,
                          ),
                          4.pw,
                          Text(
                            shop.date,
                            style: textStyle.bodyTextSmall.copyWith(
                              color: AppStaticColor.grayColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      AppCustomDivider(
                        height: 10.h,
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.amber,
                            size: 16.h,
                          ),
                          4.pw,
                          Text(
                            'Admin',
                            style: textStyle.bodyTextSmall.copyWith(
                              color: AppStaticColor.grayColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
