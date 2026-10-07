import 'package:dio/dio.dart';

import 'api_exception.dart';

class ApiHelper {
  ApiHelper._();
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://pixabay.com/api/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),

      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Dio get client => _dio;

  static Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: e.toString(),
      );
    }
  }

  static Future<dynamic> post(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: e.toString(),
      );
    }
  }


  static Future<dynamic> put(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: e.toString(),
      );
    }
  }


  static Future<dynamic> patch(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: e.toString(),
      );
    }
  }


  static Future<dynamic> delete(
      String endpoint, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(
        message: e.toString(),
      );
    }
  }

  // ----------------------------------------------------------
  // RESPONSE HANDLER
  // ----------------------------------------------------------

  static dynamic _handleResponse(
      Response response,
      ) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 200 && statusCode < 300) {
      return response.data;
    }

    throw ApiException(
      message: _extractMessage(response.data),
      statusCode: statusCode,
    );
  }

  // ----------------------------------------------------------
  // DIO ERROR HANDLER
  // ----------------------------------------------------------

  static ApiException _handleDioException(
      DioException error,
      ) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const ApiException(
          message: 'Connection timeout. Please try again.',
        );

      case DioExceptionType.sendTimeout:
        return const ApiException(
          message: 'Request timeout. Please try again.',
        );

      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Server response timeout. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection.',
        );

      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Secure connection failed.',
        );

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
        );

      case DioExceptionType.badResponse:
        final response = error.response;

        return ApiException(
          message: _extractMessage(
            response?.data,
          ),
          statusCode: response?.statusCode,
        );

      case DioExceptionType.unknown:
        return ApiException(
          message: error.message ?? 'Something went wrong.',
        );
      case DioExceptionType.transformTimeout:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  // ----------------------------------------------------------
  // EXTRACT SERVER ERROR MESSAGE
  // ----------------------------------------------------------

  static String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['detail']?.toString() ??
          data['error']?.toString() ??
          'Something went wrong.';
    }

    return 'Something went wrong.';
  }
}