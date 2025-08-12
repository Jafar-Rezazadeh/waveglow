import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/theme/custom_theme.dart';
import 'package:waveglow/injection.dart';

import 'shared/routing/routes.dart';

Future<void> main() async {
  await initInjections();

  runApp(const WaveGlowScreen());
}

// TODO: make a design - find and implement music player package for flutter windows

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
