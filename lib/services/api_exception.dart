import 'package:dio/dio.dart';

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
          message: 'Kết nối quá thời gian quy định. Vui lòng thử lại.',
          statusCode: statusCode,
        );

      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại mạng.',
          statusCode: statusCode,
        );

      case DioExceptionType.badResponse:
        return _parseBadResponse(statusCode, data);

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Yêu cầu tới máy chủ đã bị hủy.',
          statusCode: statusCode,
        );

      default:
        return ApiException(
          message: 'Đã xảy ra lỗi không xác định. Vui lòng thử lại.',
          statusCode: statusCode,
        );
    }
  }

  /// Bóc tách các dạng response lỗi từ server
  static ApiException _parseBadResponse(int? statusCode, dynamic data) {
    String message = 'Vui lòng kiểm tra lại thông tin nhập vào.';
    Map<String, dynamic>? fieldErrors;

    if (statusCode == 413) {
      return ApiException(
        message: 'Tệp quá lớn. Bạn hãy chọn tệp khác.',
        statusCode: statusCode,
      );
    }

    if (data is Map<String, dynamic>) {
      fieldErrors = data;

      // Nếu server trả về chuỗi thông báo lỗi tổng quát trong 'detail'
      if (data.containsKey('detail')) {
        message = data['detail'].toString();
      }
      // Nếu là lỗi HTTP 500 Server Error
      else if (statusCode != null && statusCode >= 500) {
        message = 'Lỗi hệ thống máy chủ ($statusCode). Vui lòng thử lại sau.';
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
