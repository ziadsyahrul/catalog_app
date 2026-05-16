import 'package:dio/dio.dart';

import '../error/exceptions.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://fakestoreapi.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([_LogInterceptor(), _ErrorInterceptor()]);
  }

  Dio get dio => _dio;
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST: ${options.method} ${options.path}');
    print('DATA: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    print('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR: ${err.message}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:

      case DioExceptionType.receiveTimeout:
        throw NetworkException('Koneksi timeout, coba lagi');

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 404) throw ServerException('Data tidak ditemukan');
        if (statusCode == 500) throw ServerException('Server error');
        throw ServerException('Terjadi kesalahan: $statusCode');

      case DioExceptionType.unknown:
        throw NetworkException('Tidak ada koneksi internet');

      default:
        throw ServerException(err.message ?? 'Unknown error');
    }
  }
}
