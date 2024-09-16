import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/view/widget/basic_product_card.dart';
import 'package:grocerymart/util/entensions.dart';

class ViewAllProduct extends StatelessWidget {
 final ViewProductArguments arguments;
  const ViewAllProduct({super.key, required this.arguments, });

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 80.h,
          title: Text(arguments.title),
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Future.delayed(const Duration(milliseconds: 200), () {
                  context.nav.pop();
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),

        ),
        body: AnimationLimiter(
          child: GridView.builder(

            padding: EdgeInsets.symmetric(
                horizontal: 16.w, vertical: 14.h),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 171 / 240),
            itemBuilder: (context, index) =>
                AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: MainProductCard(
                        product: arguments.products[index],
                        cardColor: colors(context).accentColor,
                      ),
                    ),
                  ),
                ),
            itemCount: arguments.products.length,
          ),
        ),
        ));
  }
}
class ViewProductArguments {
  final  List<ProductResponse> products;
  final String title;

  ViewProductArguments({ required this.products, required this.title});
}