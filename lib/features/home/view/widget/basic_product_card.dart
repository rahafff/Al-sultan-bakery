// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/logic/cart_repo.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/features/cart/view/widget/cart_remove_dialog.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/model/product_special.dart';
import 'package:grocerymart/features/products/view/product_details.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/buttons/add_to_cart_button.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainProductCard extends StatelessWidget {
  final ProductResponse product;
  final Color? cardColor;
  const MainProductCard({
    Key? key,
    required this.product,
    this.cardColor = AppStaticColor.whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return  GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) =>
                ProductDetailsScreen(product: product),
            isScrollControlled: true);
      },
      child: Consumer(
        builder: (context, ref, _) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppStaticColor.grayColor.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        height: 105.h,
                        width: 147.w,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: product.image ?? '',
                          placeholder: (context, url) =>
                          const Icon(Icons.image),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5.h),
                          SizedBox(height: 5.0.h),
                          Text(
                            product.title ?? '',
                            style: textStyle.bodyTextSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppStaticColor.blackColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5.h),
                          priceWidget(context),
                          SizedBox(height: 10.h),
                          Text(
                            product.summary.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textStyle.bodyTextSmall.copyWith(
                                fontSize: 12.sp,
                                color: AppStaticColor.grayColor,
                                fontWeight: FontWeight.w400),
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: AddToCartButton(
                              size: 28.sp,
                              onTap: ()  {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        ProductDetailsScreen(product: product),
                                    isScrollControlled: true);
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              product.discountPercentage.isNotEmpty
                  ? Positioned(
                top: 10.h,
                child: Container(
                  height: 25.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.sp),
                    color: colors(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      '-${product.discountPercentage}%',
                      style: textStyle.bodyTextSmall.copyWith(
                          color: AppStaticColor.whiteColor,
                          fontWeight: FontWeight.bold),
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
              )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget priceWidget(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return product.pricing.isPrevious != 0
        ? RichText(
      textDirection: TextDirection.ltr,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${product.pricing.currency?.symbol} ${product.priceWithTax.toStringAsFixed(2)} ',
                  style: textStyle.bodyTextSmall.copyWith(
                      color: colors(context).primaryColor,
                      fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: product.oldPriceWithTax.toStringAsFixed(2),
                  style: textStyle.bodyTextSmall.copyWith(
                    fontSize: 12.sp,
                    color: AppStaticColor.grayColor,
                    decoration: TextDecoration.lineThrough,
                  ),
                )
              ],
            ),
          )
        : Text(
        '${product.pricing.currency?.symbol} ${product.priceWithTax.toStringAsFixed(2)}',textDirection: TextDirection.ltr,style: textStyle.bodyTextSmall.copyWith(
        color: colors(context).primaryColor,
        fontWeight: FontWeight.w500),);
  }
}
