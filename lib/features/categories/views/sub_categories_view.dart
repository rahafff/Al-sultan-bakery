import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocerymart/features/categories/model/responses/category_response.dart';
import 'package:grocerymart/features/categories/views/widget/sub_category_card.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';

class SubCategoriesView extends StatelessWidget {
  final SubCategoriesArguments arguments;
  const SubCategoriesView({super.key,required this.arguments});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(child: Column(
      children: [
       CustomAppBar(title: arguments.title,) ,
        Expanded(
          child: AnimationLimiter(
                child: ListView.builder(
          padding: EdgeInsets.only(bottom: 100.h),
          shrinkWrap: true,
          itemCount: arguments.subCategories.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 8.h),
                      child:   SubCategoryCard(subCategory: arguments.subCategories[index])
                  ),
                ),
              ),
            );
          },
                ),
              ),
        )
      ],
    ));
  }
}

class SubCategoriesArguments{
  final List<SubCategoryResponse> subCategories;
  final String title;

  SubCategoriesArguments({ required this.subCategories, required this.title});
}