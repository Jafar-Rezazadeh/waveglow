import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_handy_utils/flutter_handy_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/presentation/widgets/tracks_list_audio_item_widget.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListPage extends StatelessWidget {
  TracksListPage({super.key});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _controller = Get.find<TracksListStateController>();
  late final _musicPlayerService = Get.find<MusicPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentPlayingMusicDirIndex = _controller.allDirectories.indexWhere(
        (e) => e.dirEntity.id == _musicPlayerService.currentPlaylist?.id,
      );
      return DefaultTabController(
        length: _controller.allDirectories.length,
        initialIndex: currentPlayingMusicDirIndex != -1 ? currentPlayingMusicDirIndex : 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Stack(
            children: [
              Column(
                children: [
                  _tabBar(),
                  Expanded(child: _tabView()),
                ],
              ),
              if (_controller.isLoadingDir)
                Container(
                  color: _colorPalette.backgroundLow.withValues(alpha: 0.2),
                  alignment: Alignment.center,
                  child: const CustomLoadingWidget(),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _tabBar() {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.toolBarSize),
      child: Row(
        children: [
          Obx(
            () => TabBar(
              dividerColor: Colors.transparent,
              tabAlignment: TabAlignment.start,
              unselectedLabelColor: _colorPalette.neutral500,
              labelColor: _colorPalette.neutral100,
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              tabs: _controller.allDirectories.map((e) => _tabItem(e)).toList(),
            ),
          ),
          IconButton(
            onPressed: () => _controller.pickDirectory(),
            icon: const Icon(FontAwesomeIcons.plus),
            iconSize: 16,
            style: ButtonStyle(
              iconColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return _colorPalette.neutral100;
                }
                return _colorPalette.neutral500;
              }),
            ),
          ),
        ],
      ),
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
        ? ListView(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            children: dirTemplate.dirEntity.audios
                .map((e) => TracksListAudioItemWidget(item: e, dirId: dirTemplate.dirEntity.id))
                .toList()
                .withGapInBetween(10),
          )
        : const Center(
            child: Text("مسیر پوشه تغییر کرده یا حذف شده است.", textDirection: TextDirection.rtl),
          );
  }
}
