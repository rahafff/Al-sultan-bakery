import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/blogs/view/blogs_list_screen.dart';
import 'package:grocerymart/features/categories/views/all_categories_tab.dart';
import 'package:grocerymart/features/dashboard/logic/misc_providers.dart';
import 'package:grocerymart/features/dashboard/model/app_bottom_model.dart';
import 'package:grocerymart/features/dashboard/views/widget/app_bottom_nav_bar.dart';
import 'package:grocerymart/features/dashboard/views/widget/offline.dart';
import 'package:grocerymart/features/home/view/home.dart';
import 'package:grocerymart/features/menu/view/menu_tab.dart';
import 'package:grocerymart/gen/assets.gen.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/screen_wrapper.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<DashboardScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(homeTabControllerProvider);
    return ConnectivityWidgetWrapper(
      offlineWidget: const OfflineScreen(),
      child: ScreenWrapper(
        bottomNavigationBar: AppBottomNavbar(
          itemSvgs: [
            AppBottomModel(Assets.svg.iconHome, S.current.home),
            AppBottomModel( Assets.svg.iconGrid, S.current.category),
            AppBottomModel(  Assets.svg.newsPaper, S.current.blogs),
            AppBottomModel(  Assets.svg.iconMore, S.current.more),
          ],
          menuSvg: Assets.svg.iconBasket,
          selectedIndex: selectedIndex,
          onSelect: (index) {
            if (index != null) {
              setState(() {
                selectedIndex = index;
                pageController.animateToPage(index,
                    duration: 200.miliSec, curve: Curves.easeInOutCubic);
              });
            } else {
              context.nav.pushNamed(Routes.cartScreen);
            }
          },
        ),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          children: const [
            HomeScreen(),
            AllCategoriesTab(),
            BlogsListScreen(),
            MenuTab(),
          ],
        ),
      ),
    );
  }
}
