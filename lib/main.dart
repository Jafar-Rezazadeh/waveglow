import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/core/theme/custom_theme.dart';
import 'package:waveglow/hive_initialization.dart';
import 'package:waveglow/main_injections.dart';

import 'shared/routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await hiveInitialization();
  await mainInjections();

  runApp(const WaveGlowApp());

  doWhenWindowReady(() {
    appWindow.minSize = const Size(800, 600);
    appWindow.size = const Size(1200, 800);
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class WaveGlowApp extends StatelessWidget {
  const WaveGlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: ContextMenuOverlay(
        buttonStyle: ContextMenuButtonStyle(
          fgColor: AppColorPalette().neutral50,
          hoverFgColor: AppColorPalette().neutral50,
          hoverBgColor: AppColorPalette().neutral700,
        ),
        cardBuilder: (context, children) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
            color: AppColorPalette().backgroundLow,
          ),
          clipBehavior: Clip.antiAlias,
          width: 200,
          child: Column(children: children),
        ),
        child: GetMaterialApp(
          initialRoute: mainScreenRoute,
          debugShowCheckedModeBanner: false,
          getPages: getXRoutes,
          theme: CustomTheme.neonTheme,
        ),
      ),
    );
  }
}
