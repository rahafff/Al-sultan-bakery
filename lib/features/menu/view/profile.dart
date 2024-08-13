import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_input_decor.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/menu/logic/menu_provider.dart';
import 'package:grocerymart/features/menu/model/update_profile.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/service/hive_model.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/buttons/full_width_button.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final User userInfo;
  const ProfileScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    setUserInfo();
  }

  final List<FocusNode> fNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? image;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(menuStateNotifierProvider);
    final textStyle = AppTextStyle(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).profile),
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.h),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: colors(context).accentColor,
                    backgroundImage: image != null
                        ? FileImage(File(image!.path))
                        : CachedNetworkImageProvider(widget.userInfo.photo)
                            as ImageProvider,
                    radius: 38,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        await pickImage().then((pickedImage) {
                          setState(() {
                            image = File(pickedImage!.path);
                          });
                        });
                      },
                      child: CircleAvatar(
                        radius: 16.sp,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: colors(context).primaryColor,
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 18.sp,
                              color: AppStaticColor.accentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                widget.userInfo.username,
                style: textStyle.subTitle,
              ),
              SizedBox(height: 5.h),
              Text(
                widget.userInfo.email,
                style: textStyle.bodyText,
              ),
              SizedBox(height: 10.h),
              Divider(
                height: 3.h,
                color: colors(context).bodyTextColor,
              ),
              SizedBox(height: 20.h),
              FormBuilder(
                key: _formkey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: AnimationLimiter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: AnimationConfiguration.toStaggeredList(
                        childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0, child: widget),
                        children: [
                          buildTextFieldTitle(
                            titleName: S.of(context).firstName,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[0],
                            name: 'First Name',
                            decoration:
                            AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).firstName,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()],
                            ),
                            controller: fNameController,
                          ),

                          20.ph,
                          buildTextFieldTitle(
                            titleName: S.of(context).lastName,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[1],
                            name: 'Last Name',
                            decoration:
                            AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).lastName,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()],
                            ),
                            controller: lNameController,
                          ),



                          20.ph,
                          buildTextFieldTitle(
                            titleName: S.of(context).username,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[2],
                            name: 'User Name',
                            decoration:
                                AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).username,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()],
                            ),
                            controller: userNameController,
                          ),

                          20.ph,
                          buildTextFieldTitle(
                            titleName: S.of(context).phoneNumber,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[3],
                            name: 'phone',
                            decoration:
                                AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).phoneNumber,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()],
                            ),
                            controller: phoneController,
                          ),

                          ///country
                          20.ph,
                          buildTextFieldTitle(
                            titleName: S.of(context).country,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[4],
                            name: 'country',
                            decoration:
                                AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).country,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            controller: countryController,
                          ),

                          ///city

                          20.ph,
                          buildTextFieldTitle(
                            titleName: S.of(context).city,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[5],
                            name: 'city',
                            decoration:
                                AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).city,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            controller: cityController,
                          ),

                          ///state
                          20.ph,
                          buildTextFieldTitle(
                            titleName: S.of(context).state,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[6],
                            name: 'state',
                            decoration:
                                AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).state,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            controller: stateController,
                          ),

                          ///address
                          20.ph,
                          buildTextFieldTitle(
                            titleName: S.of(context).fullAddress,
                            textStyle: textStyle,
                          ),
                          12.ph,
                          FormBuilderTextField(
                            focusNode: fNodes[7],
                            name: 'full Address',
                            decoration:
                                AppInputDecor.loginPageInputDecor.copyWith(
                              hintText: S.of(context).fullAddress,
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            controller: addressController,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 100.h,
        child: isLoading
            ? const BusyLoader()
            : Column(
                children: [
                  Divider(
                    height: 10.h,
                    color: AppStaticColor.grayColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: AppTextButton(
                      onTap: () {
                        final UpdateProfile profileInfo = UpdateProfile(
                          userName: userNameController.text.trim(),
                          address: addressController.text.trim(),
                          city: cityController.text.trim(),
                          country: countryController.text.trim(),
                          state: stateController.text.trim(),
                          phone: phoneController.text.trim(),
                          firstName: fNameController.text.trim(),
                          lastName: lNameController.text.trim()
                        );
                        ref
                            .read(menuStateNotifierProvider.notifier)
                            .updateProfileInfo(
                                profileInfo: profileInfo, file: image)
                            .then((isSuccess) {
                          if (isSuccess != null) {
                            return EasyLoading.showSuccess(
                              S.of(context).profileUS,
                            );
                          }
                        });
                      },
                      height: 50.h,
                      title: S.of(context).updateProfile,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  RichText buildTextFieldTitle(
      {required String titleName, required AppTextStyle textStyle}) {
    final textStyle = AppTextStyle(context);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: titleName,
            style: textStyle.bodyText,
          ),
          TextSpan(
            text: titleName == 'Email' ? '' : ' *',
            style: textStyle.bodyText.copyWith(
              color: colors(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<XFile?> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) return image;
    return null;
  }

  void setUserInfo() {
    setState(() {
      userNameController.text = widget.userInfo.username;
      cityController.text = widget.userInfo.city;
      stateController.text = widget.userInfo.state;
      addressController.text=widget.userInfo.address;
      countryController.text=widget.userInfo.country;
      phoneController.text = widget.userInfo.number;
    });
  }

  // final String imageUrl =
  //     "https://images.rawpixel.com/image_png_300/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcm0zMjgtczc3LXRvbmctMDZhXzIucG5n.png";
}
