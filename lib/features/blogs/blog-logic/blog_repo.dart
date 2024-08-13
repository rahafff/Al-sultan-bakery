import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/features/blogs/model/blog_details_response.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/features/blogs/model/category_news_response.dart';
import 'package:grocerymart/features/blogs/model/blog_models.dart';
import 'package:grocerymart/utils/api_client.dart';

class BlogRepo {
  final Ref ref;
  BlogRepo(this.ref);

  Future<BlogModel> getBlogList({
    // String? latitude,
    // String? longitude,
    int? categoryId,
    int? count,
    int? page,
    // String? shop,
  }) async {
    Map<String, String> queryParams = {};
    if (categoryId != null) queryParams['catId'] = categoryId.toString();
    if (count != null) queryParams['limit'] = count.toString();
    if (page != null) queryParams['page'] = page.toString();

    final response = await ref
        .read(apiClientProvider)
        .get(AppConstant.getBlogList, query: queryParams);
    final List<dynamic> shopsData = response.data['data'];
    final List<BlogResponse> blogList =
        shopsData.map((shop) => BlogResponse.fromJson(shop)).toList();

    return BlogModel(blogList: blogList);
  }

  Future<BlogCategoryModel> getNewsCategories({
    required int? count,
    required int? page,
  }) async {
    Map<String, String> queryParams = {};
    // queryParams['shop_id'] = shopId.toString();
    if (count != null) queryParams['limit'] = count.toString();
    if (page != null) queryParams['page'] = page.toString();

    final response = await ref
        .read(apiClientProvider)
        .get(AppConstant.getNewsCategoriesList, query: queryParams);

    final List<dynamic> reviewData = response.data['data'];

    final List<NewsCategoryResponse> categories = reviewData
        .map((review) => NewsCategoryResponse.fromJson(review))
        .toList();
    return BlogCategoryModel(categories: categories);
  }

  Future<BlogDetailsModel> getBlogDetails({
    required int? blogId,
  }) async {
    Map<String, String> queryParams = {};
    if (blogId != null) queryParams['blog_id'] = blogId.toString();

    final response = await ref
        .read(apiClientProvider)
        .get(AppConstant.getBlogDetails, query: queryParams);

    var reviewData = response.data['data'];

    final BlogDetailsResponse details =
        BlogDetailsResponse.fromJson(reviewData);

    return BlogDetailsModel(
        image: details.image,
        date: details.date,
        id: details.id,
        title: details.title,
        content: details.content,categoryModel:details.newsCategory);
  }
}

final blogRepo = Provider((ref) => BlogRepo(ref));
