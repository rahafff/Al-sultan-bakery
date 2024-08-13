import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/auth/logic/auth_provider.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/service/hive_logic.dart';
import 'package:grocerymart/util/context_less_nav.dart';

class DeleteAccountDialog extends ConsumerWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isLoading = ref.watch(authStateNotifierProvider);
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 20.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.sp),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: colors(context).accentColor ?? AppStaticColor.accentColor,
              blurRadius: 2.r,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Assets.images.warning.image(width: 65.w),
              SizedBox(height: 20.h),
              Text(
                S.of(context).areYouSure,
                style: AppTextStyle(context).title.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).accountDeleteDes,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      context.nav.pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          colors(context).primaryColor ??
                              AppStaticColor.primaryColor),
                      foregroundColor: WidgetStateProperty.all<Color>(
                        AppStaticColor.accentColor,
                      ),
                      minimumSize: WidgetStateProperty.all(
                        Size(80.w, 35.h),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Text(
                      S.of(context).cancel,
                      style: AppTextStyle(context).bodyText.copyWith(
                            color: AppStaticColor.whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          height: 40.h,
                          width: 80.w,
                          child: TextButton(
                            onPressed: () async {
                              await ref
                                  .read(authStateNotifierProvider.notifier)
                                  .logout()
                                  .then((isSuccess) {
                                if (isSuccess) {
                                  ref.read(hiveStorageProvider).removeAllData();
                                  context.nav.pushNamedAndRemoveUntil(
                                    Routes.login,
                                    (route) => false,
                                  );
                                }
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                AppStaticColor.accentColor,
                              ),
                              minimumSize: MaterialStateProperty.all(
                                Size(80.w, 35.h),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 2.sp,
                                      color: AppStaticColor.primaryColor),
                                  borderRadius: BorderRadius.circular(
                                    20.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                S.of(context).okay,
                                style: AppTextStyle(context).bodyText.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
