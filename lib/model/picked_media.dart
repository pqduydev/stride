import 'package:equatable/equatable.dart';

enum AttachmentKind { image, video, file }

/// Một tệp đã chọn trên máy, đã qua kiểm tra, chưa gửi lên server.
class PickedMedia extends Equatable {
  final String path; // bản sao trong cache của app
  final String name; // tên hiển thị, VD "giao-an-tuan-5.pdf"
  final int size; // bytes
  final AttachmentKind kind;
  final Duration? duration; // chỉ video

  const PickedMedia({
    required this.path,
    required this.name,
    required this.size,
    required this.kind,
    this.duration,
  });

  @override
  List<Object?> get props => [path, name, size, kind, duration];
}

/// Kết quả một lần chọn: tệp hợp lệ + lý do các tệp bị loại.
class MediaPickResult {
  final List<PickedMedia> accepted;
  final List<String> rejected; // câu tiếng Việt, hiện cho người dùng

  const MediaPickResult({this.accepted = const [], this.rejected = const []});
}
