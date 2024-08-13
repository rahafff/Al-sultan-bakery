import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/model/banner.dart';
import 'package:grocerymart/features/home/model/product.dart';
import 'package:grocerymart/utils/api_client.dart';

class HomeRepo {
  final Ref ref;
  HomeRepo(this.ref);

  Future<List<BannerModel>> getBanners() async {
    final response =
        await ref.read(apiClientProvider).get(AppConstant.getBanners);
    final List<dynamic> bannersData = response.data['data']['banners'];
    final List<BannerModel> bannerList =
        bannersData.map((banner) => BannerModel.fromMap(banner)).toList();
    return bannerList;
  }

  Future<List<ProductResponse>> getRecommendedProducts() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstant.getRecommendedProducts,
        );
    final List<dynamic> productsData =
        response.data['data'];
    print(productsData);
    print('productsData');
    final List<ProductResponse> recommendedProducts =
        productsData.map((product) => ProductResponse.fromJson(product)).toList();
    return recommendedProducts;
  }
}

final homeRepo = Provider((ref) => HomeRepo(ref));
