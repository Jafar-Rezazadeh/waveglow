import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:waveglow/features/favorite_songs/presentation/state_controllers/favorite_songs_state_controller.dart';
import 'package:waveglow/shared/entities/audio_item_entity.dart';
import 'package:waveglow/shared/widgets/audio_list_item_widget.dart';

class FavoriteSongsPage extends StatelessWidget {
  FavoriteSongsPage({super.key});

  late final _controller = Get.find<FavoriteSongsStateController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          Expanded(child: _listOfSongs()),
        ],
      ),
    );
  }

  Widget _header() {
    return Text("favorites".tr, style: TextStyle(fontWeight: FontWeight.bold));
  }

  Widget _listOfSongs() {
    return Obx(
      () => _controller.allFavoriteSongs.isEmpty
          ? Center(child: Text("favoriteSongsNotSelected".tr))
          : DynMouseScroll(
              durationMS: 500,
              builder: (_, controller, physics) => ListView.separated(
                controller: controller,
                physics: physics,
                itemCount: _controller.allFavoriteSongs.length,
                itemBuilder: (context, index) => _audioItem(_controller.allFavoriteSongs[index]),
                separatorBuilder: (context, index) => Gap(8),
              ),
            ),
    );
  }

  Widget _audioItem(AudioItemEntity e) {
    return AudioListItemWidget(
      item: e,
      onTap: () => _controller.playTrack(e),
      onFavoriteTap: () => _controller.toggleFavorite(e),
    );
  }
}
