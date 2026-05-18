import 'package:dio/dio.dart';
import 'package:oc_demo/models/base_model.dart';

import '../constants/app_constants.dart';
import '../helper/app_shared_pref.dart';
import '../models/ApiLoginResponse/api_login_response.dart';
import '../screens/splash/bloc/splash_screen_repository.dart';
import 'apis.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioErrorType.unknown:
        message = "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.badResponse:
        message = _handleError(dioError.response?.statusCode ?? 400);
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String? message;

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
      case 403:
        return "Unauthorized request";
      case 404:
        return "Not found";
      case 409:
        return "Error due to a conflict";
      case 408:
        return "Connection request timeout";
      case 500:
        return 'Internal server error';
      case 503:
        return "Service unavailable";
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message ?? '';
}

class DioCustomError implements DioError {
  DioCustomError(String message, DioError error) {
    this.requestOptions = error.requestOptions;
    this.message = message;
    this.type = error.type;
    this.error = error.error;
    this.stackTrace = error.stackTrace;
    this.response = error.response;
  }

  setMessage(String message) {
    this.message = message;
  }

  @override
  String message = '';

  @override
  String toString() => message;

  @override
  var error;

  @override
  late RequestOptions requestOptions;

  @override
  Response? response;

  @override
  late StackTrace stackTrace;

  @override
  late DioErrorType type;

  @override
  DioException copyWith(
      {RequestOptions? requestOptions,
      Response? response,
      DioExceptionType? type,
      Object? error,
      StackTrace? stackTrace,
      String? message}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}

void handleFaultCode(
    Dio dio, RequestOptions? reqOptions, String baseUrl, handler) async {
  AppSharedPref.getLoginUserData().then((res) async {
    final _result = await dio.fetch<Map<String, dynamic>>(
        _setStreamType<ApiLoginResponseModel>(
            Options(method: 'POST').compose(dio.options, Apis.apiLogin, data: {
      'apiKey': ApiConstant.apiKey,
      'apiPassword': (ApiConstant.apiPassword),
      'customer_id': res?.customerId ?? "",
      'language': await AppSharedPref.getLanguage(),
      'currency': await AppSharedPref.getCurrency()
    }).copyWith(baseUrl: baseUrl)));
    final value1 = ApiLoginResponseModel.fromJson(_result.data!);
    print("asdadas----${_result.data}");
    if (value1.wkToken != null) {
      var data = reqOptions?.data;
      data["wk_token"] = value1.wkToken;
      await AppSharedPref.setWkToken(value1.wkToken ?? "");
      print("ddswssa---${value1.wkToken}");
      var apiResult = await dio.fetch<Map<String, dynamic>>(
          _setStreamType<BaseModel>(Options(
                  method: reqOptions?.method,
                  headers: reqOptions?.headers,
                  extra: reqOptions?.extra)
              .compose(dio.options, reqOptions?.path ?? "", data: data)
              .copyWith(baseUrl: baseUrl)));
      handler.next(apiResult);
    }
  });
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
