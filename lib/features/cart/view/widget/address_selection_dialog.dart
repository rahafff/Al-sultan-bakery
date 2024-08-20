import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/menu/logic/menu_provider.dart';
import 'package:grocerymart/features/menu/model/user_address.dart';
import 'package:grocerymart/features/menu/view/widgets/address_card.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/service/hive_logic.dart';
import 'package:grocerymart/util/context_less_nav.dart';
import 'package:grocerymart/widgets/busy_loader.dart';

class SelectAddressDialog extends ConsumerStatefulWidget {
  const SelectAddressDialog({super.key});

  @override
  ConsumerState<SelectAddressDialog> createState() =>
      _SelectAddressDialogState();
}

class _SelectAddressDialogState extends ConsumerState<SelectAddressDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(menuStateNotifierProvider);
    final textStyle = AppTextStyle(context);
    return Dialog(
      shadowColor: colors(context).accentColor,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
            constraints: BoxConstraints(
              maxHeight: 320.h,
              maxWidth: 320.w,
              minHeight: 320.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color:
                      colors(context).accentColor ?? AppStaticColor.accentColor,
                  blurRadius: 1,
                )
              ],
            ),
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 10.sp,
              radius: Radius.circular(10.sp),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        height: 200.h,
                        child: Center(
                          child: SizedBox(
                            height: 100.h,
                            width: 100.w,
                            child: const BusyLoader(),
                          ),
                        ),
                      ),
                    )
                  : checkIfThereIsAddress(addresss)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No Address Found!',
                              style: textStyle.subTitle,
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
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
                                  context.nav.pop();
                                  context.nav.pushNamed(
                                    Routes.addUserAddressScreen,
                                    arguments: null,
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Address'),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Stack(
                              children: [
                                AddressCard(
                                  userAddress: addresss!,
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  ShippingBillingResponse? addresss;

  Future<void> getAddress() async {
    ref
        .read(menuStateNotifierProvider.notifier)
        .getUserShippingAddresses()
        .then((address) {
      addresss = address;
    });
  }

  bool checkIfThereIsAddress(ShippingBillingResponse? address) {
    if (address?.number == null &&
        address?.address == null &&
        address?.email == null &&
        address?.fName == null) {
      return false;
    } else {
      return true;
    }
  }
}
