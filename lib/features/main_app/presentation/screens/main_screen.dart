import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/favorite_songs/presentation/pages/favorite_songs_page.dart';
import 'package:waveglow/features/visualizer/presentation/pages/visualizer_page.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_navigator_widget.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_title_bar_widget.dart';
import 'package:waveglow/features/music_player/presentation/widgets/music_player_widget.dart';
import 'package:waveglow/features/tracks_list/presentation/pages/tracks_list_page.dart';
import 'package:waveglow/core/services/visualizer_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController pageViewController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageViewController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(child: Stack(children: [_pageViewLayout(), MainTitleBarWidget()])),
        MusicPlayerWidget(),
      ],
    );
  }

  Widget _pageViewLayout() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [_pageView(), _navigator()],
    );
  }

  Widget _pageView() {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.toolBarSize),
      child: PageView(
        controller: pageViewController,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const VisualizerPage(),
          Padding(padding: const EdgeInsets.only(left: 106, right: 64), child: TracksListPage()),
          Padding(padding: const EdgeInsets.only(left: 106, right: 64), child: FavoriteSongsPage()),
          const Text("setting"),
        ],
      ),
    );
  }

  Widget _navigator() {
    return Positioned(
      left: 24,
      top: 100,
      child: MainNavigatorWidget(currentIndex: currentPage, onTab: _onNavigationItemTap),
    );
  }

  void _onNavigationItemTap(int index) {
    _toggleAudioVisualization(index);

    setState(() => currentPage = index);
    pageViewController.animateToPage(
      index,
      duration: Durations.medium3,
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _toggleAudioVisualization(int index) async {
    if (index == 0) {
      await Get.find<VisualizerService>().start();
    }
    if (index != 0) {
      await Get.find<VisualizerService>().stop();
    }
  }
}
