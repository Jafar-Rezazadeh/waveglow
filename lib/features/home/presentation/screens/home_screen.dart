import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/theme/color_palette.dart';
import 'package:waveglow/features/home/presentation/widgets/visualizer_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.backGround,
      body: const SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VisualizerWidget(),
          ],
        ),
      ),
    );
  }
}
