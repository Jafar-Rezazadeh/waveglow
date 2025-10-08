import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

class TracksListPage extends StatelessWidget {
  TracksListPage({super.key});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _controller = Get.find<TracksListStateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        length: _controller.allDirectories.length,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Column(
            children: [
              _tabBar(),
              Expanded(child: _tabView()),
            ],
          ),
        ),
      ),
    );
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
            style: ButtonStyle(iconColor: WidgetStateColor.resolveWith(
              (states) {
                if (states.contains(WidgetState.hovered)) {
                  return _colorPalette.neutral100;
                }
                return _colorPalette.neutral500;
              },
            )),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(TracksListDirectoryEntity e) {
    return ContextMenuRegion(
      contextMenu: GenericContextMenu(
        buttonConfigs: [
          ContextMenuButtonConfig(
            'حذف',
            onPressed: () => _controller.removeDirectory(e),
          )
        ],
      ),
      child: Text(e.directoryName),
    );
  }

  Widget _tabView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      child: Obx(
        () => TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: _controller.allDirectories.map((e) => _tabViewItem(e)).toList(),
        ),
      ),
    );
  }

  Widget _tabViewItem(TracksListDirectoryEntity e) {
    return ListView(
      children: e.audios.map((e) => Text(e.trackName?.removeAllWhitespace ?? "")).toList(),
    );
  }
}
