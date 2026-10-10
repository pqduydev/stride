import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/core/utils/app_toast.dart';
import 'package:stride/model/picked_media.dart';
import 'package:stride/services/media_picker_exception.dart';
import 'package:stride/services/photo_picker_service.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class AddImageScreen extends StatefulWidget {
  final int maxImages;

  const AddImageScreen({super.key, this.maxImages = 4});

  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  final _picker = PhotoPickerService();
  final List<PickedMedia> _picked = [];
  final Set<String> _selected = {};

  int get _remaining => widget.maxImages - _selected.length;

  @override
  void initState() {
    super.initState();
    _recoverLostPhotos();
  }

  Future<void> _recoverLostPhotos() async {
    final result = await _picker.retrieveLostPhotos();
    if (result.accepted.isEmpty || !mounted) return;
    _addPicked(result.accepted);
  }

  void _addPicked(List<PickedMedia> photos) {
    setState(() {
      _picked.insertAll(0, photos);
      _selected.addAll(photos.map((file) => file.path).take(_remaining));
    });
  }

  Future<void> _takePhoto() async {
    if (_remaining < 0) {
      _showMessage(
        tr('add_image.error_max_limit', args: [widget.maxImages.toString()]),
      );
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

  Future<void> _pickFromGallery() async {
    if (_remaining < 0) {
      _showMessage(
        tr('add_image.error_max_limit', args: [widget.maxImages.toString()]),
      );
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

  void _toggle(String path) {
    setState(() {
      if (_selected.contains(path)) {
        _selected.remove(path);
      } else if (_remaining > 0) {
        _selected.add(path);
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    AppToast.showError(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'add_image.title'.tr()),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'add_image.subtitle'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: _takePhoto,
                child: Container(
                  height: 61,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF4E5),
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                        'add_image.btn_camera'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF526C30),
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
                    'add_image.section_recent'.tr(),
                    style: const TextStyle(
                      color: Color(0xFF1C2520),
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
                                  'add_image.btn_gallery'.tr(),
                                  style: const TextStyle(
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
                'add_image.description'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: ItemBottomButton(
          text: _selected.isEmpty
              ? 'add_image.btn_select'.tr()
              : tr(
                  'add_image.btn_add_count',
                  args: [_selected.length.toString()],
                ),
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
            child: Image.file(File(path), fit: BoxFit.cover, cacheWidth: 400),
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
