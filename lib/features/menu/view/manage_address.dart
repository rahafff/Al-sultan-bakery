import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/menu/logic/menu_repo.dart';
import 'package:grocerymart/features/menu/model/user_address.dart';
import 'package:grocerymart/features/menu/view/widgets/address_card.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/busy_loader.dart';

class ManageBillingAddressScreen extends ConsumerStatefulWidget {
  const ManageBillingAddressScreen({super.key});

  @override
  ConsumerState<ManageBillingAddressScreen> createState() =>
      _ManageAddressScreenState();
}

class _ManageAddressScreenState extends ConsumerState<ManageBillingAddressScreen> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final textStyle = AppTextStyle(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).manageAddress),
      ),
      body: FutureBuilder(
        future: ref.read(menuRepo).getUserShippingAddresses(),
        builder: (context, AsyncSnapshot<ShippingBillingResponse?> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                S.of(context).someThingWrong,
                style: textStyle.bodyText.copyWith(
                  color: AppStaticColor.blackColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final ShippingBillingResponse? userAddress = snapshot.data;
            return userAddress != null
                ? Stack(
                    children: [
                      AddressCard(
                        userAddress: userAddress,
                      ),
                      Positioned(
                        right: 14,
                        top: 16,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(50.w, 35.h),
                            foregroundColor: colors(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.sp),
                            ),
                            side: BorderSide(
                              color: colors(context).primaryColor ??
                                  AppStaticColor.primaryColor,
                            ),
                          ),
                          onPressed: () {
                            userAddress.isShipping = false;
                            context.nav
                                .pushNamed(
                              Routes.addUserAddressScreen,
                              arguments: userAddress,
                            )
                                .then((value) {
                              setState(() {});
                            });
                          },
                          child: Center(
                            child: Text(S.of(context).edit),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      'Opps user address not found!',
                      style: textStyle.subTitle,
                    ),
                  );
          }

          return _buildLoader(context);
        },
      ),
    );
  }

  _buildLoader(BuildContext context) {
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
  }
}
