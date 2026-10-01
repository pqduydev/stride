import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stride/core/utils/reminder_time_calculator.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_cubit.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_state.dart';
import 'package:stride/widgets/item_card_switch.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  static const _minutesOptions = [0, 5, 15, 30, 60];
  static const _weekdayLabels = {
    DateTime.monday: 'T2',
    DateTime.tuesday: 'T3',
    DateTime.wednesday: 'T4',
    DateTime.thursday: 'T5',
    DateTime.friday: 'T6',
    DateTime.saturday: 'T7',
    DateTime.sunday: 'CN',
  };

  @override
  void initState() {
    super.initState();
    context.read<ReminderCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nhắc giờ tập')),
      body: BlocConsumer<ReminderCubit, ReminderState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ReminderStatus.saved) {
            final message = state.successMessage ?? "Lưu nhắc hẹn thành công";
            final isDisabledAction = message == "Đã tắt nhắc hẹn";

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  message,
                  style: TextStyle(
                    color: isDisabledAction
                        ? Colors.white
                        : const Color(0xFF526C30),
                  ),
                ),
                backgroundColor: isDisabledAction
                    ? Colors.orangeAccent
                    : const Color(0xFFEEF4E5),
              ),
            );
          } else if (state.status == ReminderStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Color(0xFFFFFFFF)),
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ReminderStatus.initial ||
              state.status == ReminderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final cubit = context.read<ReminderCubit>();
          final settings = state.settings;
          final next = ReminderTimeCalculator.nextReminder(
            settings,
            DateTime.now(),
          );
          final isSaving = state.status == ReminderStatus.saving;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ItemCardSwitch(
                value: settings.enabled,
                onChanged: cubit.setEnabled,
              ),
              const SizedBox(height: 24),

              // GIỜ TẬP
              const Text('GIỜ TẬP'),
              InkWell(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: settings.hour,
                      minute: settings.minute,
                    ),
                  );
                  if (picked != null) cubit.setTime(picked.hour, picked.minute);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    '${_two(settings.hour)} : ${_two(settings.minute)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // LẶP LẠI MỖI TUẦN
              const Text('Lặp lại mỗi tuần'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final entry in _weekdayLabels.entries)
                    ChoiceChip(
                      label: Text(entry.value),
                      selected: settings.weekdays.contains(entry.key),
                      onSelected: (_) => cubit.toggleWeekday(entry.key),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // NHẮC TRƯỚC
              const Text('Nhắc trước'),
              DropdownButton<int>(
                value: settings.minutesBefore,
                isExpanded: true,
                items: [
                  for (final m in _minutesOptions)
                    DropdownMenuItem(value: m, child: Text(_minutesLabel(m))),
                ],
                onChanged: (m) {
                  if (m != null) cubit.setMinutesBefore(m);
                },
              ),
              const SizedBox(height: 24),

              // LẦN TIẾP THEO / ĐANG TẠM TẮT
              Text(
                !settings.enabled
                    ? 'Nhắc hẹn đang tạm tắt'
                    : next == null
                    ? 'Chưa chọn ngày tập'
                    : 'Lần tiếp theo: ${_formatNext(next)}',
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: isSaving ? null : cubit.save,
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Lưu nhắc hẹn'),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _minutesLabel(int minutes) => switch (minutes) {
    0 => 'Đúng giờ',
    60 => '1 giờ',
    _ => '$minutes phút',
  };

  static String _formatNext(DateTime date) {
    const names = [
      'Chủ Nhật',
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
    ];
    return '${names[date.weekday % 7]}, ${DateFormat('dd/MM').format(date)} '
        'lúc ${DateFormat('HH:mm').format(date)}';
  }
}
