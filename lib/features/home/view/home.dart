import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocerymart/config/app_color.dart';
import 'package:grocerymart/config/app_text_style.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/categories/logic/category_provider.dart';
import 'package:grocerymart/features/categories/model/responses/category_response.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/dashboard/logic/misc_providers.dart';
import 'package:grocerymart/features/home/logic/home_provider.dart';
import 'package:grocerymart/features/home/model/banner.dart';
import 'package:grocerymart/features/home/view/widget/category_tile.dart';
import 'package:grocerymart/features/home/view/widget/home_page_hero_slider.dart';
import 'package:grocerymart/features/home/view/widget/home_shimmer.dart';
import 'package:grocerymart/features/home/view/widget/recommended_widget.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/routes.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  Future<void> init() async {
    // getBanners();
    getRecommendedProducts();
    getCategories();
  }

  bool loader = true;
  bool isLoading = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    bool bannerLoading = ref.watch(homeStateNotifierProvider);
    bool categoryLoading = ref.watch(categoryStateNotifierProvider);
    return Scaffold(
      body: bannerLoading
          ? const HomeShimmerWidget()
          : Column(
              children: [
                SizedBox(child: _buildAppBar(context)),
                Flexible(
                  flex: 4,
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 55.h),
                    shrinkWrap: true,
                    children: [
                      bannerLoading
                          ? _builderLoader()
                          : HomePageHeroSlider(
                              banners: _banners,
                            ),
                      productLoading
                          ? _builderLoader()
                          : RecommendedWidget(
                              products: _products,
                            ),
                      categoryLoading
                          ? _builderLoader()
                          : _buildCategoriesWidget(),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Container _buildCategoriesWidget() {
    final textStyle = AppTextStyle(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
      padding: EdgeInsets.all(10.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: colors(context).accentColor ?? AppStaticColor.accentColor,
            blurRadius: 5,
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: AnimationLimiter(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).categories,
                  style: textStyle.subTitle,
                ),
                GestureDetector(
                  onTap: () {
                    ref.watch(homeTabControllerProvider).animateToPage(1,
                        duration: 200.miliSec, curve: Curves.easeInOutCubic);
                  },
                  child: Text(
                    S.of(context).viewAll,
                    style: textStyle.bodyText.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors(context).primaryColor),
                  ),
                ),
              ],
            ),
            GridView.count(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 78.w / 115.h,
              crossAxisCount: 4,
              children: List.generate(
                _categories.length,
                (index) => AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 4,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: CategoryTile(
                        category: _categories[index],
                        // catgoryList: _categories,
                        // index: index,
                        // fromShop: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return CustomAppBar(
      showNotifIcon: true,
      showBack: false,
      showSearchTextField: true,
      searchController: searchController,
      readOnly: true,
      onPressed: () {
        context.nav.pushNamed(Routes.ownProductScreen, arguments: _products);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.location_pin,
                color: colors(context).primaryColor,
              ),
              8.pw,
              ValueListenableBuilder(
                valueListenable:
                    Hive.box(AppHSC.deliveryAddressBox).listenable(),
                builder: (context, addressBox, _) {
                  ShippingBillingResponse? deliveryAddress;
                  Map<dynamic, dynamic>? address =
                      addressBox.get(AppHSC.deliveryAddress);
                  if (address != null) {
                    Map<String, dynamic> addressStringKey =
                        address.cast<String, dynamic>();
                    deliveryAddress = ShippingBillingResponse.fromJson(addressStringKey);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            S.of(context).deliverTo,
                            style: textStyle.bodyTextSmall
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                      deliveryAddress != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: Text(
                                '${deliveryAddress.country},${deliveryAddress.city},${deliveryAddress.state}, ${deliveryAddress.address}',
                                overflow: TextOverflow.ellipsis,
                                style: textStyle.bodyTextSmall
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  final List<BannerModel> _banners = [];
  final List<ProductResponse> _products = [];
  final List<CategoryResponse> _categories = [];

  bool productLoading = false;

  // Future<void> getBanners() async {
  //   await ref.read(homeStateNotifierProvider.notifier).getBanners().then(
  //     (banners) {
  //       _banners.addAll(banners);
  //       setState(() {});
  //     },
  //   );
  // }

  Future<void> getRecommendedProducts() async {
    setState(() {
      productLoading = true;
    });
    await ref
        .read(homeStateNotifierProvider.notifier)
        .getRecommendedProducts()
        .then((products) {
      setState(() {
        productLoading = false;
      });
      _products.addAll(products);
    });
  }

  Future<void> getCategories() async {
    ref
        .read(categoryStateNotifierProvider.notifier)
        .getCategories()
        .then(
      (response) {
        setState(() {});
        _categories.addAll(response.categories);
        setState(() {});
      },
    );
  }



  _builderLoader() {
    return Container(
      decoration: BoxDecoration(
        color: colors(context).accentColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: const Center(
        child: BusyLoader(
          size: 120,
        ),
      ),
    );
  }
}
