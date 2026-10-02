import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class OnboardingPermissionScreen extends StatefulWidget {
  const OnboardingPermissionScreen({super.key});

  @override
  State<OnboardingPermissionScreen> createState() =>
      _OnboardingPermissionScreenState();
}

class _OnboardingPermissionScreenState
    extends State<OnboardingPermissionScreen> {
  bool _isProcessing = false;

  Future<void> _handlePermissions(
    BuildContext context, {
    required bool shouldRequest,
  }) async {
    // Chặn người dùng spam click nhiều lần
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      if (!shouldRequest) {
        if (context.mounted) {
          await _finishOnboarding(context);
        }
        return;
      }

      // 1. Kiểm tra trạng thái TRƯỚC KHI gọi request()
      final initialCameraStatus = await Permission.camera.status;
      final initialNotificationStatus = await Permission.notification.status;

      final wasCameraPermanentlyDenied =
          initialCameraStatus.isPermanentlyDenied;
      final wasNotificationPermanentlyDenied =
          initialNotificationStatus.isPermanentlyDenied;

      // 2. Chỉ gọi request() đối với các quyền CHƯA bị chặn vĩnh viễn từ trước
      if (!wasCameraPermanentlyDenied) {
        await Permission.camera.request();
      }
      if (!wasNotificationPermanentlyDenied) {
        await Permission.notification.request();
      }

      if (!context.mounted) return;

      // 3. CHỈ hiện Dialog mở Cài đặt nếu quyền đó ĐÃ BỊ CHẶN VĨNH VIỄN TỪ TRƯỚC
      if (wasCameraPermanentlyDenied || wasNotificationPermanentlyDenied) {
        final shouldOpenSettings = await _showPermanentlyDeniedDialog(context);
        if (shouldOpenSettings == true) {
          await openAppSettings();
        }
      }

      // 4. Lưu trạng thái hoàn tất và chuyển vào màn hình chính
      if (context.mounted) {
        await _finishOnboarding(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    await context.read<AuthCubit>().completePermissionOnboarding();
  }

  // Dialog thông báo khi bị từ chối vĩnh viễn
  Future<bool?> _showPermanentlyDeniedDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Bắt buộc người dùng tương tác với Dialog
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Cần mở Cài đặt thiết bị',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Một số quyền truy cập đã bị tắt trước đó. Bạn có muốn mở Cài đặt ứng dụng để bật thủ công không?',
          style: TextStyle(fontSize: 14, color: Color(0xFF768079)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Để sau', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Mở Cài đặt',
              style: TextStyle(
                color: Color(0xFF526C30),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cá nhân hóa\ntrải nghiệm của bạn',
                style: TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Stride cần một số quyền truy cập để giúp hành trình của bạn trọn vẹn nhất.',
                style: TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),

              _buildInfoRow(
                title: 'Máy ảnh',
                description: 'Chụp ảnh và lưu trữ nhật ký hình ảnh trong tiến trình của bạn.',
                icon: Icons.camera_alt_outlined,
              ),
              const SizedBox(height: 25),

              _buildInfoRow(
                title: 'Thông báo',
                description: 'Nhận lời nhắc về lịch hẹn và các mục tiêu đã lên kế hoạch.',
                icon: Icons.notifications_none_outlined,
              ),

              const Spacer(),

              // Nút Cho phép
              ItemBottomButton(
                text: 'Cấp quyền truy cập',
                isLoading: _isProcessing,
                onTap: _isProcessing
                    ? null
                    : () => _handlePermissions(context, shouldRequest: true),
              ),
              const SizedBox(height: 15),

              // Nút Bỏ qua (Để sau)
              ItemBottomButton(
                text: 'Để sau',
                backgroundColor: const Color(0xFFFFFFFF),
                textColor: const Color(0xFF768079),
                borderColor: Colors.transparent,
                borderWidth: 0,
                onTap: _isProcessing
                    ? null
                    : () => _handlePermissions(context, shouldRequest: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEEF4E5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF526C30)),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
