import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stride/core/utils/app_toast.dart';
import 'package:stride/core/utils/reminder_time_calculator.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_cubit.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_state.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart' show ItemAppBarTitle;
import 'package:stride/widgets/item_bottom_button.dart';
import 'package:stride/widgets/item_card_switch.dart';

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  static const _minutesOptions = [0, 5, 15, 30, 60];

  static const _weekdayKeys = {
    DateTime.monday: 'reminder_settings.weekdays.mon',
    DateTime.tuesday: 'reminder_settings.weekdays.tue',
    DateTime.wednesday: 'reminder_settings.weekdays.wed',
    DateTime.thursday: 'reminder_settings.weekdays.thu',
    DateTime.friday: 'reminder_settings.weekdays.fri',
    DateTime.saturday: 'reminder_settings.weekdays.sat',
    DateTime.sunday: 'reminder_settings.weekdays.sun',
  };

  @override
  void initState() {
    super.initState();
    context.read<ReminderCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(
            data: 'reminder_settings.appbar_title'.tr(),
            padding: 5,
          ),
        ),
      ),
      body: BlocConsumer<ReminderCubit, ReminderState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          if (state.status == ReminderStatus.saved) {
            final message =
                state.successMessage ?? 'reminder_settings.success_save'.tr();
            final isDisabledAction =
                message == "Đã tắt nhắc hẹn" ||
                message == 'reminder_settings.success_disable'.tr();

            isDisabledAction
                ? AppToast.showWarning(
                    context,
                    'reminder_settings.success_disable'.tr(),
                  )
                : AppToast.showSuccess(
                    context,
                    'reminder_settings.success_save'.tr(),
                  );
          } else if (state.status == ReminderStatus.failure &&
              state.errorMessage != null) {
            AppToast.showError(context, state.errorMessage!);
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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            children: [
              ItemCardSwitch(
                value: settings.enabled,
                onChanged: cubit.setEnabled,
              ),
              const SizedBox(height: 24),

              // GIỜ TẬP
              Text(
                'reminder_settings.section_time'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 12,
                  fontWeight: .w600,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15, bottom: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE8ECE8),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                child: InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: settings.hour,
                        minute: settings.minute,
                      ),
                    );
                    if (picked != null) {
                      cubit.setTime(picked.hour, picked.minute);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      '${_two(settings.hour)} : ${_two(settings.minute)}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 48, fontWeight: .w700),
                    ),
                  ),
                ),
              ),

              // LẶP LẠI MỖI TUẦN
              Text(
                'reminder_settings.repeat_weekly'.tr(),
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 15,
                  fontWeight: .w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final entry in _weekdayKeys.entries)
                    ChoiceChip(
                      showCheckmark: false,
                      backgroundColor: const Color(0xFFFFFFFF),
                      selectedColor: const Color(0xFF1C2520),
                      label: Text(entry.value.tr()),
                      labelStyle: TextStyle(
                        color: settings.weekdays.contains(entry.key)
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF768079),
                        fontWeight: .w500,
                      ),
                      selected: settings.weekdays.contains(entry.key),
                      onSelected: (_) => cubit.toggleWeekday(entry.key),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: settings.weekdays.contains(entry.key)
                            ? Colors.transparent
                            : const Color(0xFFE8ECE8),
                        width: 1,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // NHẮC TRƯỚC
              Text(
                'reminder_settings.remind_before'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 13,
                  fontWeight: .w500,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 30),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 2.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: settings.minutesBefore,
                    isExpanded: true,
                    icon: SvgPicture.asset(
                      'assets/icons/ic_chevron_down.svg',
                      width: 20,
                      height: 20,
                    ),
                    items: [
                      for (final m in _minutesOptions)
                        DropdownMenuItem(
                          value: m,
                          child: Text(
                            _minutesLabel(m),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1C2520),
                              fontWeight: .w500,
                            ),
                          ),
                        ),
                    ],
                    onChanged: (m) {
                      if (m != null) cubit.setMinutesBefore(m);
                    },
                  ),
                ),
              ),

              // LẦN TIẾP THEO / ĐANG TẠM TẮT
              Text(
                !settings.enabled
                    ? 'reminder_settings.status_disabled'.tr()
                    : next == null
                    ? 'reminder_settings.status_no_date'.tr()
                    : _formatNext(next),
                style: const TextStyle(
                  color: Color(0xFF526C30),
                  fontSize: 12,
                  fontWeight: .w500,
                ),
              ),
              const SizedBox(height: 20),

              ItemBottomButton(
                text: 'reminder_settings.btn_save'.tr(),
                isLoading: isSaving,
                onTap: isSaving ? null : cubit.save,
              ),
            ],
          );
        },
      ),
    );
  }

  static String _two(int n) => n.toString().padLeft(2, '0');

  static String _minutesLabel(int minutes) => switch (minutes) {
    0 => 'reminder_settings.minutes.exact'.tr(),
    60 => 'reminder_settings.minutes.one_hour'.tr(),
    _ => 'reminder_settings.minutes.n_minutes'.tr(args: [minutes.toString()]),
  };

  static String _formatNext(DateTime date) {
    const weekdayKeys = [
      'reminder_settings.weekdays.full_sun',
      'reminder_settings.weekdays.full_mon',
      'reminder_settings.weekdays.full_tue',
      'reminder_settings.weekdays.full_wed',
      'reminder_settings.weekdays.full_thu',
      'reminder_settings.weekdays.full_fri',
      'reminder_settings.weekdays.full_sat',
    ];
    final weekday = weekdayKeys[date.weekday % 7].tr();
    final dateStr = DateFormat('dd/MM').format(date);
    final timeStr = DateFormat('HH:mm').format(date);
    return 'reminder_settings.status_next_format'.tr(
      args: [weekday, dateStr, timeStr],
    );
  }
}
