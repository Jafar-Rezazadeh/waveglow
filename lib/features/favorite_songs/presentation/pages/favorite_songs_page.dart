import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waveglow/features/favorite_songs/presentation/state_controllers/favorite_songs_state_controller.dart';
import 'package:waveglow/shared/entities/audio_item_entity.dart';
import 'package:waveglow/shared/widgets/audio_list_item_widget.dart';

class FavoriteSongsPage extends StatelessWidget {
  FavoriteSongsPage({super.key});

  late final _controller = Get.find<FavoriteSongsStateController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        _header(),
        Expanded(child: _listOfSongs()),
      ],
    );
  }

  Widget _header() {
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Text("علاقمندی ها", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _listOfSongs() {
    return Obx(
      () => ListView(children: _controller.allFavoriteSongs.map((e) => _audioItem(e)).toList()),
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
