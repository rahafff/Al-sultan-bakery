import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grocerymart/config/app_input_decor.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/menu/logic/menu_provider.dart';
import 'package:grocerymart/features/menu/model/user_address.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/service/hive_logic.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/buttons/full_width_button.dart';

class AddUserAddressScreen extends ConsumerStatefulWidget {
  final ShippingBillingResponse? userAddress;

  const AddUserAddressScreen({
    super.key,
    required this.userAddress,

  });

  @override
  ConsumerState<AddUserAddressScreen> createState() =>
      _AddUserAddressScreenState();
}

class _AddUserAddressScreenState extends ConsumerState<AddUserAddressScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  final TextEditingController fnameController = TextEditingController();
  final TextEditingController lnameController = TextEditingController();

  final TextEditingController phoneNumController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController countryCodeController = TextEditingController();

  final TextEditingController countryController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  // final List<FocusNode> fNodes = [
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode()
  // ];

  @override
  void initState() {
    super.initState();

    if (widget.userAddress != null) {
      fnameController.text = widget.userAddress?.fName ?? '';
      lnameController.text = widget.userAddress?.lName ?? '';
      phoneNumController.text = widget.userAddress?.number ?? '';
      emailController.text = widget.userAddress?.email ?? '';
      countryCodeController.text = widget.userAddress?.countryCode ?? '';


      countryController.text = widget.userAddress?.country ?? '';
      cityController.text = widget.userAddress?.city ?? '';
      stateController.text = widget.userAddress?.state ?? '';
      addressController.text = widget.userAddress?.address ?? '';

    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userAddress?.isShipping);

    print('sssssssssssssssssssss');

    bool isLoading = ref.watch(menuStateNotifierProvider);
    final textStyle = AppTextStyle(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).addNewAddress),
        ),
        body: FormBuilder(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
            ),
            child: SingleChildScrollView(
              child: AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        )),
                    children: [
                      SizedBox(height: 10.h),
                      buildTextField(
                        name: S.of(context).firstName,
                        hintText: S.of(context).enterName,

                        textInputType: TextInputType.text,
                        controller: fnameController,
                        width: double.infinity,
                      ),
                      14.ph,
                      buildTextField(
                        name: S.of(context).lastName,
                        hintText: S.of(context).enterName,

                        textInputType: TextInputType.text,
                        controller: lnameController,
                        width: double.infinity,
                      ),
                      14.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildTextField(
                            name: S.of(context).countryCode,
                            hintText: S.of(context).enterPhone,

                            textInputType: TextInputType.phone,
                            controller: countryCodeController,
                            width: 100,
                          ),
                          buildTextField(
                            name: S.of(context).phoneNumber,
                            hintText: S.of(context).enterPhone,

                            textInputType: TextInputType.phone,
                            controller: phoneNumController,
                            width: 250.h,
                          ),
                        ],
                      ),
                      14.ph,
                      buildTextField(
                        name: S.of(context).email,
                        hintText: S.of(context).email,

                        textInputType: TextInputType.text,
                        controller: emailController,
                        width: double.infinity,
                      ),
                      14.ph,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          buildTextField(
                            name: S.of(context).country,
                            hintText: S.of(context).enterFlatNo,

                            textInputType: TextInputType.number,
                            controller: countryController,
                            width: null,
                          ),
                          buildTextField(
                            name: S.of(context).city,
                            hintText: S.of(context).enterPC,

                            textInputType: TextInputType.text,
                            controller: cityController,
                            width: null,
                          ),
                          buildTextField(
                            name: S.of(context).state,
                            hintText: S.of(context).state,
                            textInputType: TextInputType.text,
                            controller: stateController,
                            width: null,
                          ),
                        ],
                      ),
                      14.ph,
                      buildTextField(
                        name: S.of(context).addressLine1,
                        hintText: S.of(context).enterAddressLine1,
                        textInputType: TextInputType.text,
                        controller: addressController,
                        width: double.infinity,
                      ),
                      14.ph,


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20),
          child: isLoading
              ? SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: const BusyLoader(),
                )
              : AppTextButton(
                  height: 50.h,
                  onTap: () {
                    performSaveAddress();
                  },
                  title: S.of(context).save,
                ),
        ),
      ),
    );
  }


  Future<void> performSaveAddress() async {
    if (_formkey.currentState!.validate()) {
      AddressRequest userAddress = AddressRequest(
        firstName: fnameController.text,
        lastName: lnameController.text,
        email: emailController.text,
        state: stateController.text,
        country: countryController.text,
        city: cityController.text,
        address: addressController.text,
        phone: phoneNumController.text,
        countryCode: countryCodeController.text
      );
      final nav = context.nav;
      String? message = await ref
          .read(menuStateNotifierProvider.notifier)
          .manageUserAddress(userAddress: userAddress,isShipping: widget.userAddress?.isShipping ?? true);
      nav.pop(true);
      if(widget.userAddress?.isShipping ?? true){
        ref
            .read(hiveStorageProvider)
            .saveDeliveryShippingAddress(
            userAddress: ShippingBillingResponse(
                fName: userAddress.firstName,
                lName: userAddress.lastName,
                number:userAddress.phone,
                email: userAddress.email,
                state: userAddress.state,
                country: userAddress.country,
                city: userAddress.city,
                address: userAddress.address,
                countryCode: userAddress.countryCode ));
      }
      else {
        ref
            .read(hiveStorageProvider)
            .saveDeliveryBillingAddress(
            userAddress: ShippingBillingResponse(
                fName: userAddress.firstName,
                lName: userAddress.lastName,
                number:userAddress.phone,
                email: userAddress.email,
                state: userAddress.state,
                country: userAddress.country,
                city: userAddress.city,
                address: userAddress.address,
                countryCode: userAddress.countryCode ));
      }
      EasyLoading.showSuccess(message!);
    } else {
      return;
    }
  }

  Widget buildTextField({
    required String name,
    // required FocusNode focusNode,
    required String hintText,
    required TextInputType textInputType,
    required TextEditingController controller,
    required double? width,
  }) {
    final textStyle = AppTextStyle(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: textStyle.bodyTextSmall.copyWith(fontWeight: FontWeight.w500),
        ),
        14.ph,
        SizedBox(
          width: width ?? 114.w,
          child: FormBuilderTextField(
            // focusNode: focusNode,
            name: name,
            decoration: AppInputDecor.loginPageInputDecor.copyWith(
              hintText: hintText,
            ),
            keyboardType: textInputType,
            textInputAction: TextInputAction.next,
            validator: FormBuilderValidators.compose(
              [FormBuilderValidators.required()],
            ),
            controller: controller,
          ),
        ),
      ],
    );
  }

  // Widget buildAddressTag() {
  //   final textStyle = AppTextStyle(context);
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         S.of(context).addressTag,
  //         style: textStyle.bodyTextSmall.copyWith(fontWeight: FontWeight.w500),
  //       ),
  //       14.ph,
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: addressTags.asMap().entries.map(
  //           (entry) {
  //             int index = entry.key;
  //             String tag = entry.value;
  //             return InkWell(
  //               borderRadius: BorderRadius.circular(8.sp),
  //               onTap: () {
  //                 setState(() {
  //                   activeIndex = index;
  //                   addressTag = tag;
  //                 });
  //               },
  //               child: Container(
  //                 height: 50.h,
  //                 width: 110.w,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(8.sp),
  //                   border: Border.all(
  //                     color: activeIndex == index
  //                         ? colors(context).primaryColor ??
  //                             AppStaticColor.primaryColor
  //                         : colors(context).bodyTextColor!.withOpacity(0.5),
  //                   ),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     tag.toUpperCase(),
  //                     style: textStyle.bodyTextSmall.copyWith(
  //                         color: activeIndex == index
  //                             ? colors(context).primaryColor ??
  //                                 AppStaticColor.primaryColor
  //                             : colors(context).bodyTextColor,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         ).toList(),
  //       ),
  //     ],
  //   );
  // }
}
