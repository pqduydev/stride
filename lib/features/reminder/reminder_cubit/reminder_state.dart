import 'package:equatable/equatable.dart';
import 'package:stride/model/reminder_settings.dart';

enum ReminderStatus { initial, loading, ready, saving, saved, failure }

class ReminderState extends Equatable {
  final ReminderStatus status;
  final ReminderSettings settings;
  final String? errorMessage;
  final String? successMessage;

  const ReminderState({
    this.status = ReminderStatus.initial,
    this.settings = const ReminderSettings(),
    this.errorMessage,
    this.successMessage,
  });

  ReminderState copyWith({
    ReminderStatus? status,
    ReminderSettings? settings,
    String? errorMessage,
    String? successMessage,
    bool clearErrorMessage = false,
    bool clearSuccessMessage = false,
  }) {
    return ReminderState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccessMessage
          ? null
          : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [status, settings, errorMessage, successMessage];
}
