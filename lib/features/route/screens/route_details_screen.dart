import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';
import 'package:stride/widgets/item_bottom_button.dart';

class RouteDetailsScreen extends StatelessWidget {
  const RouteDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppbarCustom(
            title: ItemAppBarTitle(data: 'route_details.appbar_title'.tr()),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Container(
                width: 183,
                height: 25,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: .center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: const Color(0xFFEEF4E5),
                ),
                child: Text(
                  'route_details.tag_health'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF526C30),
                    fontSize: 11,
                    fontWeight: .w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'route_details.title_main'.tr(),
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 29,
                  fontWeight: .w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'route_details.subtitle'.tr(),
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 14,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 145,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/img_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      width: 157,
                      height: 25,
                      alignment: .center,
                      margin: const EdgeInsets.only(left: 15, bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: const Text(
                        "17/08 – 17/11/2026",
                        style: TextStyle(
                          color: Color(0xFF1C2520),
                          fontSize: 11,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 81,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8ECE8), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        const Text(
                          "12 / 40",
                          style: TextStyle(
                            color: Color(0xFF1C2520),
                            fontSize: 21,
                            fontWeight: .w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'route_details.completed_sessions'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 11,
                            fontWeight: .w400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "3 ${'route_details.weekly_unit'.tr()}",
                          style: const TextStyle(
                            color: Color(0xFF1C2520),
                            fontSize: 21,
                            fontWeight: .w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'route_details.weekly_frequency'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 11,
                            fontWeight: .w400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        const Text(
                          "64",
                          style: TextStyle(
                            color: Color(0xFF1C2520),
                            fontSize: 21,
                            fontWeight: .w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'route_details.remaining_days'.tr(),
                          style: const TextStyle(
                            color: Color(0xFF768079),
                            fontSize: 11,
                            fontWeight: .w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      height: 42,
                      padding: const EdgeInsets.all(5),
                      alignment: .center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBEEE9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        labelStyle: const TextStyle(
                          color: Color(0xFF1C2520),
                          fontSize: 13,
                          fontWeight: .w600,
                        ),
                        unselectedLabelColor: const Color(0xFF768079),
                        indicator: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        tabs: [
                          Tab(text: 'route_details.tab_overview'.tr()),
                          Tab(text: 'route_details.tab_schedule'.tr()),
                          Tab(text: 'route_details.tab_diary'.tr()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: TabBarView(
                        children: [
                          const _OverView(),
                          Center(
                            child: Text('route_details.tab_schedule'.tr()),
                          ),
                          Center(child: Text('route_details.tab_diary'.tr())),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ItemBottomButton(
          text: 'route_details.btn_view_schedule'.tr(),
          onTap: () {},
        ),
      ),
    );
  }
}

class _OverView extends StatelessWidget {
  const _OverView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'route_details.milestones_title'.tr(),
          style: const TextStyle(
            color: Color(0xFF1C2520),
            fontSize: 18,
            fontWeight: .w700,
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ListView(
            children: [
              _BuildTabViewContent(
                number: "01",
                title: 'route_details.milestone_1_title'.tr(),
                timeLine: 'route_details.milestone_1_time'.tr(),
                inProgress: true,
              ),
              const SizedBox(height: 15),
              _BuildTabViewContent(
                number: "02",
                title: 'route_details.milestone_2_title'.tr(),
                timeLine: 'route_details.milestone_2_time'.tr(),
                inProgress: false,
              ),
              const SizedBox(height: 15),
              _BuildTabViewContent(
                number: "03",
                title: 'route_details.milestone_3_title'.tr(),
                timeLine: 'route_details.milestone_3_time'.tr(),
                inProgress: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuildTabViewContent extends StatelessWidget {
  final String number;
  final String title;
  final String timeLine;
  final bool inProgress;

  const _BuildTabViewContent({
    required this.number,
    required this.title,
    required this.timeLine,
    this.inProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        SizedBox(
          width: 34,
          height: 34,
          child: CircleAvatar(
            backgroundColor: inProgress
                ? const Color(0xFFEEF4E5)
                : const Color(0xFFECEFEB),
            child: Text(
              number,
              style: TextStyle(
                color: inProgress
                    ? const Color(0xFF526C30)
                    : const Color(0xFF768079),
                fontSize: 12,
                fontWeight: .w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1C2520),
                  fontSize: 15,
                  fontWeight: .w600,
                ),
              ),
              Text(
                inProgress
                    ? "$timeLine · ${'route_details.in_progress'.tr()}"
                    : timeLine,
                style: const TextStyle(
                  color: Color(0xFF768079),
                  fontSize: 12,
                  fontWeight: .w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
