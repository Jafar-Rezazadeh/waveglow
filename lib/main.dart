import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/theme/custom_theme.dart';

import 'shared/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  runApp(const WaveGlowApp());

  doWhenWindowReady(
    () {
      appWindow.minSize = const Size(1200, 800);
      appWindow.alignment = Alignment.center;
      appWindow.show();
    },
  );
}

class WaveGlowApp extends StatelessWidget {
  const WaveGlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        initialRoute: mainScreenRoute,
        debugShowCheckedModeBanner: false,
        getPages: getXRoutes,
        theme: CustomTheme.neonTheme,
      ),
    );
  }
}
