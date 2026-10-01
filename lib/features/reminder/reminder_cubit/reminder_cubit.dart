import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_state.dart';
import 'package:stride/features/reminder/reminder_scheduler.dart';
import 'package:stride/model/reminder_settings.dart';
import 'package:stride/repository/reminder_settings_repository.dart';

class ReminderCubit extends Cubit<ReminderState> {
  final ReminderSettingsRepository _repository;
  final ReminderScheduler _scheduler;

  ReminderCubit(this._repository, this._scheduler)
    : super(const ReminderState());

  /// Đọc cài đặt đã lưu. Gọi mỗi lần mở màn → bỏ các chỉnh sửa chưa lưu.
  Future<void> load() async {
    emit(
      state.copyWith(status: ReminderStatus.loading, clearErrorMessage: true),
    );
    final settings = await _repository.load();
    if (isClosed) return;
    emit(state.copyWith(status: ReminderStatus.ready, settings: settings));
  }

  /// Gạt công tắc Bật/Tắt
  Future<void> setEnabled(bool value) async {
    // 1. Cập nhật trạng thái Bật/Tắt vào state
    _edit(state.settings.copyWith(enabled: value));

    // 2. Tự động lưu và thiết lập lại lịch ngầm ngay lập tức (cho cả Bật và Tắt)
    await save(message: value ? 'Đã bật nhắc hẹn' : 'Đã tắt nhắc hẹn');
  }

  void setTime(int hour, int minute) =>
      _edit(state.settings.copyWith(hour: hour, minute: minute));

  void setMinutesBefore(int minutes) =>
      _edit(state.settings.copyWith(minutesBefore: minutes));

  void toggleWeekday(int weekday) {
    final days = {...state.settings.weekdays}; // tạo Set MỚI, không sửa Set cũ
    if (!days.remove(weekday)) days.add(weekday);
    _edit(state.settings.copyWith(weekdays: days));
  }

  void _edit(ReminderSettings settings) {
    emit(
      state.copyWith(
        status: ReminderStatus.ready,
        settings: settings,
        clearErrorMessage: true,
      ),
    );
  }

  Future<void> save({String? message}) async {
    final settings = state.settings;

    if (settings.weekdays.isEmpty) {
      emit(
        state.copyWith(
          status: ReminderStatus.failure,
          errorMessage: 'Hãy chọn ít nhất một ngày trong tuần.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: ReminderStatus.saving,
        clearErrorMessage: true,
        clearSuccessMessage: true,
      ),
    );

    try {
      if (settings.enabled) await _scheduler.ensurePermission();

      await _repository.save(settings);
      await _scheduler.apply(settings);
      if (isClosed) return;

      emit(
        state.copyWith(
          status: ReminderStatus.saved,
          successMessage: message ?? 'Lưu nhắc hẹn thành công',
        ),
      );
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ReminderStatus.failure,
          errorMessage: e.toString().split(': ').last,
        ),
      );
    }
  }
}
