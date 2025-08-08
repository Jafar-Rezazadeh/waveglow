import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/theme/custom_theme.dart';
import 'package:waveglow/shared/routing/routes.dart';

class WaveGlowScreen extends StatelessWidget {
  const WaveGlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: homeRoute,
      getPages: getXRoutes,
      theme: CustomTheme.neonTheme,
    );
  }
}
