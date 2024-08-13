import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/blogs/model/blog_models.dart';
import 'blog_repo.dart';

class BlogStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  BlogStateNotifier(this.ref) : super(false);

  Future<BlogModel> getBlogList(
      {String? latitude,
      String? longitude,
      int? categoryId,
      String? shop,
      int? count,
      int? page}) async {
    state = true;
    try {
      BlogModel shopList = await ref.read(blogRepo).getBlogList(
            // latitude: latitude,
            // longitude: longitude,
            categoryId: categoryId,
            // shop: shop,
            count: count,
            page: page,
          );
      state = false;
      return shopList;
    } catch (e) {
      state = false;
      if (kDebugMode) {
        print(e);
      }
      return BlogModel( blogList: []);
    } finally {
      state = false;
    }
  }

  Future<BlogCategoryModel> getNewsCategory({
    required int? count,
    required int? page,
  }) async {
    // state = true;
    try {
      BlogCategoryModel response = await ref.read(blogRepo).getNewsCategories(count: count,page: page);
      // state = false;
      return response;
    } catch (e) {
      // state = false;
      if (kDebugMode) {
        print(e);
      }
      return BlogCategoryModel(categories: []);
    } finally {
      // state = false;
    }
  }
}
