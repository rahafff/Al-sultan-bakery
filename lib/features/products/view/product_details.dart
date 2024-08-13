// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/logic/cart_repo.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/features/cart/view/widget/cart_remove_dialog.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/model/product.dart';
import 'package:grocerymart/features/products/logic/product_repo.dart';
import 'package:grocerymart/features/products/model/product_details.dart';
import 'package:grocerymart/features/products/view/widgets/related_products.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/buttons/add_to_cart_button.dart';
import 'package:grocerymart/widgets/buttons/top_nav_bar_icon_button.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';
import 'package:grocerymart/widgets/misc.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readmore/readmore.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final int productId;
  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return ScreenWrapper(
      child: FutureBuilder(
        future: ref
            .read(productRepo)
            .getProductDetails(productId: widget.productId),
        builder: (context, AsyncSnapshot<ProductDetails> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text(
                  S.of(context).someThingWrong,
                  style: textStyle.subTitle,
                ),
              );
            }
            final productDetails = snapshot.data;
            if (productDetails != null) {
              final ProductWithShop product = productDetails.product;
              final Shop shopDetails = productDetails.product.shop;
              final List<ProductResponse> relatedProducts = productDetails.products;

              return ValueListenableBuilder<Box<HiveCartModel>>(
                valueListenable:
                    Hive.box<HiveCartModel>(AppHSC.cartBox).listenable(),
                builder: (context, cartBox, _) {
                  bool inCart = false;
                  int productQuantity = 0;
                  int cartIndex = -1;
                  final cartItems = cartBox.values.toList();

                  for (int i = 0; i < cartItems.length; i++) {
                    final cartProduct = cartItems[i];
                    if (cartProduct.id == product.id) {
                      inCart = true;
                      productQuantity = cartProduct.productsQTY;
                      cartIndex = i;
                      break;
                    }
                  }
                  return Column(
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
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            Container(
                              color: AppStaticColor.whiteColor,
                              height: 260.h,
                              width: 390.w,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: product.thumbnail,
                                placeholder: (context, url) =>
                                    const Icon(Icons.image),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            _buildDetailsCard(
                              product: product,
                              inCart: inCart,
                              cartBox: cartBox,
                              cartIndex: cartIndex,
                              productQuantity: productQuantity,
                              cartItems: cartItems,
                              context: context,
                              shopDetails: shopDetails,
                            ),
                            _buildRelatedCard(shopDetails, relatedProducts)
                          ],
                        ),
                      )
                    ],
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  S.of(context).productDNF,
                  style: textStyle.subTitle,
                ),
              );
            }
          }
          return Center(
            child: Container(
              constraints: BoxConstraints(maxHeight: 120.h, minWidth: 100.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: colors(context).accentColor),
              width: 200,
              child: const BusyLoader(
                size: 120,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailsCard(
      {required ProductWithShop product,
      required bool inCart,
      required Box<HiveCartModel> cartBox,
      required int cartIndex,
      required int productQuantity,
      required List<HiveCartModel> cartItems,
      required BuildContext context,
      required Shop shopDetails}) {
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.h),
                  decoration: BoxDecoration(
                    color: colors(context).primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    product.discountPercentage.toString(),
                    style: textStyle.bodyTextSmall.copyWith(
                      color: AppStaticColor.whiteColor,
                    ),
                  ),
                ),
                Text(
                  '\$${product.price}/${product.sellType}',
                  style: textStyle.subTitle
                      .copyWith(color: colors(context).primaryColor),
                )
              ],
            ),
            12.5.ph,
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: textStyle.subTitle,
                  ),
                ),
                inCart
                    ? Row(
                        children: [
                          AppIconButton(
                            size: 28.sp,
                            iconData: Icons.remove,
                            btnColor: colors(context).accentColor ??
                                AppStaticColor.accentColor,
                            iconColor: AppStaticColor.blackColor,
                            onTap: () {
                              ref.read(cartRepo).decrementProductQuantity(
                                    productId: product.id,
                                    cartBox: cartBox,
                                    index: cartIndex,
                                  );
                            },
                          ),
                          5.pw,
                          Text(
                            productQuantity.toString(),
                            style: textStyle.bodyTextSmall.copyWith(
                              color: AppStaticColor.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          5.pw,
                          AppIconButton(
                            size: 28.sp,
                            iconData: Icons.add,
                            btnColor: colors(context).primaryColor ??
                                AppStaticColor.primaryColor,
                            onTap: () async {
                              ref.read(cartRepo).incrementProductQuantity(
                                    productId: product.id,
                                    box: cartBox,
                                    index: cartIndex,
                                  );
                            },
                          ),
                        ],
                      )
                    : AddToCartButton(
                        size: 28.sp,
                        onTap: () async {
                          HiveCartModel cartItem = HiveCartModel(
                            id: product.id,

                            name: product.name,
                            productImage: product.thumbnail,
                            price: product.price,
                            oldPrice: product.oldPrice,
                            productsQTY: 1,
                          );

                          if (cartItems.isEmpty) {
                            await cartBox.add(cartItem);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => CartRemoveDialog(
                                cartBox: cartBox,
                              ),
                            );
                          }
                        },
                      )
              ],
            ),
            12.5.ph,
            AppCustomDivider(
              width: double.infinity,
              color: colors(context).bodyTextColor!.withOpacity(0.5),
            ),
            12.5.ph,
            ReadMoreText(
              product.description,
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
            AppCustomDivider(
              width: double.infinity,
              color: colors(context).bodyTextColor!.withOpacity(0.5),
            ),
            12.5.ph,
            Container(
              decoration: BoxDecoration(
                  color: AppStaticColor.accentColor,
                  borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.all(10.r),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.svg.iconStore,
                    color: AppStaticColor.grayColor,
                  ),
                  9.5.pw,
                  Expanded(
                    child: Text(
                      shopDetails.name,
                      style: textStyle.bodyTextSmall.copyWith(
                          color: AppStaticColor.blackColor,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  9.5.pw,
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 14.r,
                  ),
                  5.4.pw,
                  Text(
                    shopDetails.rating,
                    style: textStyle.bodyTextSmall.copyWith(
                        fontSize: 12.sp,
                        color: AppStaticColor.blackColor,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedCard(
    Shop shopDetails,
    List<ProductResponse> relatedProducts,
  ) {
    final textStyle = AppTextStyle(context);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: colors(context).accentColor ?? AppStaticColor.accentColor,
              blurRadius: 1,
            )
          ]),
      padding: EdgeInsets.all(16.r),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).distanceFML,
                  style:
                      textStyle.bodyText.copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                shopDetails.distance,
                style: textStyle.bodyText.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
          20.ph,
          Row(
            children: [
              Expanded(
                child: Text(
                  S.of(context).edtimatedDT,
                  style:
                      textStyle.bodyText.copyWith(fontWeight: FontWeight.w400),
                ),
              ),
              Text(
                shopDetails.deliveryTime,
                style: textStyle.bodyText.copyWith(fontWeight: FontWeight.w400),
              ),
            ],
          ),
          12.5.ph,
          AppCustomDivider(
            width: double.infinity,
            color: colors(context).bodyTextColor!.withOpacity(0.5),
          ),
          12.5.ph,
          relatedProducts.isNotEmpty
              ? Text(
                  S.of(context).relatedItems,
                  style: textStyle.subTitle,
                )
              : const SizedBox(),
          // 12.ph,
          // RelatedProductsCard(
          //   relatedProducts: relatedProducts,
          // )
        ],
      ),
    );
  }
}
