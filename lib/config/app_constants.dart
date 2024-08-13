class AppConstant {
  // API URL
  // static const String baseUrl = 'https://alicom.razinsoft.com/api';

  static const String baseUrl = 'https://alsultanbakkerij.nl/api/v1';
  static const String authUrl = 'https://alsultanbakkerij.nl/tello';
  ///customer
  static const String customer = '/users/auth';
  static const String signUp = '$baseUrl$customer/register';
  static const String loginUrl = '$baseUrl$customer/login';
  static const String forgetPassword = '$baseUrl$customer/forgot';

  ///profile
  static const String updateUserInfo = '$baseUrl/users/update';
  static const String getUserInfo = '$baseUrl/users/me';
  static const String signOut = '$baseUrl/users/logout';


  static const String getUserBillingAddresses = '$baseUrl/users/billing/getDetails';
  static const String getUserShippingAddresses = '$baseUrl/users/shipping/getDetails';


  static const String updateShippingAddresses = '$baseUrl/users/shipping/update';
  static const String updateBillingAddresses = '$baseUrl/users/billing/update';


  static const String getOrders = '$baseUrl/users/orders';
  static const String getOrderDetails = '$baseUrl/order/details';


///news
  static const String news = '/news';
  static const String getBlogList = '$baseUrl$news/getAll';
  static const String getNewsCategoriesList = '$baseUrl$news/getAllCategories';
  static const String getBlogDetails = '$baseUrl$news/byId';

///menu
  static const String getCategories = '$baseUrl/categories/getMain';
  static const String getProducts = '$baseUrl/products/getAll';





  static const String getBanners = '$baseUrl/banners';
  static const String getRecommendedProducts = '$baseUrl/products/getAll';

  static const String getProductDetails = '$baseUrl/product/details';
  static const String placeOrder = '$baseUrl/order/store';


  static const String updatePaymentStatus =
      '$baseUrl/order/update-payment-status';

  static const String getUserReview = '$baseUrl/shop/reviews';

  static const String applyCouponCode = '$baseUrl/coupons/apply';

  static const String getPrivacyPolicy = '$baseUrl/legal-pages/privacy_policy';
  static const String getTermsAndConditions =
      '$baseUrl/legal-pages/trams_of_service';
  static const String getAboutUsContent = '$baseUrl/legal-pages/about_us';




  // payment api url

  static const String paymentUrl = 'https://api.stripe.com/v1/payment_intents';

  // secret keys
  static const String publishableKey = 'pk_test_TYooMQauvdEDq54NiTphI7jx';
  static const String paymentSecret = 'sk_test_4eC39HqLyjWDarjtT1zdp7dc';
  static const String merchantCountryCode = 'USA';
  static const String currencyCode = 'USD';
}
