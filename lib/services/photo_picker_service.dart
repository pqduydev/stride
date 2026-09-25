import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:stride/model/picked_media.dart';
import 'package:stride/services/media_picker_exception.dart';

class PhotoPickerService {
  final ImagePicker _picker = ImagePicker();

  // Ảnh sau khi lấy được thu nhỏ + nén lại → nhẹ, gửi nhanh (mục 3.5)
  static const double _maxSide = 1920;
  static const int _quality = 80;

  /// Mở app Camera. Bấm huỷ → kết quả rỗng (không phải lỗi).
  Future<MediaPickResult> takePhoto() async {
    final file = await guardPicker(
      () => _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: _maxSide,
        maxHeight: _maxSide,
        imageQuality: _quality,
      ),
    );
    return _toResult(file == null ? [] : [file.path]);
  }

  /// Mở Photo Picker của hệ thống, cho chọn tối đa [limit] ảnh.
  Future<MediaPickResult> pickFromGallery({required int limit}) async {
    if (limit <= 0) return const MediaPickResult();

    // pickMultiImage yêu cầu limit >= 2 → chọn 1 ảnh thì dùng pickImage
    if (limit == 1) {
      final file = await guardPicker(
        () => _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: _maxSide,
          maxHeight: _maxSide,
          imageQuality: _quality,
        ),
      );
      return _toResult(file == null ? [] : [file.path]);
    }

    final files = await guardPicker(
      () => _picker.pickMultiImage(
        maxWidth: _maxSide,
        maxHeight: _maxSide,
        imageQuality: _quality,
        limit: limit,
      ),
    );
    // Android cũ có thể không tôn trọng limit → tự cắt bớt
    return _toResult(files.take(limit).map((f) => f.path).toList());
  }

  /// Lấy lại ảnh vừa chụp nếu app bị Android huỷ lúc đang mở Camera (mục 3.3).
  Future<MediaPickResult> retrieveLostPhotos() async {
    if (!Platform.isAndroid) return const MediaPickResult();
    final response = await _picker.retrieveLostData();
    if (response.isEmpty || response.type != RetrieveType.image) {
      return const MediaPickResult();
    }
    return _toResult((response.files ?? []).map((f) => f.path).toList());
  }

  Future<MediaPickResult> _toResult(List<String> paths) async {
    final accepted = <PickedMedia>[];
    for (final path in paths) {
      accepted.add(
        PickedMedia(
          path: path,
          name: path.split('/').last,
          size: await File(path).length(),
          kind: AttachmentKind.image,
        ),
      );
    }
    return MediaPickResult(accepted: accepted);
  }
}
