import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/features/cart/model/hive_cart_model.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/menu/model/user_address.dart';
import 'package:grocerymart/service/hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final Ref ref;
  HiveService(this.ref);

  // save data to the local storage

  // save access token
  Future saveUserAuthToken({required String authToken}) async {
    final authBox = await Hive.openBox(AppHSC.authBox);
    authBox.put(AppHSC.authToken, authToken);
  }

  // remove access token
  Future removeUserAuthToken() async {
    final authBox = await Hive.openBox(AppHSC.authBox);
    authBox.delete(AppHSC.authToken);
  }

  // save user information
  Future saveUserInfo({required User userInfo}) async {
    final userBox = await Hive.openBox(AppHSC.userBox);
    userBox.put(AppHSC.userInfo, userInfo.toMap());
  }

  // save default delivery address
  Future saveDeliveryAddress({required ShippingBillingResponse userAddress}) async {
    final addressBox = await Hive.openBox(AppHSC.deliveryAddressBox);
    addressBox.put(AppHSC.deliveryAddress, userAddress.toMap());
  }

  // remove user data
  Future removeUserData() async {
    final userBox = await Hive.openBox(AppHSC.userBox);
    userBox.clear();
  }

  // remove deliveryAddress
  Future removeDeliveryAddress() async {
    final addressBox = await Hive.openBox(AppHSC.deliveryAddressBox);
    addressBox.clear();
  }

  // remove cart items
  Future removeCartITems() async {
    final cartBox = await Hive.openBox<HiveCartModel>(AppHSC.cartBox);
    cartBox.clear();
  }

  // save the first open status
  Future setFirstOpenValue({required bool value}) async {
    final appSettingsBox = await Hive.openBox(AppHSC.appSettingsBox);
    appSettingsBox.put(AppHSC.firstOpen, value);
  }

  // save the first open status
  Future isDarkTheme({required bool value}) async {
    final appSettingsBox = await Hive.openBox(AppHSC.appSettingsBox);
    appSettingsBox.put(AppHSC.isDarkTheme, value);
  }

  Future<bool> getTheme() async {
    final Box box = await Hive.openBox(AppHSC.appSettingsBox);
    final themeData = box.get(AppHSC.isDarkTheme);
    return themeData;
  }
// get data from local storge

// get user auth token
  Future<String?> getAuthToken() async {
    final authBox = await Hive.openBox(AppHSC.authBox);
    final authToken = await authBox.get(AppHSC.authToken);
    if (authToken != null) {
      return authToken;
    }
    return null;
  }

// get user information
  Future<User?> getUserInfo() async {
    final userBox = await Hive.openBox(AppHSC.userBox);
    Map<dynamic, dynamic>? userInfo = userBox.get(AppHSC.userInfo);
    print(userInfo);


    if (userInfo != null) {
      // Convert Map<dynamic, dynamic> to Map<String, dynamic>
      Map<String, dynamic> userInfoStringKeys =
          userInfo.cast<String, dynamic>();
      User user = User.fromMap(userInfoStringKeys);
      return user;
    }
    return null;
  }

// get user first open status
  Future<bool?> getUserFirstOpenStatus() async {
    final appSettingsBox = await Hive.openBox(AppHSC.appSettingsBox);
    final status = appSettingsBox.get(AppHSC.firstOpen);
    if (status != null) {
      return status;
    }
    return false;
  }

  Future<List<dynamic>?> loadTokenAndUser() async {
    final firstOpenStatus = await getUserFirstOpenStatus();
    final authToken = await getAuthToken();
    final user = await getUserInfo();

    return [firstOpenStatus, authToken, user];
    // return [false,
    //   'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiI3Y2EyMWQ0ZC1lNDAzLTQ5ZGUtYWU3Zi1hNDI2Y2UyMmY3MTYiLCJqdGkiOiJjMGU0YmYxMTIyOWM2MTE0MDY2NzUyYmRiYmQwNzZkZGVkODI5MDUzZmJjMWNjZGM1M2Q4OTJkYzJiMTViNDY3NDBhNTZmYmJmMzkzMzE4OCIsImlhdCI6MTcyMzU3ODA5MS4yMjA3MzksIm5iZiI6MTcyMzU3ODA5MS4yMjA3NDEsImV4cCI6NDg3OTI1MTY5MS4yMTg1MTEsInN1YiI6IjI4Iiwic2NvcGVzIjpbXX0.waUhwrCesBRMmRiLN9zEArS0jQcXe1DcpEEM5SEXt0UvCDRvUDGGTeMmFsI_HM3BmdIjQiYUZhEeSA21fncWcUYtEqneCGARbg2lXWGIXhDaD7wgadodFZzOEABVrRx2rYSkRKW3T69iHud7jbKTDqhrMEdv9oPeOmiz9A_N7CpUKGkFy9ECils88n7aHde7hKT5UvFfxBaapMOzNXWJZo1J_YR_G0GE4VkMmxvFybCt3GafOTP3NlUva5S-t97eHoARcqOsvPbxyV12n5k5NUmjoxgD-MCf9HXFJ9-L0LJZ3dSpd8F9OK5xTzoaPPHydHgLlArwDX5tSZXx885Bywig1fNqRBeB5xKph4Fp5GZozhpQLN52pbgjdhwwoHyeMJO71SmS20zxIlqvYiKgKvfF1s4TFabZnbHaF_S-_d4sps2lWWkmwZwHzn8LNnSSCypJXQwoto8HH39trGzC8OXZJHW99TbmMX5jrM3eO_oySMEsp7pF1OaUFI9vQvoP9vB6JCXt1294d2HnZ_Tg4c61tX-68uW97gJndz0dhxIxCnZBIKF5L2szFulRBXAhmB8Oxdo7qZKE5bhCbxicMcaqr4trSRtlKNb6r0nwQiXLF5DP4kPIj2IdA7vJTdypE_t_QAqtY6SI63EV-N0uebn475RiWiSkMbfsu6a9LiQ',
    //   User(username: 'rppop',address: '',city: '',country: '',state: '',email: '',number: '',photo: '')];
  }

  Future<bool> removeAllData() async {
    try {
      await removeUserAuthToken();
      await removeDeliveryAddress();
      await removeCartITems();
      // await removeUserData();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final hiveStorageProvider = Provider((ref) => HiveService(ref));
