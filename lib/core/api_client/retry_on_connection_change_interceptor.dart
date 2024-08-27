import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  late final Dio _alternateDio;

  late final List<Interceptor> interceptors;
  final List<(DioException, ErrorInterceptorHandler)> _failedRequests = [];

  RetryOnConnectionChangeInterceptor({
    required this.interceptors,
  }) {
    _alternateDio = Dio()..interceptors.addAll(interceptors);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if (_shouldRetry(err)) {
        _failedRequests.add((err, handler));
        await _navigateApiFailureScreen(isServerDown: _isServerDown(err));
      } else {
        handler.next(err);
      }
    } catch (e) {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return _isServerDown(err);
  }

  bool _isServerDown(DioException err) =>
      (err.type == DioException.connectionTimeout) ||
      (err.type == DioException.connectionError);

  Future<void> _navigateApiFailureScreen({required bool isServerDown}) async {}
  Future<void> _retryFailedRequest() async {
    try {
      for (final (
            DioException err,
            ErrorInterceptorHandler handler,
          ) in _failedRequests) {
        final requestoption = err.requestOptions;
        final Response response = await _alternateDio.fetch(requestoption);
        handler.resolve(response);
      }
      _failedRequests.clear();
    } on DioException catch (e) {
      log('retry failed requestes --> ${e.toString()}');
    } catch (e) {
      log(e.toString());
    }
  }

  (String?, Object?) getCurrentRouteAndArgs(
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    String? currentPath;
    Object? args;
    navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      args = route.settings.arguments;
      return true;
    });
    return (currentPath, args);
  }
}
