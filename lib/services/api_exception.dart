import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? fieldErrors;

  ApiException({required this.message, this.statusCode, this.fieldErrors});

  factory ApiException.fromDioException(DioException dioException) {
    final statusCode = dioException.response?.statusCode;
    final data = dioException.response?.data;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'api_exception.timeout'.tr(),
          statusCode: statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'api_exception.connection_error'.tr(),
          statusCode: statusCode,
        );

      case DioExceptionType.badResponse:
        return _parseBadResponse(statusCode, data);

      case DioExceptionType.cancel:
        return ApiException(
          message: 'api_exception.cancel'.tr(),
          statusCode: statusCode,
        );

      default:
        return ApiException(
          message: 'api_exception.unknown'.tr(),
          statusCode: statusCode,
        );
    }
  }

  /// Bóc tách các dạng response lỗi từ server
  static ApiException _parseBadResponse(int? statusCode, dynamic data) {
    String message = 'api_exception.bad_response_default'.tr();
    Map<String, dynamic>? fieldErrors;

    if (statusCode == 413) {
      return ApiException(
        message: 'api_exception.file_too_large'.tr(),
        statusCode: statusCode,
      );
    }

    if (data is Map<String, dynamic>) {
      fieldErrors = data;

      // Nếu server trả về chuỗi thông báo lỗi tổng quát trong 'detail'
      if (data.containsKey('detail')) {
        message = data['detail'].toString();
      }
      // Kiểm tra lỗi chung non_field_errors từ BE
      else if (data.containsKey('non_field_errors')) {
        final errors = data['non_field_errors'];
        message = errors is List ? errors.join(', ') : errors.toString();
      }
      // Nếu là lỗi HTTP 500 Server Error
      else if (statusCode != null && statusCode >= 500) {
        message = 'api_exception.server_error'.tr(
          args: [statusCode.toString()],
        );
      }
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      fieldErrors: fieldErrors,
    );
  }

  @override
  String toString() => message;
}
