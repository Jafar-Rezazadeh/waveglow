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
    return DefaultTabController(
      length: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 90),
        child: Column(
          children: [
            _tabBar(),
            Expanded(child: _tabView()),
          ],
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
              tabs: const [
                Text("tab1"),
                Text("tab2"),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
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

  Widget _tabView() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text("tab 1"),
          Text("tab 2"),
        ],
      ),
    );
  }
}
