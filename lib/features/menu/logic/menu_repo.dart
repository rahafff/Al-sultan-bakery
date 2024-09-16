import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/app_constants.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/menu/model/pages_model.dart';
import 'package:grocerymart/features/menu/model/update_profile.dart';
import 'package:grocerymart/features/menu/model/user_address.dart';
import 'package:grocerymart/service/hive_logic.dart';
import 'package:grocerymart/service/hive_model.dart';
import 'package:grocerymart/utils/api_client.dart';

class MenuRepo {
  final Ref ref;
  MenuRepo(this.ref);

  Future<String?> updateProfileInfo({
    required UpdateProfile profileInfo,
    required File? file,
  }) async {
    FormData formData = FormData.fromMap({
      'photo': file != null
          ? await MultipartFile.fromFile(file.path,
              filename: 'profile_photo.jpg')
          : null,
      ...profileInfo.toMap(),
    });
    final response = await ref.read(apiClientProvider).post(
          AppConstant.updateUserInfo,
          data: formData,
        );
    if (response.statusCode == 200) {
      print('ddddoooonnee');
      final message = response.data['message'];
      final userInfo = User.fromMap(response.data['data']);
      ref.read(hiveStorageProvider).saveUserInfo(userInfo: userInfo);
      return message;
    }
    return null;
  }

  Future<ShippingBillingResponse?> getUserShippingAddresses() async {
    final response = await ref.read(apiClientProvider).get(
          AppConstant.getUserShippingAddresses,
        );
    if (response.statusCode == 200) {
      dynamic addressesData = response.data['data'];
      ShippingBillingResponse userAddresses =
          ShippingBillingResponse.fromJson(addressesData);
      if (userAddresses.address != null) {
        ref.read(hiveStorageProvider).saveDeliveryShippingAddress(userAddress: userAddresses);
      }
      return userAddresses;
    }
    return null;
  }

  Future<ShippingBillingResponse?> getUserBillingAddresses() async {
    print('billllllllllll');
    final response = await ref.read(apiClientProvider).get(
          AppConstant.getUserBillingAddresses,
        );
    if (response.statusCode == 200) {
      dynamic addressesData = response.data['data'];
      ShippingBillingResponse userAddresses =
          ShippingBillingResponse.fromJson(addressesData);
      if (userAddresses.address != null) {
        ref.read(hiveStorageProvider).saveDeliveryBillingAddress(userAddress: userAddresses);
      }
      return userAddresses;
    }
    return null;
  }

  Future<ShippingBillingResponse> updateShippingAddress( AddressRequest req,bool isShipping ) async {
    final response = await ref.read(apiClientProvider).post(
        isShipping? AppConstant.updateShippingAddresses :AppConstant.updateBillingAddresses,
      data: isShipping ? req.toMapShipping(): req.toMapBilling()
    );
    if (response.statusCode == 200) {
      dynamic addressesData = response.data['data'];
      ShippingBillingResponse userAddresses =
      ShippingBillingResponse.fromJson(addressesData);
      if (userAddresses.address != null && isShipping) {
        ref.read(hiveStorageProvider).saveDeliveryShippingAddress(userAddress: userAddresses);
      }else if(userAddresses.address != null && !isShipping){
        ref.read(hiveStorageProvider).saveDeliveryBillingAddress(userAddress: userAddresses);
      }
      return userAddresses;
    }
    return ShippingBillingResponse();
  }


  Future<List<PagesModel>> getAllPages() async {
    final response = await ref.read(apiClientProvider).get(
      AppConstant.getAllPages,
    );
    if (response.statusCode == 200) {
      final List<dynamic> reviewData = response.data['data'];

      final List<PagesModel> pages = reviewData
          .map((review) => PagesModel.fromJson(review))
          .toList();
      return pages;
    }
    return [];
  }

  Future<PagesModel> getPageInfo(int? pageId) async {
    Map<String, String> queryParams = {};
    if (pageId != null) queryParams['pageId'] = pageId.toString();
    final response = await ref.read(apiClientProvider).get(
      AppConstant.getPageInfo,query: queryParams
    );
    if (response.statusCode == 200) {
      dynamic addressesData = response.data['data'];
      PagesModel page = PagesModel.fromJson(addressesData);
      return page;
    }
    return PagesModel(-1,'', '', '');
  }
}

final menuRepo = Provider((ref) => MenuRepo(ref));
