import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/menu/logic/menu_repo.dart';
import 'package:grocerymart/features/menu/model/update_profile.dart';
import 'package:grocerymart/features/menu/model/user_address.dart';

class MenuStateNotifier extends StateNotifier<bool> {
  final Ref ref;
  MenuStateNotifier(this.ref) : super(false);

  Future<String?> updateProfileInfo(
      {required UpdateProfile profileInfo, required File? file}) async {
    state = true;
    try {
      final message = await ref.read(menuRepo).updateProfileInfo(
            profileInfo: profileInfo,
            file: file,
          );
      state = false;
      return message ?? 'success';
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      state = false;
      return null;
    }
  }

  Future<String?> manageUserAddress({required AddressRequest userAddress,bool isShipping = false}) async {
    state = true;
    try {
      final message =
          await ref.read(menuRepo).updateShippingAddress(userAddress,isShipping);
      state = false;
      return '';
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      state = false;
      return null;
    }
  }

  Future<ShippingBillingResponse?> getUserShippingAddresses() async {
    state = true;
    try {
      final userAddresses = await ref.read(menuRepo).getUserShippingAddresses();
      state = false;
      return userAddresses;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      state = false;
      return ShippingBillingResponse();
    }
  }
}
