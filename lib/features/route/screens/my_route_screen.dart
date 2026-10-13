import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/core/theme/app_colors.dart';
import 'package:stride/core/theme/theme_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_cubit.dart';
import 'package:stride/features/reminder/reminder_cubit/reminder_state.dart';
import 'package:stride/features/route/route_cubit/route_cubit.dart';
import 'package:stride/features/route/route_cubit/route_state.dart';
import 'package:stride/features/route/widgets/route_card_skeleton.dart';
import 'package:stride/features/route/widgets/route_card_item.dart';
import 'package:stride/widgets/item_card_switch.dart';
import 'package:stride/widgets/language_switch_button.dart';

class MyRouteScreen extends StatefulWidget {
  const MyRouteScreen({super.key});

  @override
  State<MyRouteScreen> createState() => _MyRouteScreenState();
}

class _MyRouteScreenState extends State<MyRouteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RouteCubit>().loadRoutes();
  }

  String _formatRouteDateRange(String start, String end) {
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);

      final startDayMonth =
          "${startDate.day.toString().padLeft(2, '0')}/${startDate.month.toString().padLeft(2, '0')}";
      final endDayMonth =
          "${endDate.day.toString().padLeft(2, '0')}/${endDate.month.toString().padLeft(2, '0')}";

      if (startDate.year == endDate.year) {
        return "$startDayMonth - $endDayMonth/${endDate.year}";
      } else {
        return "$startDayMonth/${startDate.year} - $endDayMonth/${endDate.year}";
      }
    } catch (e) {
      return "$start - $end";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.light;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.status == AuthStatus.authenticated) {
          context.read<RouteCubit>().loadRoutes();
        }
      },
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          forceMaterialTransparency: true,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
          title: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                SizedBox(
                  width: 135,
                  height: 39.15,
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_logo.svg',
                        height: 29,
                        colorFilter: ColorFilter.mode(
                          colors.ink,
                          BlendMode.srcIn,
                        ),
                      ),
                      Positioned(
                        top: -5,
                        right: 0,
                        child: SvgPicture.asset(
                          'assets/icons/ic_arrow_up_right.svg',
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisSize: .min,
                  children: [
                    const LanguageSwitchButton(),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        context.read<ThemeCubit>().toggleTheme(!isDarkMode);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colors.avatarBackground,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colors.green.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          size: 18,
                          color: colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, authState) {
                        final user = authState.user;
                        final initials = user?.displayInitials;

                        return Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                          ),
                          child: InkWell(
                            onTap: () => context.push('/profile'),
                            child: CircleAvatar(
                              radius: 21,
                              backgroundColor: colors.avatarBackground,
                              child: Text(
                                initials ?? '',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontSize: 13,
                                      fontWeight: .bold,
                                      color: colors.green,
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          color: colors.green,
          backgroundColor: colors.surface,
          strokeWidth: 2.5,
          onRefresh: () async {
            await context.read<RouteCubit>().loadRoutes();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 20,
                right: 20,
                bottom: 30,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'my_route.date_placeholder'.tr(),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                fontSize: 11,
                                fontWeight: .w600,
                                color: colors.muted,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .center,
                    children: [
                      Text(
                        'my_route.title'.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 26,
                          fontWeight: .w700,
                          color: colors.ink,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push("/route_create"),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: CircleAvatar(
                            backgroundColor: colors.accent,
                            child: SvgPicture.asset(
                              "assets/icons/ic_plus.svg",
                              colorFilter: ColorFilter.mode(
                                colors.onAccent,
                                BlendMode.srcIn,
                              ),
                              width: 21,
                              height: 21,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 255,
                    child: BlocBuilder<RouteCubit, RouteState>(
                      builder: (context, routeState) {
                        if (routeState.listStatus == RouteStatus.loading ||
                            routeState.listStatus == RouteStatus.initial) {
                          return const Center(child: RouteCardSkeletonList());
                        }

                        if (routeState.listStatus == RouteStatus.failure) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: .center,
                              children: [
                                Text(
                                  routeState.errorMessage ??
                                      'my_route.error_occurred'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colors.error,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      context.read<RouteCubit>().loadRoutes(),
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    size: 18,
                                  ),
                                  label: Text('my_route.retry'.tr()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors.ink,
                                    foregroundColor: colors.surface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (routeState.routes.isEmpty) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colors.line),
                              color: colors.surface,
                            ),
                            child: Center(
                              child: Text(
                                'my_route.empty_routes'.tr(),
                                style: TextStyle(
                                  color: colors.muted,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          itemCount: routeState.routes.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 15),
                          itemBuilder: (context, index) {
                            final route = routeState.routes[index];
                            final formattedDate = _formatRouteDateRange(
                              route.startDate,
                              route.endDate,
                            );

                            return RouteCardItem(
                              route: route,
                              formattedDate: formattedDate,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Text(
                            'my_route.today'.tr(),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 19,
                                  fontWeight: .w700,
                                  color: colors.ink,
                                ),
                          ),
                          InkWell(
                            onTap: () => context.push('/appointment'),
                            child: Text(
                              'my_route.view_schedule'.tr(),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontSize: 13,
                                    fontWeight: .w700,
                                    color: colors.green,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 135,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                            color: colors.line,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 5,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: colors.accent,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: .spaceAround,
                                crossAxisAlignment: .start,
                                children: [
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    crossAxisAlignment: .center,
                                    children: [
                                      Text(
                                        "18:00",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: colors.ink,
                                              fontSize: 23,
                                              fontWeight: .w700,
                                            ),
                                      ),
                                      Container(
                                        width: 88,
                                        height: 25,
                                        alignment: .centerLeft,
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colors.avatarBackground,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(7),
                                          ),
                                        ),
                                        child: Text(
                                          'my_route.duration_minutes'.tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: colors.muted,
                                                fontSize: 11,
                                                fontWeight: .w600,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'my_route.body_part'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: colors.ink,
                                          fontSize: 16,
                                          fontWeight: .w600,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_bell.svg',
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'my_route.reminder_notice'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: colors.muted,
                                              fontSize: 12,
                                              fontWeight: .w400,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        crossAxisAlignment: .center,
                        children: [
                          Text(
                            'my_route.review_journey'.tr(),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: colors.ink,
                                  fontSize: 19,
                                  fontWeight: .w700,
                                ),
                          ),
                          InkWell(
                            onTap: () => context.push('/diary'),
                            child: SvgPicture.asset(
                              'assets/icons/ic_arrow_up_right.svg',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 89,
                        child: Row(
                          children: [
                            Container(
                              width: 98,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/img_background.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colors.surface,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Container(
                                      width: 69,
                                      height: 25,
                                      alignment: .center,
                                      decoration: BoxDecoration(
                                        color: colors.avatarBackground,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(7),
                                        ),
                                      ),
                                      child: Text(
                                        'my_route.week_label'.tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              color: colors.green,
                                              fontSize: 11,
                                              fontWeight: .w600,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      'my_route.week_title'.tr(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: colors.ink,
                                            fontSize: 14,
                                            fontWeight: .w600,
                                          ),
                                    ),
                                    Text(
                                      'my_route.week_desc'.tr(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: colors.muted,
                                            fontSize: 12,
                                            fontWeight: .w400,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<ReminderCubit, ReminderState>(
                    buildWhen: (prev, curr) =>
                        prev.settings.enabled != curr.settings.enabled,
                    builder: (context, state) => ItemCardSwitch(
                      value: state.settings.enabled,
                      onChanged: (value) {
                        final cubit = context.read<ReminderCubit>();
                        cubit.setEnabled(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
