import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/model/picked_media.dart';
import 'package:stride/services/media_picker_exception.dart';
import 'package:stride/services/photo_picker_service.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class AddImageScreen extends StatefulWidget {
  final int
  maxImages; // Số ảnh tối đa khi chọn thêm (được thêm và được chọn khác nhau)

  const AddImageScreen({super.key, this.maxImages = 4});

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  final _picker = PhotoPickerService();
  // Ảnh được chụp/chọn trong lần thêm ảnh này (được chọn không giới hạn)
  final List<PickedMedia> _picked = [];
  // Danh sách path của các ảnh được tick thêm (không trùng, giới hạn số ảnh được thêm)
  final Set<String> _selected = {};

  int get _remaining =>
      widget.maxImages -
      _selected.length; // Tính số lượng ảnh còn lại được phép thêm

  @override
  void initState() {
    super.initState();
    _recoverLostPhotos();
  }

  // Lấy lại ảnh bị "rơi"
  Future<void> _recoverLostPhotos() async {
    final result = await _picker.retrieveLostPhotos();
    if (result.accepted.isEmpty || !mounted) return;
    _addPicked(result.accepted);
  }

  // Cập nhật danh sách đã chọn và được thêm
  void _addPicked(List<PickedMedia> photos) {
    setState(() {
      _picked.insertAll(0, photos);
      // Ảnh mới được tick sẵn. Dựa trên _remaining để quyết số lượng ảnh sẽ được tick
      _selected.addAll(photos.map((file) => file.path).take(_remaining));
    });
  }

  // Chụp ảnh
  Future<void> _takePhoto() async {
    if (_remaining < 0) {
      _showMessage('Bạn chỉ thêm được tối đa ${widget.maxImages} ảnh.');
      return;
    }

    try {
      final result = await _picker.takePhoto();
      if (!mounted) return;

      _addPicked(result.accepted);
    } on MediaPickerException catch (e) {
      _showMessage(e.message);
    }
  }

  // Chọn ảnh từ thư viện
  Future<void> _pickFromGallery() async {
    if (_remaining < 0) {
      _showMessage('Bạn chỉ thêm được tối đa ${widget.maxImages} ảnh.');
      return;
    }

    try {
      final result = await _picker.pickFromGallery(limit: _remaining);
      if (!mounted) return;

      _addPicked(result.accepted);
    } on MediaPickerException catch (e) {
      _showMessage(e.message);
    }
  }

  // Bỏ/tick thêm ảnh
  void _toggle(String path) {
    setState(() {
      if (_selected.contains(path)) {
        _selected.remove(path);
      } else if (_remaining > 0) {
        _selected.add(path);
      }
    });
  }

  // Hiện thông báo
  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(title: ItemAppBarTitle(data: 'Thêm hình ảnh')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Chọn ảnh để lưu vào nhật ký.",
                style: TextStyle(
                  color: const Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 61,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF4E5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: _takePhoto,
                  child: Row(
                    crossAxisAlignment: .center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/ic_camera.svg",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Chụp ảnh mới",
                        style: TextStyle(
                          color: const Color(0xFF526C30),
                          fontSize: 16,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    "Ảnh gần đây",
                    style: TextStyle(
                      color: const Color(0xFF1C2520),
                      fontSize: 18,
                      fontWeight: .w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.95,
                    children: [
                      for (final photo in _picked) ...[
                        _PhotoTile(
                          path: photo.path,
                          selected: _selected.contains(photo.path),
                          onTap: () => _toggle(photo.path),
                        ),
                      ],

                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EEE4),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: InkWell(
                            onTap: _pickFromGallery,
                            child: Column(
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .center,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/ic_image.svg",
                                  width: 36,
                                  height: 36,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Ảnh của bạn",
                                  style: TextStyle(
                                    color: Color(0xFF768079),
                                    fontSize: 12,
                                    fontWeight: .w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                """Lưu lại những khoảnh khắc trên hành trình. Bạn có thể thêm ảnh phòng tập, bài tập hoặc ảnh ghi lại sự thay đổi của mình.""",
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
                textDirection: .ltr,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: ItemBottomButton(
          text: _selected.isEmpty ? 'Chọn ảnh' : 'Thêm ${_selected.length} ảnh',
          onTap: () => context.pop(
            _picked.where((file) => _selected.contains(file.path)).toList(),
          ),
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String path;
  final bool selected;
  final VoidCallback onTap;

  const _PhotoTile({
    required this.path,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
              cacheWidth: 400, // chỉ giải mã ảnh nhỏ cho ô lưới → đỡ tốn RAM
            ),
          ),
          if (selected)
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: const Color(0xFFD2F36B),
                child: SvgPicture.asset(
                  'assets/icons/ic_check.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
