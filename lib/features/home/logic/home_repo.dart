import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/model/banner.dart';
import 'package:grocerymart/features/home/model/home_feature.dart';
import 'package:grocerymart/features/home/model/home_news.dart';
import 'package:grocerymart/features/home/model/product_special.dart';
import 'package:grocerymart/features/home/model/testimonial_response.dart';
import 'package:grocerymart/utils/api_client.dart';

class HomeRepo {
  final Ref ref;
  HomeRepo(this.ref);

  // Future<List<BannerModel>> getBanners() async {
  //   final response =
  //       await ref.read(apiClientProvider).get(AppConstant.getBanners);
  //   final List<dynamic> bannersData = response.data['data']['banners'];
  //   final List<BannerModel> bannerList =
  //       bannersData.map((banner) => BannerModel.fromMap(banner)).toList();
  //   return bannerList;
  // }
  Future<HomeNews> getHomeNews() async {
    final response = await ref.read(apiClientProvider).get(
      AppConstant.getHomeNews,
    );
    final  dynamic  productsData = response.data['data'];
    print(productsData);
    print('productsData');
    final HomeNews recommendedProducts = HomeNews.fromJson(productsData);
    return recommendedProducts;
  }

  Future<ProductSpecial> getRecommendedProducts() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstant.getRecommendedProducts,
        );
    final  dynamic  productsData = response.data['data'];
    print(productsData);
    print('productsData');
    final ProductSpecial recommendedProducts = ProductSpecial.fromJson(productsData);
    return recommendedProducts;
  }



  Future<HomeFeature> getHomeFeature() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstant.getFeature,
        );
    final  dynamic  productsData = response.data['data'];
    final HomeFeature recommendedProducts = HomeFeature.fromJson(productsData);
    return recommendedProducts;
  }

  Future<TestimonialResponse> getHomeTestimonial() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstant.getTestimonial,
        );
    final  dynamic  productsData = response.data['data'];
    final TestimonialResponse recommendedProducts = TestimonialResponse.fromJson(productsData);
    return recommendedProducts;
  }





}

final homeRepo = Provider((ref) => HomeRepo(ref));
