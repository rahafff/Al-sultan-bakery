// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_input_decor.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/logic/cart_provider.dart';
import 'package:grocerymart/features/cart/model/discount_enum.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/features/cart/model/postal_code.dart';
import 'package:grocerymart/features/cart/view/widget/address_selection_dialog.dart';
import 'package:grocerymart/features/cart/view/widget/cart_summary_text.dart';
import 'package:grocerymart/features/cart/view/widget/cart_tile.dart';
import 'package:grocerymart/features/checkout/model/checkout/checkout_home_delivery.dart';
import 'package:grocerymart/features/checkout/model/place_order.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/menu/model/user_address.dart';
import 'package:grocerymart/features/menu/view/widgets/account_delete_dialog.dart';
import 'package:grocerymart/features/menu/view/widgets/address_card.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/service/hive_logic.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/buttons/full_width_button_with_icon.dart';
import 'package:grocerymart/widgets/buttons/outlined_button.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';
import 'package:grocerymart/widgets/misc.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController couponController = TextEditingController();
  final TextEditingController additionalInfoController = TextEditingController();
  double couponDiscountAmount = 0;
  String? couponCode;
  bool isCouponApply = false;
  bool isDiscountPercentage = false;

  List<double> previousSubtotals = [];
  bool isDark = false;
  bool isLoggedIn = false;

  double deliveryCharge = 0.0;
  List<PostalCode> postal = [];
  PostalCode? _selectedPostal ;

  String _selectedServingMethod = 'home_delivery';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        init();
      },
    );
  }

  init() {
    Future.wait([
      ref.read(hiveStorageProvider).getTheme(),
      ref.read(hiveStorageProvider).getAuthToken(),
      ref.read(postalStateNotifierProvider.notifier).getAllPostal(),
    ]).then(
      (value) {
        isDark = value[0] as bool;
        isLoggedIn = value[1] != null;
        postal = value[2] as List<PostalCode>;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    bool couponLoading = ref.watch(couponStateNotifierProvider);
    bool isLoadingPostal = ref.watch(postalStateNotifierProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ScreenWrapper(
        child: ValueListenableBuilder<Box<HiveCartModel>>(
          valueListenable: Hive.box<HiveCartModel>(AppHSC.cartBox).listenable(),
          builder: (context, box, _) {
            final cartItems = box.values.toList();
            final subTotal = calculateSubtotal(cartItems);

            ///for items without tax
            final addonsTotal = calculateAddonsTotal(cartItems);

            ///for items without tax
            final variationTotal = calculateVariantTotal(cartItems);

            ///for items without tax
            final products = getProducts(cartItems);
            final tax = calculateTax(cartItems);

            if(_selectedServingMethod == 'home_delivery'){
              if(_selectedPostal !=null){
                deliveryCharge = double.tryParse(_selectedPostal?.charge ?? '0.0') ?? 0.0;
              }

            }else{
              deliveryCharge = 0.0;
            }
            if (previousSubtotals.length == 2) {
              previousSubtotals.removeAt(0);
            }
            previousSubtotals.add(subTotal);

            double lastSubtotal = previousSubtotals.last;
            double secondLastSubTotal = previousSubtotals.first;

            if (lastSubtotal > secondLastSubTotal) {
              if (isCouponApply) {
                refreshCouponFunction(isHiveUpdate: true);
              }
            } else if (lastSubtotal < secondLastSubTotal) {
              if (isCouponApply) {
                refreshCouponFunction(isHiveUpdate: true);
              }
            }
            return cartItems.isNotEmpty
                ? Column(
                    children: [
                      CustomAppBar(
                        title:
                            '${S.of(context).cart} (${cartItems.length.toString()})',
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: CartTile(
                                cartItem: cartItems[index],
                                box: box,
                                index: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ListView(
                            padding: EdgeInsets.only(top: 8.0.h),
                            children: [
                              // ValueListenableBuilder(
                              //   valueListenable:
                              //       Hive.box(AppHSC.deliveryAddressBox)
                              //           .listenable(),
                              //   builder: (context, addressBox, _) {
                              //     Map<dynamic, dynamic>? address =
                              //         addressBox.get(AppHSC.deliveryAddress);
                              //     if (address != null) {
                              //       Map<String, dynamic> addressStringKey =
                              //           address.cast<String, dynamic>();
                              //       deliveryAddress = ShippingBillingResponse.fromJson(addressStringKey);
                              //     }
                              //     return deliveryAddress != null
                              //         ? Column(
                              //             children: [
                              //               Stack(
                              //                 children: [
                              //                   AddressCard(
                              //                     userAddress: deliveryAddress!,
                              //                   ),
                              //                   Positioned(
                              //                     right: 14,
                              //                     top: 16,
                              //                     child: TextButton(
                              //                       style: TextButton.styleFrom(
                              //                         minimumSize:
                              //                             Size(50.w, 30),
                              //                         foregroundColor:
                              //                             colors(context)
                              //                                 .primaryColor,
                              //                         shape:
                              //                             RoundedRectangleBorder(
                              //                           borderRadius:
                              //                               BorderRadius
                              //                                   .circular(
                              //                                       18.sp),
                              //                         ),
                              //                         side: BorderSide(
                              //                           color: colors(context)
                              //                                   .primaryColor ??
                              //                               AppStaticColor
                              //                                   .primaryColor,
                              //                         ),
                              //                       ),
                              //                       onPressed: () {
                              //                         context.nav
                              //                             .pushNamed(
                              //                           Routes.addUserAddressScreen,
                              //                           arguments: deliveryAddress,
                              //                         );
                              //                       },
                              //                       child: Center(
                              //                         child: Text(
                              //                             S.of(context).change),
                              //                       ),
                              //                     ),
                              //                   )
                              //                 ],
                              //               ),
                              //               SizedBox(height: 10.h),
                              //             ],
                              //           )
                              //         : SizedBox(
                              //             height: 50.h,
                              //             child: TextButton.icon(
                              //               style: ButtonStyle(
                              //                 backgroundColor:
                              //                     MaterialStateProperty
                              //                         .all<Color>(AppStaticColor
                              //                             .accentColor),
                              //                 foregroundColor:
                              //                     MaterialStateProperty.all<
                              //                         Color>(
                              //                   colors(context).primaryColor ??
                              //                       AppStaticColor.primaryColor,
                              //                 ),
                              //               ),
                              //               onPressed: () {
                              //                 showDialog(
                              //                   context: context,
                              //                   builder: (builder) =>
                              //                       const SelectAddressDialog(),
                              //                 );
                              //               },
                              //               icon: const Icon(Icons.add),
                              //               label:
                              //                   Text(S.of(context).addAddress),
                              //             ),
                              //           );
                              //   },
                              // ),
                              SizedBox(height: 10.h),

                              16.ph,
                              _buildServingMethod(),
                              16.ph,

                              _selectedServingMethod == 'home_delivery'
                                  ? isLoadingPostal
                                      ? const LinearProgressIndicator(
                                 color:  AppStaticColor.accentColor,
                                )
                                      : postalDropDown()
                                  : Container(),
                              16.ph,
                              _buildInfoField(),
                              16.ph,
                              isLoggedIn
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: couponController,
                                            onChanged: (v) {
                                              if (v.isEmpty) {
                                                refreshCouponFunction(
                                                    isHiveUpdate: false);
                                              }
                                            },
                                            decoration: AppInputDecor
                                                .loginPageInputDecor
                                                .copyWith(
                                              prefixIcon: SizedBox(
                                                height: 20.h,
                                                width: 20.w,
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    Assets.svg.iconPercentage,
                                                    fit: BoxFit.cover,
                                                    color: colors(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                              hintText:
                                                  S.of(context).enterPromoCode,
                                            ),
                                          ),
                                        ),
                                        10.pw,
                                        couponLoading
                                            ? Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w),
                                                child:
                                                    const CircularProgressIndicator(),
                                              )
                                            : AppOutlinedButton(
                                                width: 100.w,
                                                height: 50.h,
                                                title: isCouponApply
                                                    ? S.of(context).applied
                                                    : S.of(context).apply,
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  if (!isCouponApply) {
                                                    if (couponController
                                                        .text.isNotEmpty) {
                                                      ref
                                                          .read(
                                                              couponStateNotifierProvider
                                                                  .notifier)
                                                          .applyCouponCode(
                                                            couponCode:
                                                                couponController
                                                                    .text,
                                                            amount: subTotal,
                                                          )
                                                          .then((coupon) {
                                                        if (coupon != null) {
                                                          DiscountEnum type =
                                                              DiscountEnum
                                                                  .getEnumValue(
                                                                      coupon
                                                                          .type);
                                                          if (type ==
                                                              DiscountEnum
                                                                  .percentage) {
                                                            isDiscountPercentage =
                                                                true;
                                                          }

                                                          isCouponApply = true;
                                                          couponDiscountAmount =
                                                              double.tryParse(coupon
                                                                      .value) ??
                                                                  0.0;

                                                          couponCode =
                                                              couponController
                                                                  .text;
                                                        }
                                                      });
                                                    } else {
                                                      EasyLoading.showError(
                                                        S
                                                            .of(context)
                                                            .pEnterPromoCode,
                                                      );
                                                    }
                                                  }
                                                },
                                                buttonColor: Colors.transparent,
                                                borderWidth:
                                                    isCouponApply ? 5 : 1,
                                                borderColor: isCouponApply
                                                    ? AppStaticColor.accentColor
                                                    : colors(context)
                                                        .primaryColor,
                                                titleColor: isCouponApply
                                                    ? AppStaticColor.grayColor
                                                    : colors(context)
                                                        .primaryColor,
                                              )
                                      ],
                                    )
                                  : Container(),
                              16.ph,
                              _cartSummaryWidget(
                                  taxTotal: tax,
                                  subTotal: subTotal + variationTotal,
                                  discount: couponDiscountAmount,
                                  deliveryCharge: deliveryCharge,
                                  currency: '€',
                                  payableAmount: payableAmount(
                                      tax: tax,
                                      variationTotal: variationTotal,
                                      addons: addonsTotal,
                                      subTotal: subTotal,
                                      deliveryCharge: deliveryCharge,
                                      couponDiscountAmount: couponDiscountAmount),
                                  addOnsTotal: addonsTotal,
                                  isDiscountPercentage: isDiscountPercentage),
                              12.ph,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: colors(context).accentColor ??
                                    AppStaticColor.accentColor,
                                blurRadius: 2,
                              )
                            ]),
                        height: 96.h,
                        width: 390.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).total,
                                  style:
                                      textStyle.subTitle.copyWith(fontSize: 16),
                                ),
                                Text(
                                  '€${payableAmount(tax: tax, variationTotal: variationTotal, addons: addonsTotal, subTotal: subTotal, deliveryCharge: deliveryCharge, couponDiscountAmount: couponDiscountAmount).toStringAsFixed(2)}',
                                  style: textStyle.subTitle,
                                )
                              ],
                            ),
                            SizedBox(
                              width: 160.w,
                              height: 50,
                              child: AppTextButtonWithIcon(
                                onTap: () {
                                  CheckoutArgument checkoutArgument =
                                      CheckoutArgument(
                                    servingMethod: _selectedServingMethod,
                                    products: products,
                                    couponCode: couponCode,
                                    deliverCharge: deliveryCharge,
                                    payable: payableAmount(
                                      tax: tax,
                                      variationTotal: variationTotal,
                                      addons: addonsTotal,
                                      subTotal: subTotal,
                                      deliveryCharge: deliveryCharge,
                                      couponDiscountAmount:
                                          couponDiscountAmount,
                                    ),
                                    cartBox: box,
                                        notes: additionalInfoController.text,
                                        postalCodeId: _selectedPostal?.id
                                  );
                                  isLoggedIn
                                      ? Navigator.pushNamed(
                                          context,
                                          Routes.checkoutScreen,
                                          arguments: checkoutArgument,
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (context) => LoginDialog(),
                                        );
                                },
                                title: S.of(context).checkOut,
                                icon: Icons.arrow_right_alt,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                : Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Assets.images.emaptyCart.image(
                                height: 160.h,
                                width: 160.w,
                                color: colors(context).primaryColor),
                            SizedBox(height: 10.h),
                            Text(
                              'Oops!',
                              style: textStyle.subTitle.copyWith(
                                color: colors(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              S.of(context).yourCartIsEmpty,
                              style: textStyle.subTitle,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 20,
                        child: CircleAvatar(
                          radius: 25.r,
                          backgroundColor: isDark
                              ? AppStaticColor.accentColor
                              : AppStaticColor.blackColor,
                          child: IconButton(
                            onPressed: () {
                              context.nav.pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: isDark
                                  ? colors(context).primaryColor
                                  : AppStaticColor.accentColor,
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

  Widget _cartSummaryWidget({
    required double subTotal,

    ///items price
    required double addOnsTotal,
    required double taxTotal,

    ///sum of addons price
    required double discount,
    required double deliveryCharge,
    required double payableAmount,
    bool isDiscountPercentage = false,
    required String currency,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppStaticColor.accentColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          CartSummaryText(
            title: S.of(context).subTotal,
            subTitle: '$currency${subTotal.toStringAsFixed(2)}',
          ),
          12.ph,
          CartSummaryText(
            title: S.of(context).deliveryCharge,
            subTitle: '€$deliveryCharge',
          ),
          12.ph,
          CartSummaryText(
            title: S.of(context).addOns,
            subTitle: '$currency$addOnsTotal',
          ),
          12.ph,
          CartSummaryText(
            title: S.of(context).BTW,
            subTitle: '$currency${taxTotal.toStringAsFixed(2)}',
          ),
          12.ph,
          CartSummaryText(
            title: S.of(context).discount,
            subTitle:
                '-$currency${discount.toStringAsFixed(2)}${isDiscountPercentage ? '%' : ''}',
            isDicount: true,
          ),
          12.ph,
          AppCustomDivider(
            width: double.infinity,
            color: AppStaticColor.grayColor.withOpacity(0.2),
          ),
          12.ph,
          CartSummaryText(
            title: S.of(context).payableAmount,
            subTitle: '$currency${payableAmount.toStringAsFixed(2)}',
            shouldBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildServingMethod() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r)),
            ),
            child: Row(
              children: [
                const Icon(Icons.motorcycle),
                SizedBox(width: 10.w),
                Text(
                  S.of(context).servingMethod,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Radio(
              value: 'pick_up',
              groupValue: _selectedServingMethod,
              activeColor: colors(context).primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedServingMethod = value ?? 'home_delivery';
                });
              },
            ),
            title: Text(
              S.current.pickUp,
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Radio(
              value: 'home_delivery',
              groupValue: _selectedServingMethod,
              activeColor: colors(context).primaryColor,
              onChanged: (value) {
                setState(() {
                  _selectedServingMethod = value ?? 'home_delivery';
                });
              },
            ),
            title: Text(
              S.current.homeDelivery,
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
        ],
      ),
    );
  }

  double calculateTax(List<HiveCartModel> cartItems) {
    double totalPriceWithTax = 0.0;
    double totalPrice = 0.0;
    for (var item in cartItems) {
      totalPriceWithTax += item.priceWithTax * item.productsQTY;
      totalPrice += item.price * item.productsQTY;
      if (item.addons.isNotEmpty) {
        var addons = item.addons;
        for (var addons in addons) {
          totalPriceWithTax += addons.priceWithTax * item.productsQTY;
          totalPrice += addons.price * item.productsQTY;
        }
      }

      if (item.variant != null) {
        totalPriceWithTax +=
            (item.variant?.priceWithTax ?? 0) * item.productsQTY;
        totalPrice += (item.variant?.price ?? 0) * item.productsQTY;
      }
    }
    return (totalPriceWithTax - totalPrice);
  }

  double calculateSubtotal(List<HiveCartModel> cartItems) {
    double subTotal = 0.0;
    for (var item in cartItems) {
      subTotal += item.price * item.productsQTY;
    }
    return subTotal;
  }

  double calculateAddonsTotal(List<HiveCartModel> cartItems) {
    double addonsTotal = 0.0;
    for (var item in cartItems) {
      for (var addons in item.addons) {
        addonsTotal += addons.price * item.productsQTY;
      }
    }
    return addonsTotal;
  }

  double calculateVariantTotal(List<HiveCartModel> cartItems) {
    double addonsTotal = 0.0;
    for (var item in cartItems) {
      if (item.variant != null) {
        addonsTotal += (item.variant?.price ?? 0) * item.productsQTY;
      }
    }
    return addonsTotal;
  }

  double payableAmount(
      {required double subTotal,

      ///price
      required double deliveryCharge,
      required double addons,
      required double variationTotal,
      required double tax,
      required double couponDiscountAmount}) {
    if (isDiscountPercentage) {
      couponDiscountAmount =
          (subTotal + variationTotal + deliveryCharge + addons + tax) *
              (couponDiscountAmount / 100);
    }

    return (subTotal + deliveryCharge + addons + variationTotal + tax) -
        couponDiscountAmount;
  }

  List<Product> getProducts(List<HiveCartModel> cartItems) {
    List<Product> products = [];
    for (var item in cartItems) {
      Product product =
          Product(productId: item.id, productQTY: item.productsQTY, addons: []);
      if (item.addons.isNotEmpty) {
        for (var addon in item.addons) {
          product.addons.add(Addons(name: addon.name));
        }
      }
      if (item.variant != null) {
        product.variant = Addons(name: item.variant?.name ?? 'un');
      }
      products.add(product);
    }
    return products;
  }

  refreshCouponFunction({required bool isHiveUpdate}) {
    if (isHiveUpdate) {
      isCouponApply = false;
      couponCode = null;
      couponDiscountAmount = 0;
    } else {
      setState(() {
        isCouponApply = false;
        couponCode = null;
        couponDiscountAmount = 0;
      });
    }
  }

  Widget postalDropDown() {
    final textStyle = AppTextStyle(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.current.selectDeliveryArea,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            5.ph,
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    onChanged: (value) {
                      setState(() {
                        _selectedPostal = value;
                      });
                    },
                    hint: Text(S.current.selectDeliveryArea),
                      value: _selectedPostal,
                      itemHeight: 90,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      items: postal
                          .map(
                            (e) => DropdownMenuItem<PostalCode>(
                                value: e,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text(e.title),
                                  Row(
                                    children: [
                                      Text(e.postcode),
                                      Text('${e.currency.symbol}' '${e.charge} ',textDirection: TextDirection.ltr,style: textStyle.bodyText.copyWith(color: AppStaticColor.primaryColor,fontWeight: FontWeight.w800),),
                                    ],
                                  ),
                                    if(e.freeDelivery?.isEnable == 1) ...[
                                      Row(
                                        children: [
                                          Text(e.freeDelivery?.title ?? ''),
                                          Text('${e.currency.symbol}' '${e.freeDelivery?.amount} ',textDirection: TextDirection.ltr,style: textStyle.bodyText.copyWith(color: AppStaticColor.primaryColor,fontWeight: FontWeight.w800),),

                                        ],
                                      )
                                    ]


                                ],),
                            ),
                          )
                          .toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField() {
    return Container(
      height: 112.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
        ),
      ),
      child: TextField(
        controller: additionalInfoController,
        maxLines: 5,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: S.of(context).additionalInfo,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Colors.black.withOpacity(0.4),
          ),
          fillColor: AppStaticColor.accentColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class CheckoutArgument {
  int? postalCodeId;
  List<Product> products;
  String? couponCode;
  double deliverCharge;
  String servingMethod;
  double payable;
  String? notes;

  Box<HiveCartModel> cartBox;
  CheckoutArgument({
       this.postalCodeId,
    required this.products,
    required this.servingMethod,
    this.couponCode,
    required this.deliverCharge,
    required this.payable,
    required this.cartBox,
    this.notes
  });
}
