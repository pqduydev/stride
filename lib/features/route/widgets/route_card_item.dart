import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/model/route_model.dart';

class RouteCardItem extends StatelessWidget {
  final RouteModel route;
  final String formattedDate;

  const RouteCardItem({
    super.key,
    required this.route,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: const Color(0xFFE8ECE8),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push("/route_edit", extra: route),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img_background.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF202C25).withValues(alpha: 0.64),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      // Tag Mục tiêu đã đa ngôn ngữ hóa
                      Container(
                        height: 25,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD2F36B),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Center(
                          widthFactor: 1,
                          child: Text(
                            tr(
                              'route_card.goal_format',
                              args: [route.durationText],
                            ).toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontSize: 11,
                                  fontWeight: .w600,
                                  color: const Color(0xFF1C2520),
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            route.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  color: const Color(0xFFFFFFFF),
                                  fontSize: 25,
                                  fontWeight: .w700,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            formattedDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: const Color(0xFFE4EBE3),
                                  fontSize: 12,
                                  fontWeight: .w400,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .center,
                    children: [
                      Expanded(
                        child: Text(
                          'route_card.completed_label'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: const Color(0xFF768079),
                                fontSize: 13,
                                fontWeight: .w400,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "12 / 40 ${'route_card.sessions_unit'.tr()}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF1C2520),
                          fontSize: 14,
                          fontWeight: .w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Container(
                    height: 7,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8ECE8),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: FractionallySizedBox(
                      alignment: .centerLeft,
                      widthFactor: 0.37,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF526C30),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .center,
                    children: [
                      Expanded(
                        child: Text(
                          'route_card.week_label'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: const Color(0xFF768079),
                                fontSize: 13,
                                fontWeight: .w400,
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "30%",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF526C30),
                          fontSize: 14,
                          fontWeight: .w700,
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
    );
  }
}
