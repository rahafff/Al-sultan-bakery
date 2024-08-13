import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/blogs/blog-logic/blog_repo.dart';
import 'package:grocerymart/features/blogs/model/blog_models.dart';
import 'package:grocerymart/features/blogs/model/category_news_response.dart';

class BlogDetailsStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  BlogDetailsStateNotifier(this.ref) : super(false);

  Future<BlogDetailsModel> getBlogDetails({
    required int? blogId,
  }) async {
    state = true;
    try {
      BlogDetailsModel response =
          await ref.read(blogRepo).getBlogDetails(blogId: blogId);
      state = false;
      return response;
    } catch (e) {
      state = false;
      if (kDebugMode) {
        print(e);
      }
      return BlogDetailsModel(
          content: '', title: '', id: -1, date: '', image: '',categoryModel: NewsCategoryResponse(-1,''));
    } finally {
      state = false;
    }
  }
}
