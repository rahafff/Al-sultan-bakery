// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/auth/logic/auth_provider.dart';
import 'package:grocerymart/features/menu/logic/menu_repo.dart';
import 'package:grocerymart/features/menu/model/pages_model.dart';
import 'package:grocerymart/features/menu/view/widgets/account_delete_dialog.dart';
import 'package:grocerymart/features/menu/view/widgets/custom_listtile.dart';
import 'package:grocerymart/features/menu/view/widgets/localization_selector.dart';
import 'package:grocerymart/features/menu/view/widgets/logout_dialog.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/service/hive_logic.dart';
import 'package:grocerymart/service/hive_model.dart';
import 'package:grocerymart/util/context_less_nav.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/misc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shimmer/shimmer.dart';

class MenuTab extends ConsumerStatefulWidget {
  const MenuTab({super.key});

  @override
  ConsumerState<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends ConsumerState<MenuTab> {
  final bool isLoading1 = true;
  // bool isLoggedIn = false;
 late User userInfo;

  @override
  void initState() {
    super.initState();
    // ref.read(hiveStorageProvider).getAuthToken().then((value) {
    //   isLoggedIn = value !=null;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    final isLoading = ref.watch(authStateNotifierProvider);
    return Scaffold(
      body: isLoading
          ? Center(
              child: SizedBox(
                width: 100.w,
                child: const BusyLoader(),
              ),
            )
          : ValueListenableBuilder<Box>(
              valueListenable: Hive.box(AppHSC.userBox).listenable(),
              builder: (context, userBox, _) {
                if(userBox.values.isNotEmpty) {
                  final Map<dynamic, dynamic> userData = userBox.values.first;
                  Map<String, dynamic> userInfoStringKeys =
                  userData.cast<String, dynamic>();
                  userInfo = User.fromMap(userInfoStringKeys);
                }else {
                  userInfo = User.empty();
                }
                return  Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        CustomListTile(
                          leadingIcon: CircleAvatar(
                            backgroundColor: colors(context).accentColor,
                            backgroundImage: CachedNetworkImageProvider(
                              userInfo.photo,
                            ),
                            radius: 38,
                          ),
                          title: Text(
                            userInfo.username,
                            style: textStyle.subTitle,
                          ),
                          subtitle:
                              Text(userInfo.email, style: textStyle.bodyText),
                          trailingIcon:userInfo.username.isNotEmpty ? InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (builder) => const LogoutDialog());
                            },
                            child: SvgPicture.asset(
                              Assets.svg.iconExit,
                              color: colors(context).primaryColor,
                              width: 40.w,
                            ),
                          ):SizedBox(width: 0,height: 0,),
                        ),
                        SizedBox(height: 75.h),

                        AnimationLimiter(
                          child: ListView.separated(
                            padding:EdgeInsets.zero,
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.h,
                                child: FadeInAnimation(
                                  child: ListTile(
                                    onTap: () {
                                      if(userInfo.username.isNotEmpty) {
                                        menuNavigator(
                                          index: index,
                                          userInfo: userInfo,
                                          context: context);
                                      }else {
                                        context.nav.pushNamed(Routes.login);
                                      }

                                    },
                                    visualDensity:
                                        const VisualDensity(vertical: -4),
                                    title: Text(
                                      getList(context)[index].title,
                                      style: textStyle.subTitle.copyWith(
                                        fontSize: 16.sp,
                                        color: colors(context).bodyTextColor,
                                      ),
                                    ),
                                    subtitle:userInfo.username.isEmpty?
                                    Text(S.current.loginFirst,style: textStyle.buttonText.copyWith(
                                      fontSize: 10.sp,
                                      color: AppStaticColor.redColor,
                                    ) ) :const SizedBox(width: 0,height: 0,),
                                    leading: SvgPicture.asset(
                                      getList(context)[index].icon,
                                      width: 30.sp,
                                      color: colors(context).bodyTextColor,
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20.sp,
                                      color: colors(context).bodyTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            itemCount: getList(context).length,
                            separatorBuilder: (context, index) => Divider(
                              indent: 20,
                              color: colors(context).bodyTextColor,
                            ),
                          ),
                        ),
                        Divider(
                          indent: 20,
                          color: colors(context).bodyTextColor,
                        ),
                        ///pages
                        FutureBuilder(
                          future: ref.read(menuRepo).getAllPages(),
                          builder: ((context, AsyncSnapshot<List<PagesModel>> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  S.of(context).someThingWrong,
                                  style: textStyle.subTitle,
                                ),
                              );
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              final List<PagesModel>  details = snapshot.data ?? [];

                              return ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: details.length,
                                itemBuilder: (context, index) => ListTile(
                                  onTap: () {
                                    context.nav.pushNamed(Routes.pageDetails
                                        ,arguments: PageDetailsArguments(pageId: details[index].id ?? -1, title: details[index].title ?? ''));

                                  },
                                  visualDensity:
                                  const VisualDensity(vertical: -4),
                                  title: Text(
                                    details[index].title ?? '',
                                    style: textStyle.subTitle.copyWith(
                                      fontSize: 16.sp,
                                      color: colors(context).bodyTextColor,
                                    ),
                                  ),
                                  leading: SvgPicture.asset(Assets.svg.iconPrivacy,
                                    width: 30.sp,
                                    color: colors(context).bodyTextColor,
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20.sp,
                                    color: colors(context).bodyTextColor,
                                  ),
                                ),
                                separatorBuilder: (context, index) => Divider(
                                  indent: 20,
                                  color: colors(context).bodyTextColor,
                                ),

                              );
                            }
                            return _buildLoader(context);
                          }),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 165.h,
                      left: 20.w,
                      right: 20,
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                              valueListenable:
                                  Hive.box(AppHSC.appSettingsBox).listenable(),
                              builder: (context, box, _) {
                                final isDarkTheme = box.get(AppHSC.isDarkTheme);

                                return LiteRollingSwitch(
                                  //initial value
                                  width: 120,
                                  textOnColor: colors(context).accentColor ??
                                      AppStaticColor.accentColor,
                                  textOffColor: colors(context).primaryColor ??
                                      AppStaticColor.primaryColor,
                                  value: isDarkTheme ?? false,
                                  textOn: S.of(context).dark,
                                  textOff: S.of(context).light,
                                  colorOn: colors(context).primaryColor ??
                                      AppStaticColor.accentColor,
                                  colorOff: AppStaticColor.blackColor,
                                  iconOn: Icons.dark_mode,
                                  iconOff: Icons.dark_mode,
                                  textSize: 16.0,
                                  onTap: () {},
                                  onDoubleTap: () {},
                                  onSwipe: () {},
                                  onChanged: (bool isDark) {
                                    ref
                                        .read(hiveStorageProvider)
                                        .isDarkTheme(value: isDark);
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              width: 140.w,
                              height: 60.h,
                              child: LocaLizationSelector(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )  ;

              },
            ),
    );
  }

  void menuNavigator({
    required int index,
    required User? userInfo,
    required BuildContext context,
  }) {
    switch (index) {
      case 0:
        context.nav.pushNamed(Routes.profileScreen, arguments: userInfo);
        break;
      case 1:
        context.nav.pushNamed(Routes.myOrdersScreen);
        break;
      case 2:
        context.nav.pushNamed(Routes.manageShippingAddressScreen);
        break;
      case 3:
        context.nav.pushNamed(Routes.manageBillingAddressScreen);
        break;

      // case 4:
      //   context.nav.pushNamed(Routes.privacyPolicyScreen);
      //   break;
      // case 5:
      //   context.nav.pushNamed(Routes.termsAndConditionsScreen);
      //   break;
      // case 6:
      //   context.nav.pushNamed(Routes.aboutUsScreen);
      // case 4:
      //   showDialog(
      //     context: context,
      //     builder: (builder) => const DeleteAccountDialog(),
      //   );
      //   break;
      default:
        // Handle the default case if needed
        break;
    }
  }

  Widget buildHeaderShimmer() {
    return SizedBox(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade400,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue),
                width: 100,
              ),
            ),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade100,
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 10.h,
                        width: 80.w,
                        color: AppStaticColor.grayColor,
                      ),
                      SizedBox(height: 18.h),
                      Container(
                        height: 10.h,
                        width: 200.w,
                        color: AppStaticColor.grayColor,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Menu> getList(BuildContext context) {
    return [
      Menu(icon: Assets.svg.iconUser, title: S.of(context).profile),
      Menu(icon: Assets.svg.iconMyOrder, title: S.of(context).myorder),
      Menu(
          icon: Assets.svg.iconManageAddress,
          title: S.of(context).manageShippingAddress),
      Menu(
          icon: Assets.svg.iconManageAddress,
          title: S.of(context).manageBillingAddress),
      // Menu(icon: Assets.svg.iconSupport, title: S.of(context).privacyPolicy),
      // Menu(icon: Assets.svg.iconTerms, title: S.of(context).termsConditions),
      // Menu(icon: Assets.svg.iconPrivacy, title: S.of(context).aboutUs),
      // Menu(icon: Assets.svg.delete, title: S.of(context).deleteAccount),
    ];
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

  // String imageUrl =
  //     "https://images.rawpixel.com/image_png_300/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcm0zMjgtczc3LXRvbmctMDZhXzIucG5n.png";
}

class Menu {
  String icon;
  String title;
  Menu({
    required this.icon,
    required this.title,
  });
}
class PageDetailsArguments {
  String title;
  int pageId;
  PageDetailsArguments({
    required this.pageId,
    required this.title,
  });
}