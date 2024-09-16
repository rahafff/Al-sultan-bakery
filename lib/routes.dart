import 'package:flutter/material.dart';
import 'package:grocerymart/features/auth/view/change_pass.dart';
import 'package:grocerymart/features/auth/view/login_screen.dart';
import 'package:grocerymart/features/auth/view/pass_recover.dart';
import 'package:grocerymart/features/auth/view/sign_up.dart';
import 'package:grocerymart/features/auth/view/verify_otp.dart';
import 'package:grocerymart/features/blogs/model/blog_response.dart';
import 'package:grocerymart/features/blogs/view/blog_details_screen.dart';
import 'package:grocerymart/features/blogs/view/blogs_list_screen.dart';
import 'package:grocerymart/features/cart/view/cart_view.dart';
import 'package:grocerymart/features/categories/model/responses/category_response.dart';
import 'package:grocerymart/features/categories/model/responses/product_response.dart';
import 'package:grocerymart/features/categories/views/sub_categories_view.dart';
import 'package:grocerymart/features/categories/views/sub_category_product_view.dart';
import 'package:grocerymart/features/checkout/model/order_response.dart';
import 'package:grocerymart/features/checkout/model/shipping_billing_response.dart';
import 'package:grocerymart/features/checkout/view/order_details.dart';
import 'package:grocerymart/features/checkout/view/order_screen.dart';
import 'package:grocerymart/features/dashboard/views/dashboard.dart';
import 'package:grocerymart/features/dashboard/views/on_boarding_screen.dart';
import 'package:grocerymart/features/dashboard/views/splash_screen.dart';
import 'package:grocerymart/features/menu/view/manage_address.dart';

import 'package:grocerymart/features/menu/view/manage_shipping_address.dart';
import 'package:grocerymart/features/menu/view/menu_tab.dart';
import 'package:grocerymart/features/menu/view/page_details_screen.dart';
import 'package:grocerymart/features/menu/view/profile.dart';
import 'package:grocerymart/features/menu/view/add_user_address.dart';

import 'package:grocerymart/features/products/view/search_products.dart';
import 'package:grocerymart/features/products/view/product_details.dart';
import 'package:grocerymart/features/products/view/view_all_product.dart';
// import 'package:grocerymart/features/products/view/view_all_product.dart';
import 'package:grocerymart/service/hive_model.dart';
import 'package:grocerymart/util/entensions.dart';
import 'package:page_transition/page_transition.dart';

import 'features/checkout/view/checkout_screen.dart';

class Routes {
  /*We are mapping all th eroutes here
  so that we can call any named route
  without making typing mistake
  */
  Routes._();
  //core
  static const splash = '/';
  static const onBoarding = '/onBoarding';
  static const login = '/login';
  static const signUp = '/signUp';
  static const passwordRecover = '/passwordRecover';
  static const verifyOTPScreen = '/verifyOTPScreen';
  static const changePasswordScreen = '/changePasswordScreen';


  static const blogsScreen = '/blogsListScreen';
  static const blogsDetailsScreen = '/blogDetailsScreen';

  static const subcategoryProductScreen = '/subcategoryProductScreen';



  static const dashboard = '/dashboard';
  static const ownProductScreen = '/ownProductScreen';

  static const categoryWiseShop = '/categoryWiseShop';
  static const productDetailsScreen = '/productDetailsScreen';
  static const storeDetailsScreen = '/storeDetailsScreen';
  static const cartScreen = '/cartScreen';
  static const checkoutScreen = '/checkoutScreen';
  static const addUserAddressScreen = '/addUserAddressScreen';
  static const manageShippingAddressScreen = '/manageShippingAddressScreen';
  static const manageBillingAddressScreen = '/manageBillingAddressScreen';
  static const myOrdersScreen = '/myOrdersScreen';
  static const orderDetails = '/orderDetails';
  static const privacyPolicyScreen = '/privacyPolicyScreen';
  static const termsAndConditionsScreen = '/termsAndConditionsScreen';
  static const aboutUsScreen = '/aboutUsScreen';
  static const profileScreen = '/profileScreen';
  static const pageDetails = '/pageDetails';
  static const viewAllProduct = '/viewAllProduct';
  static const subCategoriesView = '/subCategoriesView';
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    //core
    case Routes.splash:
      child = const SplashScreen();
      break;
    case Routes.onBoarding:
      child = const OnBoardingScreen();
      break;
    case Routes.login:
      child = const LoginScreen();
      break;
    case Routes.signUp:
      child = const SignUpScreen();
      break;
    case Routes.passwordRecover:
      child = PassRecoverScreen();
      break;
    case Routes.verifyOTPScreen:
      VerifyOTPArgument argument = settings.arguments as VerifyOTPArgument;
      child = VerifyOTPScreen(
        argument: argument,
      );
      break;
    case Routes.changePasswordScreen:
      String token = settings.arguments as String;
      child = ChangePasswordScreen(
        token: token,
      );
      break;
    case Routes.dashboard:
      child = const DashboardScreen();
      break;

    case Routes.blogsScreen:
      child = const BlogsListScreen();
      break;

    case Routes.blogsDetailsScreen:
      child =   BlogDetailsScreen(
        blog:  settings.arguments as BlogResponse,
      );
      break;
    case Routes.ownProductScreen:
      child = OwnProductView();
      break;
    case Routes.addUserAddressScreen:
      child = AddUserAddressScreen(
        userAddress: settings.arguments as ShippingBillingResponse?,
      );
      break;
    case Routes.manageShippingAddressScreen:
      child = const ManageShippingAddressScreen( );
      break;

    case Routes.manageBillingAddressScreen:
      child = const ManageBillingAddressScreen();
      break;


    case Routes.subcategoryProductScreen:
      List<SubCategoryResponse> args = settings.arguments as List<SubCategoryResponse>;
      child = SubCategoryProductScreen(
        subCategoryList: args,
      );
      break;
    case Routes.viewAllProduct:
      child = ViewAllProduct(
        arguments: settings.arguments as ViewProductArguments,
      );
      break;
    case Routes.productDetailsScreen:
      child = ProductDetailsScreen(
        product: settings.arguments as ProductResponse,
      );
      break;
    case Routes.subCategoriesView:
      child = SubCategoriesView(
         arguments: settings.arguments as SubCategoriesArguments,
      );
      break;
    case Routes.cartScreen:
      child = const CartScreen();
      break;
    case Routes.checkoutScreen:
      CheckoutArgument checkoutArgument =
          settings.arguments as CheckoutArgument;
      child = CheckoutScreen(
        checkoutArgument: checkoutArgument,
      );
      break;
    case Routes.myOrdersScreen:
      child = const OrderScreen();
      break;
    case Routes.orderDetails:
      child = OrderDetailsScreen(
        order: settings.arguments as OrderResponse,
      );
      break;
    case Routes.profileScreen:
      child = ProfileScreen(
        userInfo: settings.arguments as User,
      );
      break;
    case Routes.pageDetails:
      child = PageDetailsScreen(arguments: settings.arguments as PageDetailsArguments,);
      break;
    // case Routes.privacyPolicyScreen:
    //   child = const PrivacyPolicyScreen();
    //   break;
    // case Routes.termsAndConditionsScreen:
    //   child = const TermsAndConditions();
    //   break;
    // case Routes.aboutUsScreen:
    //   child = const AboutUs();
      break;

    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  debugPrint('Route: ${settings.name}');

  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
    duration: 300.miliSec,
    reverseDuration: 300.miliSec,
  );
}
