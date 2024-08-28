import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:instagram_clone/core/api_client/api_exception.dart';
import 'package:instagram_clone/core/api_client/api_result.dart';
import 'package:instagram_clone/core/api_client/header_interceptors.dart';
import 'package:instagram_clone/core/api_client/retry_on_connection_change_interceptor.dart';
import 'package:instagram_clone/routers/app_routes.dart';
import 'package:instagram_clone/routers/routes.dart';
import 'package:instagram_clone/utils/storage_utils.dart';

typedef JsonMap = Map<String, dynamic>;

enum ApiStatus {
  int,
  failed,
  success,
  loading,
}

extension ApiStatusExtension on ApiStatus {
  bool get isLoading {
    return this == ApiStatus.loading;
  }
}

class DioUtil {
  static final DioUtil _instance = DioUtil.internal();
  static late Dio dio;
  static ApiResult apiResult = ApiResult();

  DioUtil.internal() {
    final authInterceptor = AuthInterceptor();
    final retryInterceptor =
        RetryOnConnectionChangeInterceptor(interceptors: [authInterceptor]);
    dio = Dio()
      ..interceptors.add(authInterceptor)
      ..interceptors.add(retryInterceptor)
      ..interceptors.add(
        LogInterceptor(
          responseBody: true,
          logPrint: _log,
          requestBody: true,
        ),
      );
  }
  factory DioUtil() => _instance;
  final CancelToken _cancelToken = CancelToken();
  Future get(
    url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParms,
  }) async {
    try {
      url = url;
      Response response = await dio.get(url,
          queryParameters: queryParms,
          options: Options(headers: headers),
          cancelToken: _cancelToken);
      return response.data;
    } catch (error) {
      return _handleError(url, error);
    }
  }

  Future<dynamic> post(
    url,
    JsonMap? body,
    FormData? formData,
    Map<String, dynamic> headers,
    Map<String, dynamic> queryParams,
    Function(int, int)? onSendProgress,
  ) async {
    try {
      url = url;
      Response response = await dio.post(
        url,
        queryParameters: queryParams,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
        onSendProgress: onSendProgress,
        data: formData ?? body,
      );
      return response.data;
    } catch (error) {
      return _handleError(url, error);
    }
  }

  Future put(
    String url,
    JsonMap? body,
    Map<String, dynamic> headers,
    Map<String, dynamic> queryParams,
  ) async {
    try {
      url = url;
      Response response = await dio.put(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
      return response.data;
    } catch (error) {
      return _handleError(url, error);
    }
  }

  Future patch(
    String url,
    JsonMap? body,
    Map<String, dynamic> headers,
    Map<String, dynamic> queryParams,
  ) async {
    try {
      url = url;
      Response response = await dio.patch(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
      return response.data;
    } catch (error) {
      return _handleError(url, error);
    }
  }

  Future delete(
    String url,
    JsonMap? body,
    Map<String, dynamic> headers,
  ) async {
    try {
      url = url;
      Response response = await dio.put(
        url,
        data: body,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
      return response.data;
    } catch (error) {
      return _handleError(url, error);
    }
  }

  Future<Map<String, dynamic>> _handleError(String path, Object error) {
    if (error is DioException) {
      final method = error.requestOptions.method;
      final response = error.response;
      apiResult.setStatusCode(response?.statusCode);
      final data = response?.data;
      int? statusCode = response?.statusCode;
      if (statusCode == 403) {
        SecureStorage.instance.deleteAll();
        AppRoutes.appRouter.pushReplacement(Routes.signIn);
      }
      String? errorMessage;
      try {
        errorMessage = data['message'] ?? '';
        if ((errorMessage ?? '').isEmpty) {
          errorMessage = data['error'];
        }
      } catch (e) {
        errorMessage = 'Something went wrong';
      }
      throw ApiException(
        errorMessage: errorMessage,
        path: path,
        info: 'received server error $statusCode while $method data',
        response: data,
        statusCode: statusCode,
        method: method,
      );
    } else {
      int errorCode = 0;
      throw ApiException(
          path: path,
          info: 'received server error $errorCode',
          response: error.toString(),
          statusCode: errorCode,
          method: '');
    }
  }

  void _log(Object object) {
    log('$object');
  }

  Future download(String url,
      {required String path,
      void Function(int, int)? onReceiveProgress}) async {
    try {
      await dio.download(
        url,
        path,
        onReceiveProgress: onReceiveProgress,
        cancelToken: _cancelToken,
        options: Options(followRedirects: false),
      );
    } catch (error) {
      return _handleError(path, error);
    }
  }
}
