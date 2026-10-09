import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static void showSuccess(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xFF526C30),
        ),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      primaryColor: const Color(0xFF526C30),
      backgroundColor: const Color(0xFFEEF4E5),
      foregroundColor: const Color(0xFF526C30),
      icon: const Icon(Icons.check_circle, color: Color(0xFF526C30), size: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 5, right: 20),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      showProgressBar: false,
      dragToClose: true,
    );
  }

  static void showError(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xFFD32F2F),
        ),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      primaryColor: const Color(0xFFD32F2F),
      backgroundColor: const Color(0xFFFDE8E8),
      foregroundColor: const Color(0xFFD32F2F),
      icon: const Icon(Icons.error, color: Color(0xFFD32F2F), size: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 5, right: 20),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      showProgressBar: false,
      dragToClose: true,
    );
  }

  static void showWarning(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xFFE65100),
        ),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      primaryColor: const Color(0xFFE65100),
      backgroundColor: const Color(0xFFFFF4E5),
      foregroundColor: const Color(0xFFE65100),
      icon: const Icon(
        Icons.warning_rounded,
        color: Color(0xFFE65100),
        size: 20,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 5, right: 20),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      showProgressBar: false,
      dragToClose: true,
    );
  }

  static void showInfo(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Color(0xFF1565C0),
        ),
      ),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 3),
      primaryColor: const Color(0xFF1565C0),
      backgroundColor: const Color(0xFFE8F4FD),
      foregroundColor: const Color(0xFF1565C0),
      icon: const Icon(Icons.info, color: Color(0xFF1565C0), size: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 5, right: 20),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      showProgressBar: false,
      dragToClose: true,
    );
  }
}
