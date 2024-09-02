import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/home/logic/home_repo.dart';
import 'package:grocerymart/features/home/model/banner.dart';
import 'package:grocerymart/features/home/model/home_feature.dart';
import 'package:grocerymart/features/home/model/product_special.dart';
import 'package:grocerymart/features/home/model/testimonial_response.dart';

class HomeStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  HomeStateNotifier(this.ref) : super(false);

  Future<List<BannerModel>> getBanners() async {
    state = true;
    try {
      final bannerList = await ref.read(homeRepo).getBanners();
      state = false;
      return bannerList;
    } catch (error) {
      state = false;
      if (kDebugMode) {
        print(error);
      }
      return [];
    } finally {
      state = false;
    }
  }

  Future<ProductSpecial> getRecommendedProducts() async {
    state = true;
    try {
      final products = await ref.read(homeRepo).getRecommendedProducts();
      state = false;
      return products;
    } catch (error) {
      state = false;
      if (kDebugMode) {
        print(error);
      }
      return ProductSpecial('','',[]);
    } finally {
      state = false;
    }
  }
  Future<ProductSpecial> getFeatureProducts() async {
    state = true;
    try {
      final products = await ref.read(homeRepo).getFeatureProducts();
      state = false;
      return products;
    } catch (error) {
      state = false;
      if (kDebugMode) {
        print(error);
      }
      return ProductSpecial('','',[]);
    } finally {
      state = false;
    }
  }

  Future<HomeFeature> getHomeFeature() async {
    state = true;
    try {
      final products = await ref.read(homeRepo).getHomeFeature();
      state = false;
      return products;
    } catch (error) {
      state = false;
      if (kDebugMode) {
        print(error);
      }
      return HomeFeature('',[]);
    } finally {
      state = false;
    }
  }

  Future<TestimonialResponse> getTestimonial() async {
    state = true;
    try {
      final products = await ref.read(homeRepo).getHomeTestimonial();
      state = false;
      return products;
    } catch (error) {
      state = false;
      if (kDebugMode) {
        print(error);
      }
      return TestimonialResponse('',[]);
    } finally {
      state = false;
    }
  }



}
