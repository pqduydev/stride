import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stride/features/auth/auth_cubit/auth_cubit.dart';
import 'package:stride/features/auth/auth_cubit/auth_state.dart';
import 'package:stride/widgets/appbar_custom.dart';
import 'package:stride/widgets/item_app_bar_title.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppbarCustom(
          title: ItemAppBarTitle(data: 'profile.appbar_title'.tr()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
        child: Column(
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                final user = authState.user;
                final initials = user?.displayInitials;
                final name = user?.displayName;

                return Row(
                  crossAxisAlignment: .center,
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      margin: const EdgeInsets.only(right: 20),
                      alignment: .center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF4E5),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Text(
                        initials ?? '',
                        style: const TextStyle(
                          color: Color(0xFF526C30),
                          fontSize: 23,
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1C2520),
                              fontSize: 25,
                              fontWeight: .w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            user?.email ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF768079),
                              fontSize: 13,
                              fontWeight: .w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Container(
              height: 85,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                border: Border.all(
                  color: const Color(0xFFE8ECE8),
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    width: 37,
                    height: 37,
                    margin: const EdgeInsets.only(right: 10),
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4E5),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/ic_user.svg',
                      width: 19,
                      height: 19,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          context.push('/profile/personal_information'),
                      child: Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                'profile.personal_info_title'.tr(),
                                style: const TextStyle(
                                  color: Color(0xFF1C2520),
                                  fontSize: 15,
                                  fontWeight: .w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'profile.personal_info_subtitle'.tr(),
                                style: const TextStyle(
                                  color: Color(0xFF768079),
                                  fontSize: 12,
                                  fontWeight: .w400,
                                ),
                              ),
                            ],
                          ),
                          SvgPicture.asset('assets/icons/ic_chevron_right.svg'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: InkWell(
                onTap: () => context.push('/profile/change_password'),
                child: Text(
                  'profile.change_password'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF526C30),
                    fontSize: 14,
                    fontWeight: .w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: InkWell(
                onTap: () => context.read<AuthCubit>().logout(),
                child: Text(
                  'profile.logout'.tr(),
                  style: const TextStyle(
                    color: Color(0xFF526C30),
                    fontSize: 14,
                    fontWeight: .w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
