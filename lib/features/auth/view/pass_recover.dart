import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/auth/logic/auth_provider.dart';
import 'package:grocerymart/features/auth/view/verify_otp.dart';
import 'package:grocerymart/features/auth/view/widget/build_textfield.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/context_less_nav.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/buttons/full_width_button.dart';

class PassRecoverScreen extends ConsumerWidget {
  PassRecoverScreen({super.key});
  final TextEditingController contactController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = AppTextStyle(context);
    bool isLoading = ref.watch(authStateNotifierProvider);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: FormBuilder(
          key: _formkey,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.passwordRecover.image(width: 80.w),
                  SizedBox(height: 40.h),
                  Text(
                    S.of(context).recoverPassword,
                    style: AppTextStyle(context).title,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    S.of(context).passRecoverDes,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30.h),
                  CustomTextFormField(
                    focusNode: focusNode,
                    name: 'Phone',
                    hintText: S.of(context).emialOrPhone,
                    controller: contactController,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 40.h),
                  SizedBox(
                    height: 50.h,
                    child: isLoading
                        ? const Center(
                            child: BusyLoader(),
                          )
                        : AppTextButton(
                            title: S.of(context).recoverPassword,
                            onTap: () async {
                              if (_formkey.currentState!.validate())  {
                                await ref
                                    .read(authStateNotifierProvider.notifier)
                                    .changePassword(
                                      email: contactController.text.trim(),
                                    )
                                    .then((response) async {
                                  if (response.isSuccess) {
                                    final nav = context.nav;
                                    await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(S.current.message),
                                      content: Text(response.message),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            S.current.okay,
                                            style: textStyle.subTitle.copyWith(
                                                fontSize: 16.sp,
                                                color: colors(context).primaryColor),
                                          ),
                                          onPressed: () {
                                            nav.pushNamedAndRemoveUntil(
                                              Routes.login,
                                                  (route) => false,
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                    );
                                  }
                                });
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
