import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:awesome_card/awesome_card.dart';
import 'dart:math' as math;

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/cart/view/cart_view.dart';
import 'package:grocerymart/features/cart/view/widget/address_selection_dialog.dart';
import 'package:grocerymart/features/checkout/logic/order_provider.dart';
import 'package:grocerymart/features/checkout/model/offline_mode.dart';
import 'package:grocerymart/features/checkout/model/online_mode.dart';
import 'package:grocerymart/features/checkout/model/paymnet_model.dart';
import 'package:grocerymart/features/checkout/model/place_order.dart';
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

final TextEditingController additionalInfoController = TextEditingController();

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentModel? _selectedPaymentMethod;
  ShippingBillingResponse? deliveryAddress;
  List<PaymentModel> paymentsMethod = [];
  String? _selectedServingMethod = 'home_delivery';

  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();

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
                    ValueListenableBuilder(
                      valueListenable:
                          Hive.box(AppHSC.deliveryAddressBox).listenable(),
                      builder: (context, addressBox, _) {
                        Map<dynamic, dynamic>? address =
                            addressBox.get(AppHSC.deliveryAddress);
                        if (address != null) {
                          Map<String, dynamic> addressStringKey =
                              address.cast<String, dynamic>();
                          deliveryAddress = ShippingBillingResponse.fromJson(
                              addressStringKey);
                        }
                        return deliveryAddress != null
                            ? Column(
                                children: [
                                  Stack(
                                    children: [
                                      AddressCard(
                                        userAddress: deliveryAddress!,
                                      ),
                                      Positioned(
                                        right: 14,
                                        top: 16,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: Size(50.w, 30),
                                            foregroundColor:
                                                colors(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.sp),
                                            ),
                                            side: BorderSide(
                                              color: colors(context)
                                                      .primaryColor ??
                                                  AppStaticColor.primaryColor,
                                            ),
                                          ),
                                          onPressed: () {
                                            context.nav.pushNamed(
                                              Routes.addUserAddressScreen,
                                              arguments: deliveryAddress,
                                            );
                                          },
                                          child: Center(
                                            child: Text(S.of(context).change),
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
                                        MaterialStateProperty.all<Color>(
                                            AppStaticColor.accentColor),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      colors(context).primaryColor ??
                                          AppStaticColor.primaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (builder) =>
                                          const SelectAddressDialog(),
                                    ).then(
                                      (value) {
                                        setState(() {});
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: Text(S.of(context).addAddress),
                                ),
                              );
                      },
                    ),
                    15.ph,
                    _buildInfoField(),
                    15.ph,
                    _buildServingMethod(),
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
                                  if (_selectedPaymentMethod?.name != '') {
                                    PlaceOrderModel orderData = PlaceOrderModel(
                                      // addressId: widget
                                      //     .checkoutArgument.userAddress.id!,
                                      paymentMethod:
                                          _selectedPaymentMethod?.name ?? '',
                                      product: widget.checkoutArgument.products,
                                      note: additionalInfoController.text,
                                      deliveryCharge:
                                          widget.checkoutArgument.deliverCharge,
                                      couponId:
                                          widget.checkoutArgument.couponId,
                                      paymentVia: _selectedPaymentMethod?.name ?? '',
                                    );
                                    await ref
                                        .read(
                                            orderStateNotifierProvider.notifier)
                                        .placeOrder(orderData: orderData)
                                        .then(
                                      (orderId) async {
                                        // widget.checkoutArgument.cartBox.clear();
                                        if (orderId == null) {
                                          debugPrint('order id null');
                                        } else {
                                          if (_selectedPaymentMethod?.type ==
                                              'online') {
                                            await ref
                                                .read(paymentRepo)
                                                .stripePayment(
                                                  amount: widget
                                                      .checkoutArgument.payable
                                                      .toInt(),
                                                  orderId: orderId,
                                                  cartBox: widget
                                                      .checkoutArgument.cartBox,
                                                );
                                          } else {
                                            return showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (builder) =>
                                                  ConfirmDialog(
                                                cartBox: widget
                                                    .checkoutArgument.cartBox,
                                                orderId: orderId,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    );
                                  } else {
                                    EasyLoading.showError(
                                      S.of(context).selectPaymentMethod,
                                    );
                                  }
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

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
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
                        final newCardNumber = value.trim();
                        var newStr = '';
                        final step = 4;

                        for (var i = 0; i < newCardNumber.length; i += step) {
                          newStr += newCardNumber.substring(
                              i, math.min(i + step, newCardNumber.length));
                          if (i + step < newCardNumber.length) newStr += ' ';
                        }

                        setState(() {
                          cardNumber = newStr;
                        });
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
                          expiryFieldCtrl.selection = TextSelection.fromPosition(
                              TextPosition(offset: newDateValue.length));
                          expiryDate = newDateValue;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Card Holder Name'),
                      onChanged: (value) {
                        setState(() {
                          cardHolderName = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'CVV'),
                      maxLength: 3,
                      onChanged: (value) {
                        setState(() {
                          // cvv = value;
                        });
                      },

                    ),
                  ),
                ],
              )
              // CreditCardForm(
              //   formKey: formKey,
              //   obscureCvv: true,
              //   obscureNumber: true,
              //   cardNumber: cardNumber,
              //   cvvCode: cvvCode,
              //   isHolderNameVisible: true,
              //   isCardNumberVisible: true,
              //   isExpiryDateVisible: true,
              //   cardHolderName: cardHolderName,
              //   expiryDate: expiryDate,
              //   inputConfiguration: const InputConfiguration(
              //     cardNumberDecoration: InputDecoration(
              //       labelText: 'Number',
              //       hintText: 'XXXX XXXX XXXX XXXX',
              //     ),
              //     expiryDateDecoration: InputDecoration(
              //       labelText: 'Expired Date',
              //       hintText: 'XX/XX',
              //     ),
              //     cvvCodeDecoration: InputDecoration(
              //       labelText: 'CVV',
              //       hintText: 'XXX',
              //     ),
              //     cardHolderDecoration: InputDecoration(
              //       labelText: 'Card Holder',
              //     ),
              //   ),
              //   onCreditCardModelChange: (p0) {},
              // ),
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
        paymentsMethod.add(PaymentModel(
            name: onlineMode.name, type: 'online', id: onlineMode.id));
        setState(() {});
      },
    );
  }


  Widget _buildServingMethod (){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Column(children: [
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
                _selectedServingMethod = value;
              });
            },
          ),
          title: Text('Pick Up',
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
                _selectedServingMethod = value;
              });
            },
          ),
          title: Text('Home Delivery',
            style: TextStyle(fontSize: 15.sp),
          ),
        ),

      ],),
    );
  }
}
