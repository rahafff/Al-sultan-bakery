// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/features/categories/model/responses/category_response.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/categories/views/widget/custom_chip.dart';
import 'package:grocerymart/features/home/view/widget/basic_product_card.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SubCategoryProductScreen extends ConsumerStatefulWidget {
  final List<SubCategoryResponse> subCategoryList;
  const SubCategoryProductScreen({
    super.key,
    required this.subCategoryList,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoryViewState();
}

class _CategoryViewState extends ConsumerState<SubCategoryProductScreen> {
  final List<ProductResponse> _productList = [];
  int _selectedIndex = 0;
  String _title = '';

  final ItemScrollController _scrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
  ScrollOffsetController();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _title = widget.subCategoryList.first.name!;
    _productList.addAll(widget.subCategoryList.first.products ?? []);
  }


  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return Scaffold(
      body: ScreenWrapper(
        child: ValueListenableBuilder<Box<HiveCartModel>>(
          valueListenable: Hive.box<HiveCartModel>(AppHSC.cartBox).listenable(),
          builder: (context, cartBox, _) {
            final cartList = cartBox.values.toList();
            return Column(
              children: [
                Stack(
                  children: [
                    CustomAppBar(
                      title: _title,
                      showCartIcon: true,
                      showSearch: false,
                    ),
                    cartList.isNotEmpty
                        ? Positioned(
                            right: 12.w,
                            top: 40.h,
                            child: CircleAvatar(
                              radius: 12.sp,
                              backgroundColor: colors(context).primaryColor,
                              child: Center(
                                child: Text(
                                  cartList.length.toString(),
                                  style: textStyle.bodyText.copyWith(
                                    color: AppStaticColor.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                Container(
                  height: 50.h,
                  width: 390.w,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: ScrollablePositionedList.builder(
                    initialScrollIndex: _selectedIndex,
                    itemScrollController: _scrollController,
                    itemCount: widget.subCategoryList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final catgory = widget.subCategoryList[index];
                      return SelectChip(
                        onTap: () {
                          if (_selectedIndex != index) {
                            setState(() {
                              _selectedIndex = index;
                              _title = catgory.name!;
                            });
                            if (_scrollController.isAttached) {
                              _scrollController.scrollTo(
                                index: _selectedIndex,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOutCubic,
                              );
                            }
                            _productList.clear();
                            _productList.addAll(catgory.products ?? []);

                          }
                        },
                        isSelected: _selectedIndex == index,
                        title: '${catgory.name}',
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.r),
                    child: _productList.isNotEmpty
                            ? AnimationLimiter(
                                child: GridView.count(
                                  padding: EdgeInsets.only(top: 10.h),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16.h,
                                  crossAxisSpacing: 16.w,
                                  childAspectRatio: 171 / 240,
                                  children: List.generate(
                                    _productList.length,
                                    (index) =>
                                        AnimationConfiguration.staggeredGrid(
                                      columnCount: 2,
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: ScaleAnimation(
                                        child: FadeInAnimation(
                                          child: MainProductCard(
                                            product: _productList[index],
                                            cardColor:
                                                colors(context).accentColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  ' Opps no product found!',
                                  style: textStyle.subTitle,
                                ),
                              ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

}
