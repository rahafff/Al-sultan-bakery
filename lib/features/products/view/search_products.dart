// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/model/product_special.dart';
import 'package:grocerymart/features/home/view/widget/basic_product_card.dart';
import 'package:grocerymart/features/products/logic/product_provider.dart';
import 'package:grocerymart/features/products/model/review_model.dart';
import 'package:grocerymart/features/products/model/sort_product_by.dart';
import 'package:grocerymart/features/products/view/bottom_sheet_filter_prduct.dart';
import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/util/context_less_nav.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/custom_search_field.dart';

// ignore: must_be_immutable
class OwnProductView extends ConsumerStatefulWidget {
  const OwnProductView({
    super.key,
  });

  @override
  ConsumerState<OwnProductView> createState() => _OwnProductViewState();
}

class _OwnProductViewState extends ConsumerState<OwnProductView> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int count = 1;
  bool scrollLoading = false;

  bool isFiltered = false;


  SortProductBy? selectedSort;
  double? minPrice;
  double? maxPrice;
  int? _selectedStarCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getProducts(isScroll: false);
      scrollController.addListener(scrollListener);
    });
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      if (ref.watch(productNotifierProvider) == false) {
        scrollLoading = true;
        count++;
        getProducts(isScroll: true);
      }
    }
  }

  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(productNotifierProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 80.h,
          title: Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: CustomSearchField(
              searchController: searchController,
              hintText: S.of(context).searchProducts,
              onChanged: (value) {
                if (value!.isNotEmpty) {
                  _search();
                }
              },
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Future.delayed(const Duration(milliseconds: 200), () {
                  context.nav.pop();
                });
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          actions: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w).copyWith(bottom: 10),
              child: GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                      builder: (context) =>   BottomSheetFilterProduct(
                        onClearFilter: () => _clearFilter(),
                        onFilter: (min ,max,stars){
                          minPrice = min;
                          maxPrice = max;
                          _selectedStarCount = stars;

                          isFiltered = true;
                          count = 1;

                          scrollLoading = false;
                          getProducts(isScroll: false);
                        },

                        max: maxPrice,min: minPrice,
                        starCount: _selectedStarCount,

                      ),
                      isScrollControlled: false,shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                  ), context: context);
                },
                child: CircleAvatar(
                  radius: 25.r,
                  backgroundColor: isFiltered
                      ? colors(context).primaryColor
                      : colors(context).accentColor,
                  child: Icon(
                    Icons.tune,
                    color: isFiltered
                        ? colors(context).accentColor
                        : colors(context).primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: isLoading && !scrollLoading
            ? Center(
                child: SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: const BusyLoader(),
                ),
              )
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 10),
                      child: Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<SortProductBy>(
                          padding: EdgeInsetsDirectional.zero,
                          alignment: AlignmentDirectional.topEnd,
                          value: selectedSort,
                          isExpanded: false,
                          isDense: false,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              S.current.sortBy,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          items: SortProductBy.values
                              .map(
                                (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.getMessage(),
                                      style: TextStyle(fontSize: 12),
                                    )),
                              )
                              .toList(),
                          onChanged: (newVal) {
                            selectedSort = newVal;
                            setState(() {});

                            count = 1;

                            scrollLoading = false;
                            getProducts(isScroll: false);
                          },
                        )),
                      ),
                    ),
                    Expanded(
                      child: AnimationLimiter(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16.h,
                                  crossAxisSpacing: 16.w,
                                  childAspectRatio: 171 / 240),
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: MainProductCard(
                                  product: _products[index],
                                  cardColor: colors(context).accentColor,
                                ),
                              ),
                            ),
                          ),
                          itemCount: _products.length,
                        ),
                      ),
                    )
                  ],
                ),
              ),
        bottomNavigationBar: isLoading && scrollLoading
            ? const SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : const SizedBox(),
      ),
    );
  }

  final List<ProductResponse> _products = [];

  Future<void> getProducts({required bool isScroll}) async {
    await ref
        .read(productNotifierProvider.notifier)
        .getProducts(
            type: selectedSort?.value,
            search: searchController.text,
            count: count,
            minPrice: minPrice,
            maxPrice: maxPrice)
        .then((response) {
      if (!isScroll) {
        _products.clear();
      }
      _products.addAll(response.productList);
    });
  }

  _clearFilter(){
    minPrice = null;
    maxPrice = null;
    isFiltered= false;
    searchController.text = '';
    selectedSort = null;
    count = 1;
    scrollLoading = false;
    _selectedStarCount = null;
    getProducts(isScroll: false);
  }

  _search() {
    scrollLoading = false;
    count = 1;
    FocusScope.of(context).unfocus();
    if (searchController.text.isNotEmpty) {
      getProducts(isScroll: false);
    }
  }
}
