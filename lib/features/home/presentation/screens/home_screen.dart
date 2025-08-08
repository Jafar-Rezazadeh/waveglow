import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/theme/color_palette.dart';
import 'package:waveglow/core/utils/method_channel_test.dart';
import 'package:waveglow/features/visualizer/presentation/widgets/visualizer_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _channelTest = Get.put(ChannelTest());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.backGround,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const VisualizerWidget(),
            _eventListenerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _eventListenerWidget() {
    return Column(
      children: [
        Obx(() => Text(_channelTest.eventChannelData)),
        FilledButton(
          onPressed: () {
            _channelTest.startListeningToEvent();
          },
          child: const Text("Start"),
        ),
        FilledButton(
          onPressed: () {
            _channelTest.stopListeningToEvent();
          },
          child: const Text("Stop"),
        ),
      ],
    );
  }
}
