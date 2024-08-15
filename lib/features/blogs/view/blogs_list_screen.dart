import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grocerymart/config/theme.dart';
import 'package:grocerymart/features/blogs/blog-logic/blog_provider.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/features/blogs/model/category_news_response.dart';
import 'package:grocerymart/features/blogs/view/widget/news_card.dart';

import 'package:grocerymart/generated/l10n.dart';
import 'package:grocerymart/widgets/busy_loader.dart';
import 'package:grocerymart/widgets/custom_app_bar.dart';

class BlogsListScreen extends ConsumerStatefulWidget {
  const BlogsListScreen({super.key});

  @override
  ConsumerState<BlogsListScreen> createState() => _BlogsListScreenState();
}

class _BlogsListScreenState extends ConsumerState<BlogsListScreen> {
  int page = 1;
  int totalShop = 0;
  int limit = 6;
  bool scrollLoading = false;
  NewsCategoryResponse? selectedCategory;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    getBlogCategoryList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getBlogList();
      _scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      if (_nearByShop.length < totalShop &&
          ref.watch(blogNotifierProvider) == false) {
        scrollLoading = true;
        page++;
        getBlogList();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(blogNotifierProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              title: S.of(context).ourBlogs,
              showNotifIcon: false,
              showBack: false,
              centerTitle: false,
              trails: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<NewsCategoryResponse>(
                    alignment: AlignmentDirectional.topEnd,
                    value: selectedCategory,
                    isExpanded: false,
                    isDense: false,
                    hint: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(S.current.categories,style: TextStyle(fontSize: 12),),
                    ),
                    items: categories
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text(e.name,style: TextStyle(fontSize: 12),)),
                        )
                        .toList(),
                    onChanged: (newVal) {
                      _scrollController.animateTo(0.0,
                          duration: const Duration(
                            seconds: 1,
                          ),
                          curve: Easing.emphasizedDecelerate);
                      selectedCategory = newVal ;
                      _nearByShop.clear();
                      getBlogList();
                    },
                    ))
              ],
            ),
            Expanded(
              child: Container(
                child: (isLoading) && scrollLoading == false
                    ? Center(
                        child: Container(
                          constraints:
                              BoxConstraints(maxHeight: 120.h, minWidth: 100.w),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: colors(context).accentColor),
                          width: 200,
                          child: const BusyLoader(
                            size: 120,
                          ),
                        ),
                      )
                    : AnimationLimiter(
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(bottom: 100.h),
                          itemCount: _nearByShop.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _nearByShop.length) {
                              if (isLoading) {
                                return const ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: NewsCard(
                                      shop: _nearByShop[index],
                                      cardColor: colors(context).accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<BlogResponse> _nearByShop = [];
  final List<NewsCategoryResponse> categories = [];
  // bool positionLoader = false;

  Future<void> getBlogList() async {
    await ref
        .read(blogNotifierProvider.notifier)
        .getBlogList(
          categoryId: selectedCategory?.id ?? 3,
          count: limit,
          page: page,
        )
        .then((response) {
      _nearByShop.addAll(response.blogList);
    });
  }

  Future<void> getBlogCategoryList() async {
    await ref
        .read(blogNotifierProvider.notifier)
        .getNewsCategory(
          count: limit,
          page: page,
        )
        .then((response) {
      categories.addAll(response.categories);
    });
  }
}
