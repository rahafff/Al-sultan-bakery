import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/view/cart_view.dart';
import 'package:grocerymart/features/cart/view/widget/address_selection_dialog.dart';
import 'package:grocerymart/features/checkout/logic/order_provider.dart';
import 'package:grocerymart/features/checkout/model/checkout/checkout_home_delivery.dart';
import 'package:grocerymart/features/checkout/model/offline_mode.dart';
import 'package:grocerymart/features/checkout/model/online_mode.dart';
import 'package:grocerymart/features/checkout/model/paymnet_model.dart';
import 'package:grocerymart/features/checkout/view/widget/confirm_dialog.dart';

import 'package:grocerymart/features/menu/view/widgets/address_card.dart';
import 'package:grocerymart/features/payment/logic/payment_repo.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/buttons/full_width_button.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/shipping_billing_response.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final CheckoutArgument checkoutArgument;
  const CheckoutScreen({
    super.key,
    required this.checkoutArgument,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentModel? _selectedPaymentMethod;
  ShippingBillingResponse? shippingAddress;
  ShippingBillingResponse? billingAddress;
  List<PaymentModel> paymentsMethod = [];

  bool isShippingSameBilling = true;

  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();


  final TextEditingController zipCodeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(orderStateNotifierProvider);
    return ScreenWrapper(
      child: Column(
        children: [
          CustomAppBar(
            title: S.of(context).checkOut,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  children: [
                    Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable:
                              Hive.box(AppHSC.deliveryAddressBox).listenable(),
                          builder: (context, addressBox, _) {
                            Map<dynamic, dynamic>? addressShipping =
                                addressBox.get(AppHSC.shippingAddress);
                            if (addressShipping != null) {
                              Map<String, dynamic> addressStringKey =
                                  addressShipping.cast<String, dynamic>();
                              shippingAddress =
                                  ShippingBillingResponse.fromJson(
                                      addressStringKey);
                            }
                            /*-----------------------------------------*/
                            Map<dynamic, dynamic>? addressBilling =
                                addressBox.get(AppHSC.billingAddress);
                            if (addressBilling != null) {
                              Map<String, dynamic> addressBillStringKey =
                                  addressBilling.cast<String, dynamic>();
                              billingAddress = ShippingBillingResponse.fromJson(
                                  addressBillStringKey);
                            }
                            /*-----------------------------------------*/

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                shippingAddress != null
                                    ? Column(
                                        children: [
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.topEnd,
                                            children: [
                                              AddressCard(
                                                userAddress: shippingAddress!,
                                              ),
                                              SizedBox(
                                                width: 100.w,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                    minimumSize: Size(50.w, 30),
                                                    foregroundColor:
                                                        colors(context)
                                                            .primaryColor,
                                                    backgroundColor:
                                                    colors(context)
                                                        .primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.sp),
                                                    ),
                                                    side: BorderSide(
                                                      color: colors(context)
                                                              .primaryColor ??
                                                          AppStaticColor
                                                              .primaryColor,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    context.nav.pushNamed(
                                                      Routes
                                                          .addUserAddressScreen,
                                                      arguments:
                                                          shippingAddress,
                                                    );
                                                  },
                                                  child: Center(
                                                    child: Text(S.of(context).edit,style: TextStyle(color: AppStaticColor.whiteColor),),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 10.h),
                                        ],
                                      )
                                    : SizedBox(
                                        height: 50.h,
                                        child: TextButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    AppStaticColor.accentColor),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(
                                              colors(context).primaryColor ??
                                                  AppStaticColor.primaryColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            context.nav.pushNamed(
                                              Routes.addUserAddressScreen,
                                              arguments: ShippingBillingResponse(isShipping: true),
                                            );
                                          },
                                          icon: const Icon(Icons.add),
                                          label: Text(
                                              S.of(context).addShippingAddress),
                                        ),
                                      ),

                                10.ph,

                                ///billling
                                ///

                                Visibility(
                                    visible: !isShippingSameBilling,
                                    child: billingAddress != null
                                        ? Column(
                                            children: [
                                              Stack(
                                                alignment:
                                                    AlignmentDirectional.topEnd,
                                                children: [
                                                  AddressCard(
                                                    userAddress:
                                                        billingAddress!,
                                                  ),
                                                  SizedBox(
                                                    width: 100.w,
                                                    child: TextButton(
                                                      style:
                                                          TextButton.styleFrom(
                                                        minimumSize: Size(50.w, 30),
                                                        backgroundColor: colors(context)
                                                            .primaryColor,
                                                        foregroundColor:
                                                            colors(context)
                                                                .primaryColor,

                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.sp),
                                                        ),
                                                        side: BorderSide(
                                                          color: colors(context)
                                                                  .primaryColor ??
                                                              AppStaticColor
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        context.nav.pushNamed(
                                                          Routes
                                                              .addUserAddressScreen,
                                                          arguments:
                                                              billingAddress,
                                                        );
                                                      },
                                                      child: Center(
                                                        child: Text(S.of(context).edit,style: TextStyle(color: AppStaticColor.whiteColor),),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                            ],
                                          )
                                        : SizedBox(
                                            height: 50.h,
                                            child: TextButton.icon(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        AppStaticColor
                                                            .accentColor),
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(
                                                  colors(context)
                                                          .primaryColor ??
                                                      AppStaticColor
                                                          .primaryColor,
                                                ),
                                              ),
                                              onPressed: () {
                                                context.nav.pushNamed(
                                                  Routes.addUserAddressScreen,
                                                  arguments: ShippingBillingResponse(isShipping: false),
                                                );
                                              },
                                              icon: const Icon(Icons.add),
                                              label: Text(S
                                                  .of(context)
                                                  .addBillingAddress),
                                            ),
                                          ))
                              ],
                            );
                          },
                        ),
                        15.ph,
                        Card(
                          child: CheckboxListTile(
                            title: Text(S.current.billingIsSameShipping),
                            value: isShippingSameBilling,
                            activeColor: AppStaticColor.primaryColor,
                            onChanged: (value) {
                              isShippingSameBilling = value ?? false;
                              setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                    15.ph,
                    _buildInfoField(),
                    15.ph,
                    _buildPaymentCard(),
                    15.ph,
                    _buildCardInfo(),
                  ],
                ),
              ),
            ),
          ),

          ///placeOrder
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color:
                      colors(context).accentColor ?? AppStaticColor.accentColor,
                  blurRadius: 3,
                ),
              ],
            ),
            height: 96.h,
            width: 390.w,
            child: Row(
              children: [
                Expanded(
                  child: isLoading
                      ? SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: const BusyLoader(),
                        )
                      : ref.watch(paymentRepo).isLoading
                          ? SizedBox(
                              height: 100.h,
                              width: 100.w,
                              child: const BusyLoader(),
                            )
                          : SizedBox(
                              height: 50.h,
                              child: AppTextButton(
                                title: S.of(context).placeOrder,
                                onTap: () async {

                                  if (widget.checkoutArgument.servingMethod == 'home_delivery') {
                                    print(int.tryParse(cardNumber));
                                    print('dddddddd');
                                    CheckoutHomeDeliveryModel orderData =
                                        CheckoutHomeDeliveryModel(
                                      gateway:
                                          _selectedPaymentMethod?.name ?? '',
                                      gatewayId:
                                          _selectedPaymentMethod?.id ?? -1,
                                      postalCode: widget
                                              .checkoutArgument.postalCodeId ??
                                          -1,
                                      sameAsShipping:
                                          isShippingSameBilling ? 1 : 0,
                                      note: widget.checkoutArgument.notes,
                                      couponCode:
                                          widget.checkoutArgument.couponCode,
                                      product: widget.checkoutArgument.products,
                                      zipCode: zipCodeController.text,
                                       shippingAddress: ShippingAddress(
                                              countryCode: shippingAddress?.countryCode ?? '',
                                            address:  shippingAddress?.address ?? '',
                                            city:  shippingAddress?.city ?? '',
                                            country:  shippingAddress?.country ?? '',
                                            email:  shippingAddress?.email ?? '',
                                            number:  shippingAddress?.number ?? '',
                                            fname:  shippingAddress?.fName ?? '',
                                            lname:  shippingAddress?.lName ?? ''
                                          ),
                                      billingAddress: ShippingAddress(
                                              countryCode: billingAddress?.countryCode ?? '',
                                              address:  billingAddress?.address ?? '',
                                              city:  billingAddress?.city ?? '',
                                              country:  billingAddress?.country ?? '',
                                              email:  billingAddress?.email ?? '',
                                              number:  billingAddress?.number ?? '',
                                              fname:  billingAddress?.fName ?? '',
                                              lname:  billingAddress?.lName ?? ''
                                          ),
                                          cardNumber: int.tryParse(cardNumber),
                                          month: int.tryParse(expiryDate.split('/').first),
                                          year: int.tryParse(expiryDate.split('/').last),
                                          cardCVC: int.tryParse(cvvCode)
                                    );
                                    if (_selectedPaymentMethod?.type == 'online') {
                                      await ref
                                          .read(orderStateNotifierProvider.notifier).checkOutHomeOnline(
                                              orderData: orderData)
                                          .then(
                                        (orderId) async {
                                          if (orderId) {
                                            widget.checkoutArgument.cartBox
                                                .clear();
                                            return showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (builder) =>
                                                  ConfirmDialog(
                                                cartBox: widget
                                                    .checkoutArgument.cartBox,
                                                orderId: 1,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    } else {
                                      await ref
                                          .read(orderStateNotifierProvider
                                              .notifier)
                                          .checkOutHomeOffline(
                                              orderData: orderData)
                                          .then(
                                        (orderId) async {
                                          if (orderId) {
                                            widget.checkoutArgument.cartBox
                                                .clear();
                                            return showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (builder) =>
                                                  ConfirmDialog(
                                                cartBox: widget
                                                    .checkoutArgument.cartBox,
                                                orderId: 1,
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    }
                                  }

                                  ///pickUp
                                  else {}
                                },
                              ),
                            ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
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
                const Icon(Icons.payment),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    S.of(context).toBePaid,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Text(
                  '\$${widget.checkoutArgument.payable.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),

          ///offline
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: paymentsMethod
                .map(
                  (e) => Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Radio(
                          value: e,
                          groupValue: _selectedPaymentMethod,
                          activeColor: colors(context).primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                        title: Text(
                          e.name ?? '',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoField() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: TextField(
          controller: zipCodeController,
          maxLines: 1,
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: S.of(context).postalCode,
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
      ),
    );
  }

  String cardNumber = '';
  String expiryDate = '';
  String cvvCode = '';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Widget _buildCardInfo() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Visibility(
        visible: _selectedPaymentMethod?.type == 'online',
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.current.cardInfo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      controller: cardNumberCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: 'Card Number'),
                      maxLength: 16,
                      onChanged: (value) {

                        cardNumber = value.trim();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      controller: expiryFieldCtrl,
                      decoration: InputDecoration(hintText: 'Card Expiry'),
                      maxLength: 5,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        var newDateValue = value.trim();
                        final isPressingBackspace =
                            expiryDate.length > newDateValue.length;
                        final containsSlash = newDateValue.contains('/');

                        if (newDateValue.length >= 2 &&
                            !containsSlash &&
                            !isPressingBackspace) {
                          newDateValue = newDateValue.substring(0, 2) +
                              '/' +
                              newDateValue.substring(2);
                        }
                        setState(() {
                          expiryFieldCtrl.text = newDateValue;
                          expiryFieldCtrl.selection =
                              TextSelection.fromPosition(
                                  TextPosition(offset: newDateValue.length));
                          expiryDate = newDateValue;
                        });
                      },
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(
                  //     horizontal: 20,
                  //   ),
                  //   child: TextFormField(
                  //     decoration: InputDecoration(hintText: 'Card Holder Name'),
                  //     onChanged: (value) {
                  //       setState(() {
                  //         cardHolderName = value;
                  //       });
                  //     },
                  //   ),
                  // ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: TextFormField(
                      decoration: const InputDecoration(hintText: 'CVC'),
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          cvvCode = value;
                        });
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  List<OfflineMode> offlines = [];

  OnlineMode onlineMode = OnlineMode(-1, 0, '');

  init() {
    Future.wait([
      ref.read(orderStateNotifierProvider.notifier).getOfflinePayment(),
      ref.read(orderStateNotifierProvider.notifier).getOnlinePayment(),
    ]).then(
      (value) {
        offlines = value[0] as List<OfflineMode>;
        onlineMode = value[1] as OnlineMode;
        offlines.forEach(
          (element) => paymentsMethod.add(PaymentModel(
              id: element.id, type: 'offline', name: element.name)),
        );
        if (onlineMode.status == 1) {
          paymentsMethod.add(PaymentModel(
              name: onlineMode.name, type: 'online', id: onlineMode.id));
        }
        setState(() {});
      },
    );
  }


}
