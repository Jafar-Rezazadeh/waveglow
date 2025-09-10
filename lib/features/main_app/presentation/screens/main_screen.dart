import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/theme/color_palette.dart';
import 'package:waveglow/features/home/presentation/pages/home_page.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_navigator_widget.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_title_bar_widget.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MainTitleBarWidget(),
        Expanded(child: _pageView()),
      ],
    );
  }

  Widget _pageView() {
    return Stack(
      children: [
        HomePage(),
        _navigator(),
      ],
    );
  }

  Widget _navigator() {
    return Positioned(
      left: 24,
      top: 100,
      child: MainNavigatorWidget(
        currentIndex: 0,
      ),
    );
  }
}
