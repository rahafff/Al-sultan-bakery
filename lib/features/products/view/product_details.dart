// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/logic/cart_repo.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/features/cart/view/widget/cart_remove_dialog.dart';
import 'package:grocerymart/features/categories/model/responses/addons_response.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/categories/model/responses/variation_items_response.dart';
import 'package:grocerymart/features/categories/model/responses/variation_response.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/buttons/add_to_cart_button.dart';
import 'package:grocerymart/widgets/buttons/full_width_button.dart';
import 'package:grocerymart/widgets/buttons/top_nav_bar_icon_button.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';
import 'package:grocerymart/widgets/misc.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readmore/readmore.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ProductResponse? product;
  const ProductDetailsScreen({
    super.key,
    this.product,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  List<VariationItemsResponse> _selectedVariation = [];

  Map<String, VariationItemsResponse> _selectedValueGroup = {};

  List<AddonsResponse> addonsItems = [];

  // ValueListenable<int> productQuantity = ValueNotifier<int>(1);
  final ValueNotifier<int> productQuantity = ValueNotifier<int>(1);
  final ValueNotifier<num> totalPrice = ValueNotifier<num>(0.0);

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return ValueListenableBuilder<Box<HiveCartModel>>(
      valueListenable: Hive.box<HiveCartModel>(AppHSC.cartBox).listenable(),
      builder: (context, cartBox, _) {
        // bool inCart = false;
        // int productQuantity = 0;
        // int cartIndex = -1;
        final cartItems = cartBox.values.toList();
        //
        // for (int i = 0; i < cartItems.length; i++) {
        //   final cartProduct = cartItems[i];
        //   if (cartProduct.id == widget.product?.id) {
        //     inCart = true;
        //     productQuantity = cartProduct.productsQTY;
        //     cartIndex = i;
        //     break;
        //   }
        // }
        return ScreenWrapper(
          bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  color: AppStaticColor.whiteColor,
                  boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.outer,
                        color: AppStaticColor.primaryColor,
                        blurRadius: 5,
                        spreadRadius: 5)
                  ]),
              height: 60.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: AppStaticColor.accentColor)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            AppIconButton(
                              size: 25.sp,
                              iconData: Icons.remove,
                              btnColor: colors(context).primaryColor ??
                                  AppStaticColor.primaryColor,
                              iconColor: AppStaticColor.whiteColor,
                              onTap: () {
                                if (productQuantity.value > 1) {
                                  productQuantity.value--;
                                  calculateTotalPrice();
                                }
                                // ref.read(cartRepo).decrementProductQuantity(
                                //   cartItem: widget.product ,
                                //   cartBox: cartBox,
                                //   index: cartIndex,
                                // );
                              },
                            ),
                            10.pw,
                            ValueListenableBuilder<int>(
                              valueListenable: productQuantity,
                              builder: (context, value, child) => Text(
                                productQuantity.value.toString(),
                                style: textStyle.bodyTextSmall.copyWith(
                                  color: AppStaticColor.blackColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            10.pw,
                            AppIconButton(
                              size: 25.sp,
                              iconData: Icons.add,
                              btnColor: AppStaticColor.primaryColor,
                              onTap: () async {
                                productQuantity.value++;
                                calculateTotalPrice();
                                // ref.read(cartRepo).incrementProductQuantity(
                                //   cartItem: widget.product?.id ?? -1,
                                //   box: cartBox,
                                //   index: cartIndex,
                                // );
                              },
                            ),
                            10.pw,
                          ],
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: totalPrice,
                      builder: (context, value, child) =>
                      AppTextButton(
                        onTap: () async {
                          HiveCartModel cartItem = HiveCartModel(
                              id: widget.product?.id ?? -1,
                              name: widget.product?.title ?? '',
                              productImage: widget.product?.image ?? '',
                              price:
                                  widget.product?.pricing.price?.toDouble() ?? 0,
                              oldPrice:
                                  widget.product?.pricing.oldPrice?.toDouble() ??
                                      0,
                              productsQTY: productQuantity.value,
                              variant: _selectedValueGroup.values
                                  .map(
                                    (e) => HiveAddonsItem(
                                        name: e.name, price: e.price),
                                  )
                                  .toList(),
                              addons: addonsItems
                                  .map(
                                    (e) => HiveAddonsItem(
                                        name: e.name, price: e.price),
                                  )
                                  .toList());
                          await cartBox.add(cartItem);
                          EasyLoading.showSuccess(S.current.addItem);
                          context.nav.pop();
                        },
                        width: 200.w,
                        title: '${S.current.addItem} ( ${totalPrice.value.toStringAsFixed(2)}${widget.product?.pricing.currency?.symbol} )',
                        height: 35.h,
                      ),
                    )
                  ],
                ),
              )),
          child: Column(
            children: [
              CustomAppBar(
                showSearchTextField: false,
                title: S.of(context).productDetails,
                trails: [
                  Stack(
                    children: [
                      TopNavBarIconButton(
                        svgPath: Assets.svg.iconBasketColored,
                        onTap: () {
                          context.nav.pushNamed(Routes.cartScreen);
                        },
                      ),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: colors(context).primaryColor,
                          radius: 10.sp,
                          child: Center(
                            child: Text(
                              cartItems.length.toString(),
                              style: textStyle.bodyTextSmall.copyWith(
                                color: AppStaticColor.whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ///IMAGE
                      Container(
                        color: AppStaticColor.whiteColor,
                        height: 260.h,
                        width: 390.w,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.product?.image ?? '',
                          placeholder: (context, url) =>
                              const Icon(Icons.image),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),

                      ///DETAILS
                      _buildDetailsCard(
                        product: widget.product!,
                        cartBox: cartBox,
                        productQuantity: productQuantity.value,
                        context: context,
                      ),

                      ///ADDbUTOON
                      30.ph
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailsCard({
    required ProductResponse product,
    required Box<HiveCartModel> cartBox,
    required int productQuantity,
    required BuildContext context,
  }) {
    final textStyle = AppTextStyle(context);
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: colors(context).accentColor ?? AppStaticColor.accentColor,
              blurRadius: 3,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: product.discountPercentage.isNotEmpty,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.h),
                decoration: BoxDecoration(
                  color: colors(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '-${product.discountPercentage}%',
                  style: textStyle.bodyTextSmall.copyWith(
                    color: AppStaticColor.whiteColor,
                  ),
                ),
              ),
            ),
            12.5.ph,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.title ?? '',
                    style: textStyle.subTitle,
                  ),
                ),
                Text(
                  '\$${product.pricing.price}',
                  style: textStyle.subTitle
                      .copyWith(color: colors(context).primaryColor),
                )
              ],
            ),
            12.5.ph,

            ReadMoreText(
              product.summary ?? '',
              style: textStyle.bodyText.copyWith(fontWeight: FontWeight.w400),
              trimLines: 4,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show More',
              trimExpandedText: 'Show less',
              moreStyle: AppTextStyle(context).bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppStaticColor.primaryColor,
                  ),
              lessStyle: AppTextStyle(context).bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppStaticColor.primaryColor,
                  ),
            ),
            12.5.ph,

            ///Variation list
            Visibility(
              visible: product.variations.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCustomDivider(
                    width: double.infinity,
                    color: colors(context).bodyTextColor!.withOpacity(0.5),
                  ),
                  12.5.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.current.variation,
                          style: textStyle.bodyTextSmall.copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                          decoration: BoxDecoration(
                              color: AppStaticColor.blackColor,
                              borderRadius:
                                  BorderRadiusDirectional.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              S.current.required,
                              style: textStyle.bodyTextSmall.copyWith(
                                  color: AppStaticColor.whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  ),
                  12.ph,
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: product.variations.map(
                        (e) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${S.current.select} ${e.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              10.5.ph,
                              Column(
                                children: e.items
                                    .map(
                                      (item) => RadioListTile<
                                              VariationItemsResponse>(
                                          contentPadding:
                                              EdgeInsetsDirectional.zero,
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(item.name),
                                              Text(
                                                  '(+ ${item.price}${item.currency.symbol})',
                                                  style: textStyle.bodyText
                                                      .copyWith(
                                                          color: Colors
                                                              .green.shade600))
                                            ],
                                          ),
                                          activeColor:
                                              AppStaticColor.primaryColor,
                                          value: item,
                                          groupValue:
                                              _selectedValueGroup[e.name],
                                          dense: true,
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          onChanged: (newVal) {
                                            _selectedValueGroup[e.name] =
                                                newVal!;
                                            setState(() {});
                                          }),
                                    )
                                    .toList(),
                              ),
                            ],
                          );
                        },
                      ).toList()),
                ],
              ),
            ),
            12.5.ph,

            ///addOns
            Visibility(
              visible: product.addons.isNotEmpty,
              child: Column(
                children: [
                  AppCustomDivider(
                    width: double.infinity,
                    color: colors(context).bodyTextColor!.withOpacity(0.5),
                  ),
                  12.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.current.addOns,
                          style: textStyle.bodyTextSmall.copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Container(
                          decoration: BoxDecoration(
                              color: AppStaticColor.blackColor,
                              borderRadius:
                                  BorderRadiusDirectional.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              S.current.optional,
                              style: textStyle.bodyTextSmall.copyWith(
                                  color: AppStaticColor.accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: product.addons
                        .map(
                          (item) => CheckboxListTile(
                              activeColor: AppStaticColor.primaryColor,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(item.name)),
                                  Text(
                                    '(+ ${item.price}${item.currency.symbol})',
                                    style: textStyle.bodyText
                                        .copyWith(color: Colors.green.shade600),
                                  ),
                                ],
                              ),
                              dense: true,
                              value: addonsItems.contains(item),
                              contentPadding: EdgeInsetsDirectional.zero,
                              onChanged: (va) {
                                if (va ?? false) {
                                  addonsItems.add(item);

                                  (item.price);
                                } else {
                                  addonsItems.remove(item);

                                }
                                calculateTotalPrice();
                                setState(() {});
                              }),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPrice();
    if (widget.product?.variations.isNotEmpty ?? false) {
      initSelectItems();
    }
  }

  initSelectItems() {
    List<VariationResponse> ir = widget.product?.variations ?? [];
    for (var variation in ir) {
      _selectedValueGroup[variation.name] = variation.items.first;
      totalPrice.value += variation.items.first.price;
    }
  }
  initPrice (){
    totalPrice.value += widget.product?.pricing.price ?? 0.0;
  }

  calculateTotalPrice(){
    num totalAddons = 0.0;
    addonsItems.forEach((element) => totalAddons +=element.price ,);
   var subTotal = ( widget.product?.pricing.price ?? 0.0 ) + totalAddons;

   totalPrice.value = subTotal * productQuantity.value;
  }
}
