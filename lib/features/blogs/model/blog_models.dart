import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/features/blogs/model/category_news_response.dart';

class BlogModel {
  // final int total;
  final List<BlogResponse> blogList;
  BlogModel({
    // required this.total,
    required this.blogList,
  });
}

class BlogCategoryModel {
  // final int total;
  final List<NewsCategoryResponse> categories;
  BlogCategoryModel({
    // required this.total,
    required this.categories,
  });
}

class BlogDetailsModel {
  final int id;
  final String title;
  final String date;
  final String image;
  final String content;
  final NewsCategoryResponse categoryModel;

  BlogDetailsModel(
      {required this.id,
      required this.date,
      required this.title,
      required this.image,
      required this.content,
      required this.categoryModel});
}
