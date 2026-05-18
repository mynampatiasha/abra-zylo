// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _ApiClient implements ApiClient {
  _ApiClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= ApiConstant.baseUrl;
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HomePageData> getHomePage(
    String lang,
    String currency,
    int deviceWidth,
    String wsKey,
    String header,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'mfactor': lang,
      'count': currency,
      'width': deviceWidth,
      'wk_token': wsKey,
      'etag': header,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<HomePageData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/homepage',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = HomePageData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ApiLoginResponseModel> apiLogin(
    String apiKey,
    String apiPassword,
    String customer_id,
    String language,
    String currency,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'apiKey': apiKey,
      'apiPassword': apiPassword,
      'customer_id': customer_id,
      'language': language,
      'currency': currency,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiLoginResponseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/apiLogin',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ApiLoginResponseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SubCategoryModel> getSubCategoryData(
    String width,
    String wkToken,
    String categoryId,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wkToken,
      'category_id': categoryId,
      'etag': eTag,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SubCategoryModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getSubCategory',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SubCategoryModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> getCatalogProducts(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/productCategory',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> searchResults(
    String? search,
    String token,
    String width,
    String categoryId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'search': search,
      'wk_token': token,
      'width': width,
      'category_id': categoryId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/productSearch',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> getCustomCollection(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'id': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/customCollection',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ProductDetailScreenModel> getProductDetail(
    String width,
    String product_id,
    String profile_page,
    String wk_token,
    String header,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'product_id': product_id,
      'profile_page': profile_page,
      'wk_token': wk_token,
      'etag': header,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ProductDetailScreenModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/getProduct',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ProductDetailScreenModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> writeReview(
    String name,
    String text,
    String rating,
    String product_id,
    dynamic Stringwk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'name': name,
      'text': text,
      'rating': rating,
      'product_id': product_id,
      'wk_token': Stringwk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/writeProductReview',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ReviewData> getProductReviewList(
    String wkToken,
    String productId,
    String page,
    String limit,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'product_id': productId,
      'page': page,
      'limit': limit,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ReviewData>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/getReviews',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ReviewData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> addToCart(
    String product_id,
    String quantity,
    String option,
    String width,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': product_id,
      'quantity': quantity,
      'option': option,
      'width': width,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/addToCart',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AddProductToWishListModel> addProductToWishlist(
    String product_id,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': product_id,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AddProductToWishListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/addToWishlist',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = AddProductToWishListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegisterAccountModel> registerAccount(String wk_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wk_token};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegisterAccountModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/registerAccount',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = RegisterAccountModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegisterAccountModel> checkEmail(
    String wk_token,
    String email,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'email': email,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegisterAccountModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/checkEmail',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = RegisterAccountModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginModel> addCustomer(
    String wk_token,
    String customer_group_id,
    String firstname,
    String lastname,
    String email,
    String telephone,
    String password,
    String isSubscribe,
    String agree,
    String tobecomepartner,
    String shoppartner,
    String android_device_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'customer_group_id': customer_group_id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'password': password,
      'newsletter': isSubscribe,
      'agree': agree,
      'tobecomepartner': tobecomepartner,
      'shoppartner': shoppartner,
      'android_device_id': android_device_id,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LoginModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/addCustomer',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = LoginModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginModel> loginCustomer(
    String wk_token,
    String username,
    String password,
    String? androidDeviceId,
    String? iosDeviceId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'username': username,
      'password': password,
      'android_device_id': androidDeviceId,
      'ios_device_id': iosDeviceId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LoginModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/customerLogin',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = LoginModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> forgotPassword(
    String wk_token,
    String email,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'email': email,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/forgotPassword',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> logoutUser(String wk_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wk_token};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/customerLogout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> deleteUser(String wk_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wk_token};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/deleteaccount',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AccountInfoModel> userDetail(String wk_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wk_token};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AccountInfoModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/myAccount',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = AccountInfoModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> editCustomer(
    String wk_token,
    String firstName,
    String lastname,
    String email,
    String telephone,
    String fax,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'firstname': firstName,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'fax': fax,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/editCustomer',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> editPassword(
    String wk_token,
    String password,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'password': password,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/editPassword',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CartModel> viewCart(
    String width,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CartModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/viewCart',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CartModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> removeFromCart(
    String key,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'key': key,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/removeFromCart',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> emptyCart(String wk_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wk_token};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/clearCart',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> updateCart(
    String quantity,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'quantity': quantity,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/updateCart',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> applyCoupon(
    String coupon,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'coupon': coupon,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/applyCoupon',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> applayVoucher(
    String voucher,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'voucher': voucher,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/applyVoucher',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> applyRewards(
    String coupon,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'reward': coupon,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/applyPoints',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CountryDataModel> getCountryData(String wk_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wk_token};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CountryDataModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/getCountry',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CountryDataModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CartShippingModel> getShipping(
    String wk_token,
    String zone_id,
    String country_id,
    String postcode,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'zone_id': zone_id,
      'country_id': country_id,
      'postcode': postcode,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CartShippingModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/cart/getShipping',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CartShippingModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> applyShipping(
    String wk_token,
    String shipping_method,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'shipping_method': shipping_method,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '?route=api/wkrestapi/cart/applyShipping',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutPaymentAddressModel> getCheckoutPaymentAddress(
    String wk_token,
    String function,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'function': function,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutPaymentAddressModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutPaymentAddressModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutShippingAddressModel> getCheckoutShippingAddress(
    String function,
    String address_id,
    String payment_address,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'address_id': address_id,
      'payment_address': payment_address,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutShippingAddressModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutShippingAddressModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutShippingMethodModel> getCheckoutShippingMethods(
    String function,
    String address_id,
    String shipping_address,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'address_id': address_id,
      'shipping_address': shipping_address,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutShippingMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutShippingMethodModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutPaymentMethodModel>
      getPaymentMethodsWhileShippingIsNotRequired(
    String function,
    String address_id,
    String payment_address,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'address_id': address_id,
      'payment_address': payment_address,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutPaymentMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutPaymentMethodModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutPaymentMethodModel> getCheckoutPaymentMethod(
    String function,
    String shipping_method,
    String comment,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': function,
      'shipping_method': shipping_method,
      'comment': comment,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutPaymentMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutPaymentMethodModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutReviewOrderModel> reviewOrder(
    String width,
    String function,
    String payment_method,
    String agree,
    String comment,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'function': function,
      'payment_method': payment_method,
      'agree': agree,
      'comment': comment,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutReviewOrderModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutReviewOrderModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutConfirmOrderModel> confirmOrder(
    String wk_token,
    String state,
    String paymentId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'state': state,
      'razorpay_payment_id': paymentId,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutConfirmOrderModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/confirmOrder',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutConfirmOrderModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutGuestModel> guestCheckout(
    String state,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'function': state,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CheckoutGuestModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutGuestModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> guestOrdersAndReturnsData(
    String wkToken,
    String orderId,
    String orderProductId,
    String firstName,
    String lastName,
    String email,
    String telephone,
    String dateOrdered,
    String product,
    String model,
    String quantity,
    String returnReasonId,
    String opened,
    String comment,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'order_id': orderId,
      'product_id': orderProductId,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'telephone': telephone,
      'date_ordered': dateOrdered,
      'product': product,
      'model': model,
      'quantity': quantity,
      'return_reason_id': returnReasonId,
      'opened': opened,
      'comment': comment,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/returnGuestOrder',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GuestOrderReturn> getGuestOrders(
    String wk_token,
    String orderId,
    String lastName,
    String email,
    String zip,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'order_id': orderId,
      'lastName': lastName,
      'email': email,
      'zip': zip,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GuestOrderReturn>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/getGuestOrder',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = GuestOrderReturn.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ReviewsListModel> getReviewsList(
    String wk_token,
    int pageNo,
    int limit,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'page': pageNo,
      'limit': limit,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ReviewsListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getProductReviews',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ReviewsListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutShippingAddressModel> guestShippingAddress(
    String state,
    String function,
    String email,
    String telephone,
    String fax,
    String firstname,
    String lastname,
    String company,
    String address_1,
    String address_2,
    String city,
    String postcode,
    String country_id,
    String zone_id,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'shipping_address': state,
      'function': function,
      'email': email,
      'telephone': telephone,
      'fax': fax,
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'postcode': postcode,
      'country_id': country_id,
      'zone_id': zone_id,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutShippingAddressModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutShippingAddressModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CheckoutShippingMethodModel> guestShippingMethod(
    String state,
    String function,
    String email,
    String telephone,
    String fax,
    String firstname,
    String lastname,
    String company,
    String address_1,
    String address_2,
    String city,
    String postcode,
    String country_id,
    String zone_id,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'shipping_address': state,
      'function': function,
      'email': email,
      'telephone': telephone,
      'fax': fax,
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'postcode': postcode,
      'country_id': country_id,
      'zone_id': zone_id,
      'wk_token': wk_token,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CheckoutShippingMethodModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/checkout/checkout',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CheckoutShippingMethodModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderDetailModel> getOrderDetails(
    String wk_token,
    String order_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'order_id': order_id,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<OrderDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getOrderInfo',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = OrderDetailModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ReturnOrderListModel> getReturnOrderList(
    String wk_token,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'etag': eTag,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ReturnOrderListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getReturns',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ReturnOrderListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CmsDetailModel> getCmsPageDetail(
    String wk_token,
    String information_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'information_id': information_id,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CmsDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getInformationPage',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CmsDetailModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> updateCurrency(
    String wk_token,
    String code,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'code': code,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/currency',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> updateLanguage(
    String wk_token,
    String code,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'code': code,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/language',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<TransactionModel> getTransactionDetails(
    String wk_token,
    String page,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'page': page,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<TransactionModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getTransactionInfo',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = TransactionModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RewardModel> getRewardPointsDetails(
    String wk_token,
    String page,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'page': page,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<RewardModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getRewardInfo',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = RewardModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DownloadProductModel> getDownloadableProducts(
    String wk_token,
    String limit,
    String page,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'limit': limit,
      'page': page,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DownloadProductModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getDownloadInfo',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = DownloadProductModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetWishlist> getWishlist(
    String width,
    String wk_token,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wk_token,
      'etag': eTag,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GetWishlist>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getWishlist',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = GetWishlist.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> removeFromWishlist(
    String product_id,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': product_id,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/removeFromWishlist',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderListModel> getAllOrderList(
    String wk_token,
    String page,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'page': page,
      'etag': eTag,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<OrderListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getOrders',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = OrderListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> subscribeNewsletter(
    String wk_token,
    String newsletter,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'newsletter': newsletter,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/setNewsletter',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> getNewsLetter(String wk_token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wk_token};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getNewsletter',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetAddress> getAddressList(
    String token,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'etag': eTag,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GetAddress>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getAddresses',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = GetAddress.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> deleteAddress(
    String addressId,
    String token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'address_id': addressId,
      'wk_token': token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/deleteAddress',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<EditAddressBook> addAddressBook(
    String? addressId,
    String token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'address_id': addressId,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<EditAddressBook>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getAddress',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = EditAddressBook.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderDetailModel> dashboarOrderInfo(
    String? orderId,
    String token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'order_id': orderId,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<OrderDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getOrderInfo',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = OrderDetailModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> reOrderProduct(
    String token,
    String? orderId,
    String orderProductId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'order_id': orderId,
      'order_product_id': orderProductId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/reorder',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ReturnOrderRequest> addReturnData(
    String token,
    String? orderId,
    String orderProductId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'order_id': orderId,
      'product_id': orderProductId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ReturnOrderRequest>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/addReturnData',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ReturnOrderRequest.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> addReturn(
    String token,
    String? order_id,
    String orderProductId,
    String? firstname,
    String? lastname,
    String? email,
    String? telephone,
    String? date_ordered,
    String? product,
    String? model,
    String? quantity,
    String? return_reason_id,
    String? opened,
    String? comment,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'order_id': order_id,
      'product_id': orderProductId,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'telephone': telephone,
      'date_ordered': date_ordered,
      'product': product,
      'model': model,
      'quantity': quantity,
      'return_reason_id': return_reason_id,
      'opened': opened,
      'comment': comment,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/addReturn',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LocationModel> getDboyLocation(
    String token,
    String? id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': token,
      'id': id,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LocationModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/deliveryboy/getTrackData',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = LocationModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> loginWithQr(
    String? key,
    String token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'key': key,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=account/qrcode/mobiletoweb',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> addAddress(
    String customerId,
    String? addressId,
    String firstname,
    String lastname,
    String company,
    String address1,
    String address22,
    String city,
    String zoneId,
    String postcode,
    String countryId,
    String defaultValue,
    String token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'customer_id': customerId,
      'address_id': addressId,
      'firstname': firstname,
      'lastname': lastname,
      'company': company,
      'address_1': address1,
      'address_2': address22,
      'city': city,
      'zone_id': zoneId,
      'postcode': postcode,
      'country_id': countryId,
      'default': defaultValue,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/addAddress',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GooglePlaceModel> getGooglePlace(String endPoint) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<GooglePlaceModel>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'place/textsearch/json?query=${endPoint}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = GooglePlaceModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<NotificationScreenModel> getNotifications(
    String width,
    String wk_token,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'width': width,
      'wk_token': wk_token,
      'etag': eTag,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<NotificationScreenModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/viewNotifications',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = NotificationScreenModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchModel> searchSuggestions(
    String? search,
    String token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'search': search,
      'wk_token': token,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SearchModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/searchSuggest',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SearchModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> popularProducts(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getPopularProducts',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> bestProducts(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getBestProducts',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> featured(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/featured',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> latestProduct(
    String page,
    String limit,
    String width,
    String? path,
    String? sort,
    String? order,
    String? filter,
    String wkToken,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'path': path,
      'sort': sort,
      'order': order,
      'filter': filter,
      'wk_token': wkToken,
      'etag': eTag,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/latestProduct',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ManufactureModel> manufactureInfo(
    String page,
    String limit,
    String width,
    String manufacturer_id,
    String sort,
    String order,
    String wk_token,
    String eTag,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'manufacturer_id': manufacturer_id,
      'sort': sort,
      'order': order,
      'wk_token': wk_token,
      'etag': eTag,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<ManufactureModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/manufacturerInfo',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ManufactureModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> registerCustomerDeviceToken(
    String wkToken,
    String? androidDeviceId,
    String? iosDeviceId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'android_device_id': androidDeviceId,
      'ios_device_id': iosDeviceId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/registerDeviceToken',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ReturnOrderDetailModel> getReturnDetails(
    String wkToken,
    String? return_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'return_id': return_id,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ReturnOrderDetailModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getReturnInfo',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = ReturnOrderDetailModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> toBecomeSeller(
    String wk_token,
    String shoppartner,
    String description,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wk_token,
      'shoppartner': shoppartner,
      'description': description,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/becomeSeller',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<WalkThroughModel> getWalkThrough(
    String height,
    String width,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'height': height,
      'width': width,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<WalkThroughModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getWalkThrough',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = WalkThroughModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CatalogModel> getCarouselProducts(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String wkToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'carousel_id': path,
      'sort': sort,
      'order': order,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CatalogModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getCarousels',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CatalogModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CarouselModel> getCarouselManufacture(
    String page,
    String limit,
    String width,
    String path,
    String? sort,
    String? order,
    String wkToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'page': page,
      'limit': limit,
      'width': width,
      'carousel_id': path,
      'sort': sort,
      'order': order,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CarouselModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getCarousels',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CarouselModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CompareProduct> getCompareProducts(String wkToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<CompareProduct>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/productCompare',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = CompareProduct.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> addCompareProduct(
    String? productId,
    String wkToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'product_id': productId,
      'wk_token': wkToken,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/addToComparelist',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> removeCompareProduct(
    String? productId,
    String wkToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'remove': productId};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {'wk_token': wkToken};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/catalog/removeProductCompare',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SplashScreenModel> getSplashScreen(
    String height,
    String width,
    String wk_token,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'height': height,
      'width': width,
      'wk_token': wk_token,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SplashScreenModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/common/getSplashScreen',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SplashScreenModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AccountItemsListModel> getAccountItemsList(
    String customerId,
    String wkToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'customer_id': customerId,
      'wk_token': wkToken,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AccountItemsListModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/getUserNavigationList',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = AccountItemsListModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<BaseModel> sendWishlistCollection(
    String email,
    String wkToken,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'email': email,
      'wk_token': wkToken,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<BaseModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/shareWishlist',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = BaseModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SaveImageModel> uploadProfileImage(
    String customerId,
    String wkToken,
    File image,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'customer_id',
      customerId,
    ));
    _data.fields.add(MapEntry(
      'wk_token',
      wkToken,
    ));
    _data.files.add(MapEntry(
      'image',
      MultipartFile.fromFileSync(
        image.path,
        filename: image.path.split(Platform.pathSeparator).last,
        contentType: MediaType.parse('image/jpeg'),
      ),
    ));
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SaveImageModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/addUserProfile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SaveImageModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SaveImageModel> uploadBannerImage(
    String customerId,
    String wkToken,
    File banner,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'customer_id',
      customerId,
    ));
    _data.fields.add(MapEntry(
      'wk_token',
      wkToken,
    ));
    _data.files.add(MapEntry(
      'banner',
      MultipartFile.fromFileSync(
        banner.path,
        filename: banner.path.split(Platform.pathSeparator).last,
        contentType: MediaType.parse('image/jpeg'),
      ),
    ));
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SaveImageModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/addUserProfile',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SaveImageModel.fromJson(_result.data!);
    return value;
  }

  @override
  Future<LoginModel> googleLogin(
    String wkToken,
    String googleId,
    String email,
    String firstname,
    String lastname,
    String? androidDeviceId,
    String? iosDeviceId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'wk_token': wkToken,
      'google_id': googleId,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
      'android_device_id': androidDeviceId,
      'ios_device_id': iosDeviceId,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<LoginModel>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'index.php?route=api/wkrestapi/customer/googleLogin',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = LoginModel.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
