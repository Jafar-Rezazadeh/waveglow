import 'dart:ui';

import 'package:context_menus/context_menus.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/shared/widgets/audio_list_item_widget.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListPage extends StatelessWidget {
  TracksListPage({super.key});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _controller = Get.find<TracksListStateController>();
  late final _musicPlayerService = Get.find<MusicPlayerService>();

  @override
  Widget build(BuildContext context) {
    return _tabsOfDirectories();
  }

  Widget _tabsOfDirectories() {
    return Obx(() {
      final currentPlayingMusicDirIndex = _controller.allDirectories.indexWhere(
        (e) => e.dirEntity.id == _musicPlayerService.currentPlaylist?.id,
      );
      return DefaultTabController(
        length: _controller.allDirectories.length,
        initialIndex: currentPlayingMusicDirIndex != -1 ? currentPlayingMusicDirIndex : 0,
        child: Stack(
          children: [
            Column(
              children: [
                _tabBar(),
                _controller.allDirectories.isEmpty
                    ? Expanded(child: _emptyInfo())
                    : Expanded(child: _tabView()),
              ],
            ),
            if (_controller.isLoadingDir)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(child: const CustomLoadingWidget()),
              ),
          ],
        ),
      );
    });
  }

  Widget _emptyInfo() {
    return Center(
      child: Obx(
        () => Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "لطفا پوشه مورد نظر را انتخاب کنید",
              style: TextStyle(fontSize: AppSizes.fontSizeMedium),
            ),
            if (_controller.allDirectories.isEmpty) _addDirectoryBtn(filled: true),
          ],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return Obx(
      () => Row(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            unselectedLabelColor: Get.isDarkMode
                ? _colorPalette.neutral300
                : _colorPalette.neutral400,
            labelColor: Get.isDarkMode ? _colorPalette.neutral50 : _colorPalette.neutral900,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            tabs: _controller.allDirectories.map((e) => _tabItem(e)).toList(),
          ),
          if (_controller.allDirectories.isNotEmpty) _addDirectoryBtn(),
        ],
      ),
    );
  }

  Widget _addDirectoryBtn({bool filled = false}) {
    return filled
        ? IconButton.filled(
            onPressed: () => _controller.pickDirectory(),
            iconSize: 16,
            icon: const Icon(FontAwesomeIcons.plus),
          )
        : IconButton(
            onPressed: () => _controller.pickDirectory(),
            iconSize: 16,
            icon: const Icon(FontAwesomeIcons.plus),
          );
  }

  Widget _tabItem(TracksListDirectoryTemplate e) {
    return ContextMenuRegion(
      contextMenu: GenericContextMenu(
        buttonConfigs: [
          ContextMenuButtonConfig('حذف', onPressed: () => _controller.removeDirectory(e)),
        ],
      ),
      child: Text(e.dirEntity.directoryName),
    );
  }

  Widget _tabView() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Obx(
        () => TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _controller.allDirectories.map((e) => _tabViewItem(e)).toList(),
        ),
      ),
    );
  }

  Widget _tabViewItem(TracksListDirectoryTemplate dirTemplate) {
    return dirTemplate.isExists
        ? DynMouseScroll(
            durationMS: 200,
            builder: (_, controller, physics) => ListView.separated(
              controller: controller,
              physics: physics,
              itemCount: dirTemplate.dirEntity.audios.length,
              padding: const EdgeInsets.only(bottom: 16),
              separatorBuilder: (context, index) => Gap(8),
              itemBuilder: (context, index) {
                final item = dirTemplate.dirEntity.audios[index];
                return AudioListItemWidget(
                  item: item,
                  onTap: () => _controller.playTrack(item),
                  onFavoriteTap: () => _controller.toggleAudioFavorite(item),
                );
              },
            ),
          )
        : const Center(
            child: Text("مسیر پوشه تغییر کرده یا حذف شده است.", textDirection: TextDirection.rtl),
          );
  }
}
