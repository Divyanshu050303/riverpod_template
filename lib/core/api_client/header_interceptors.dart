import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio _alternateDio = Dio(BaseOptions())
    ..interceptors.add(LogInterceptor(
        requestBody: true,
        logPrint: (Object object) {
          log('$object');
        }));
  static const int _authErrorCode = 401;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      if (await _hasRequestTokenExpired()) {
        options = options.copyWith(
          headers: _createHeader(options.headers),
        );
        handler.next(options);
      } else {
        _sendAuthError(handler, options);
      }
    } catch (error) {
      _sendAuthError(handler, options);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != _authErrorCode) {
      return super.onError(err, handler);
    }
    try {
      final requestOptions = err.requestOptions.copyWith(
        headers: _createHeader(
          err.requestOptions.headers,
        ),
      );
      final Response response = await _alternateDio.fetch(requestOptions);
      handler.resolve(response);
    } catch (error) {
      super.onError(err, handler);
    }
  }

  Map<String, dynamic> _createHeader(Map<String, dynamic>? headers) {
    final isAndroid = Platform.isAndroid;
    Map<String, dynamic> tempHeader = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (headers != null) {
      tempHeader.addAll(headers);
    }
    final accessToken = ''; // todo add user token here
    final token = accessToken.isNotEmpty ? accessToken : null;
    if (token != null) {
      tempHeader['authorization'] = 'Bearer $token';
    } else {
      tempHeader.remove('authorization');
    }
    return tempHeader;
  }

  Future<bool> _hasRequestTokenExpired() async {
    const refresToken = null;
    final token = ''; //todo add access token here
    final accessToken = token.isNotEmpty ? token : null;
    if (accessToken == null && refresToken == null) {
      return true;
    }
    if (accessToken == null || refresToken == null) {
      return true;
    }
    return false;
  }

  void _sendAuthError(
    RequestInterceptorHandler handler,
    RequestOptions options,
  ) {
    handler.reject(
      DioError(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: _authErrorCode,
        ),
      ),
    );
  }
}
