import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/features/categories/model/responses/category_response.dart';
import 'package:grocerymart/features/products/view/view_all_product.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';

class SubCategoryCard extends StatelessWidget {
  final SubCategoryResponse subCategory;
  const SubCategoryCard({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.nav.pushNamed(
            Routes.viewAllProduct,
            arguments: ViewProductArguments(title: subCategory.name ?? '',products: subCategory.products ?? []));

      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppStaticColor.accentColor,
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25.r),
            child: SizedBox(

              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: subCategory.image ?? 'https://alsultanbakkerij.nl/assets/front/img/product/featured/1721036529.jpg',
                placeholder: (context, url) => const Icon(Icons.image),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          title: Text(subCategory.name ?? ''),
          trailing: const Icon(Icons.arrow_circle_left,color:  AppStaticColor.grayColor,),
        ),
      ),
    );
  }
}
