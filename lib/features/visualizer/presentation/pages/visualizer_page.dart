import 'package:flutter/material.dart';
import 'package:waveglow/features/visualizer/presentation/widgets/visualizer_widget.dart';

class VisualizerPage extends StatelessWidget {
  const VisualizerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [VisualizerWidget()],
      ),
    );
  }
}
