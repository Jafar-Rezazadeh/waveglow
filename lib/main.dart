import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/theme/custom_theme.dart';
import 'package:waveglow/init_bindings.dart';

import 'shared/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  runApp(const WaveGlowScreen());
}

class WaveGlowScreen extends StatelessWidget {
  const WaveGlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: homeRoute,
      getPages: getXRoutes,
      initialBinding: InitBindings(),
      theme: CustomTheme.neonTheme,
    );
  }
}
