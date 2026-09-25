import 'package:equatable/equatable.dart';
import 'package:stride/model/picked_media.dart';

class AttachmentModel extends Equatable {
  final int id;
  final AttachmentKind kind;
  final String url;
  final String? thumbnailUrl;
  final String fileName;
  final int size;
  final int? durationSeconds;
  final bool isProcessing; // BE đang chuyển mã video, chưa xem được

  const AttachmentModel({
    required this.id,
    required this.kind,
    required this.url,
    required this.fileName,
    required this.size,
    this.thumbnailUrl,
    this.durationSeconds,
    this.isProcessing = false,
  });

  /// [baseUrl]: baseUrl của Dio, dùng khi server trả URL tương đối "/media/..."
  factory AttachmentModel.fromJson(
    Map<String, dynamic> json, {
    required String baseUrl,
  }) {
    // resolve: URL tuyệt đối giữ nguyên; "/media/a.jpg" → "https://host/media/a.jpg"
    String? resolve(String? path) =>
        path == null ? null : Uri.parse(baseUrl).resolve(path).toString();

    return AttachmentModel(
      id: json['id'] as int,
      // kind lạ → coi là file, không crash
      kind:
          AttachmentKind.values.asNameMap()[json['kind']] ??
          AttachmentKind.file,
      url: resolve(json['url'] as String)!,
      thumbnailUrl: resolve(json['thumbnail_url'] as String?),
      fileName: json['file_name'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      durationSeconds: json['duration_seconds'] as int?,
      isProcessing: json['status'] == 'processing',
    );
  }

  @override
  List<Object?> get props => [
    id,
    kind,
    url,
    thumbnailUrl,
    fileName,
    size,
    durationSeconds,
    isProcessing,
  ];
}
