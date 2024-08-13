// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/blogs/model/blog_models.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/buttons/top_nav_bar_icon_button.dart';
import 'package:grocerymart/widgets/misc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewsDetailsHeader extends StatelessWidget {
  final BlogDetailsModel shopDetails;
  const NewsDetailsHeader({
    Key? key,
    required this.shopDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200.h,
                  width: 390.w,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: shopDetails.image,
                    placeholder: (context, url) => const Icon(Icons.image),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Container(
                  height: 200.h,
                  width: 390.w,
                  color: AppStaticColor.blackColor.withOpacity(0.4),
                ),


                ///back button & basket
                ValueListenableBuilder<Box<HiveCartModel>>(
                  valueListenable:
                      Hive.box<HiveCartModel>(AppHSC.cartBox).listenable(),
                  builder: (context, cartBox, _) {
                    final cartItems = cartBox.values.toList();
                    return Positioned(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  radius: 25.r,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: IconButton(
                                    onPressed: () {
                                      context.nav.pop();
                                    },
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: colors(context).bodyTextColor,
                                    ),
                                  ),
                                ),
                                TopNavBarIconButton(
                                  svgPath: Assets.svg.iconBasketColored,
                                  onTap: () {
                                    context.nav.pushNamed(Routes.cartScreen);
                                  },
                                ),
                              ],
                            ),
                            cartItems.isNotEmpty
                                ? Positioned(
                                    bottom: -10,
                                    right: 0,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor:
                                          colors(context).primaryColor,
                                      child: Center(
                                        child: Text(
                                          cartItems.length.toString(),
                                          style:
                                              textStyle.bodyTextSmall.copyWith(
                                            color: AppStaticColor.whiteColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shopDetails.title,
                    style: textStyle.bodyText.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.ph,
                  Text(
                    '${shopDetails.categoryModel.name}',
                    style: textStyle.bodyTextSmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  16.ph,
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 15.h,
                      ),
                      5.pw,
                      Text(
                        shopDetails.date,
                        style: textStyle.bodyTextSmall.copyWith(
                          color: AppStaticColor.blackColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // const Expanded(child: SizedBox()),
                      10.pw,
                      AppCustomDivider(height: 10.h),
                      10.pw,
                      // const Expanded(child: SizedBox()),
                      Icon(
                        Icons.person,
                        color: Colors.amber,
                        size: 15.h,
                      ),
                      5.pw,
                      Text(
                        'Admin',
                        style: textStyle.bodyTextSmall.copyWith(
                          color: AppStaticColor.blackColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
