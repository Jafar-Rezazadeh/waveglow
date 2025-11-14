import 'package:flutter/material.dart';
import 'package:waveglow/features/home/presentation/widgets/home_visualizer_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [HomeVisualizerWidget()],
      ),
    );
  }
}
