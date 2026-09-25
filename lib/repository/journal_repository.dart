import 'package:dio/dio.dart';
import 'package:stride/model/attachment_model.dart';
import 'package:stride/model/picked_media.dart';
import 'package:stride/services/api_exception.dart';

class JournalRepository {
  final Dio _dio; // DioClient.instance

  JournalRepository({required this._dio});

  /// POST /api/v1/journals/  (JSON) → id nhật ký vừa tạo
  Future<int> createJournal({
    required String date, // "YYYY-MM-DD"
    required String title,
    String? notes,
  }) async {
    try {
      final response = await _dio.post(
        'v1/journals/',
        data: {'date': date, 'title': title, if (notes != null) 'notes': notes},
      );
      return response.data['id'] as int;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  /// POST /api/v1/journals/{id}/attachments/  (multipart) – ENDPOINT ĐỀ XUẤT
  /// Dùng cho ẢNH và FILE tài liệu. Video dùng uploadVideo (Bước 14).
  Future<AttachmentModel> uploadSmallFile({
    required int journalId,
    required String filePath,
    required String fileName, // tên gốc, VD "giao-an-tuan-5.pdf"
    required AttachmentKind kind,
    void Function(int sent, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final formData = FormData.fromMap({
        // 'file' phải trùng tên field BE khai báo.
        // filename có đuôi → Dio 5.11 tự đặt contentType (.jpg → image/jpeg, .pdf → application/pdf)
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'kind': kind.name, // "image" | "file"
      });

      final response = await _dio.post(
        'v1/journals/$journalId/attachments/',
        data: formData, // Dio tự đặt Content-Type multipart + boundary
        onSendProgress: onProgress,
        cancelToken: cancelToken,
        options: Options(
          // Upload lâu hơn request thường; Render còn có thể mất ~50s để "thức dậy"
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      return AttachmentModel.fromJson(
        response.data as Map<String, dynamic>,
        baseUrl: _dio.options.baseUrl,
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      // VD tệp tạm đã bị dọn mất → không đọc được
      throw ApiException(message: 'Không đọc được tệp. Bạn hãy chọn lại.');
    }
  }

  /// DELETE /api/v1/journals/{id}/attachments/{attachmentId}/ – ENDPOINT ĐỀ XUẤT
  Future<void> deleteAttachment({
    required int journalId,
    required int attachmentId,
  }) async {
    try {
      await _dio.delete('v1/journals/$journalId/attachments/$attachmentId/');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
