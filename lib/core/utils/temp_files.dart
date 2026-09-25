// temp_files.dart
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Xoá bản sao tệp trong cache của app sau khi đã gửi lên server.
/// Chỉ xoá tệp NẰM TRONG cache → không bao giờ đụng vào tệp gốc của người dùng.
Future<void> deleteTempFiles(Iterable<String> paths) async {
  final cacheDir = (await getTemporaryDirectory()).path;
  for (final path in paths) {
    if (!path.startsWith(cacheDir)) continue;
    try {
      await File(path).delete();
    } catch (_) {
      // Đã bị xoá rồi → bỏ qua
    }
  }
}
