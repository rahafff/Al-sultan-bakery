import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/config/parameter_constants.dart';
import 'package:grocerymart/features/categories/model/category_model.dart';
import 'package:grocerymart/features/categories/model/responses/category_response.dart';
import 'package:grocerymart/utils/api_client.dart';

class CategoryRepo {
  final Ref ref;
  CategoryRepo(this.ref);

  Future<CategoryModel> getCategories(
      ) async {
    Map<String, String> queryParams = {};
      queryParams['limit'] = ParameterConstants.allItemsLimit;
     queryParams['page'] = '1';
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstant.getCategories, query: queryParams);
    final List<dynamic> categoriesData = response.data['data'];
    final List<CategoryResponse> categoriesList =
        categoriesData.map((value) => CategoryResponse.fromJson(value)).toList();
    return CategoryModel(
      categories: categoriesList,
    );
  }
}

final categoryRepo = Provider((ref) => CategoryRepo(ref));
