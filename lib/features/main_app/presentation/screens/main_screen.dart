import 'package:flutter/material.dart';
import 'package:waveglow/features/home/presentation/pages/home_page.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_navigator_widget.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_title_bar_widget.dart';
import 'package:waveglow/features/music_player/presentation/widgets/music_player_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final PageController pageViewController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageViewController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MainTitleBarWidget(),
          Expanded(child: _body()),
          MusicPlayerWidget(),
        ],
      ),
    );
  }

  Widget _body() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _pageView(),
        _navigator(),
      ],
    );
  }

  Widget _pageView() {
    return PageView(
      controller: pageViewController,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        HomePage(),
        Text("musicPlaylist"),
        Text("favorites"),
        Text("setting"),
      ],
    );
  }

  Widget _navigator() {
    return Positioned(
      left: 24,
      top: 100,
      child: MainNavigatorWidget(
        currentIndex: currentPage,
        onTab: (int index) {
          setState(() => currentPage = index);
          pageViewController.animateToPage(
            index,
            duration: Durations.medium3,
            curve: Curves.easeInOutCubic,
          );
        },
      ),
    );
  }
}
