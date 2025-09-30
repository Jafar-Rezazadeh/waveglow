import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/home/presentation/pages/home_page.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_navigator_widget.dart';
import 'package:waveglow/features/main_app/presentation/widgets/main_title_bar_widget.dart';
import 'package:waveglow/features/music_player/presentation/widgets/music_player_widget.dart';
import 'package:waveglow/features/tracks_list/presentation/pages/tracks_list_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _musicService = Get.find<MusicPlayerService>();
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
      body: _body(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _pageViewLayout(),
              MainTitleBarWidget(),
            ],
          ),
        ),
        MusicPlayerWidget(),
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(allowMultiple: true);

        if (result != null && result.count > 0) {
          _musicService.open(result.files.map((e) => Media(e.path ?? "")).toList());
        }
      },
      child: const Icon(Icons.file_open),
    );
  }

  Widget _pageViewLayout() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
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
      children: [
        const HomePage(),
        TracksListPage(),
        const Text("favorites"),
        const Text("setting"),
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
