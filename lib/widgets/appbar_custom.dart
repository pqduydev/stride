import 'package:flutter/material.dart';

class AppbarCustom extends StatelessWidget {
  const AppbarCustom({super.key, required this.title});

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      scrolledUnderElevation: 0,
      title: title,
    );
  }
}
