import 'package:flutter/material.dart';
import 'package:flutter_handy_utils/extensions/string_ellips_size_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:waveglow/core/core_exports.dart';

class MusicPlayerWidget extends StatelessWidget {
  MusicPlayerWidget({super.key});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _musicPlayerService = Get.find<MusicPlayerService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _colorPalette.background,
        border: Border(top: BorderSide(color: _colorPalette.neutral700)),
      ),
      child: _body(),
    );
  }

  Widget _body() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(flex: 3, child: _musicActionsAndInfo()),
          Expanded(flex: 2, child: _musicProgressBar()),
        ],
      ),
    );
  }

  Widget _musicActionsAndInfo() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: _musicInfo()),
        Expanded(child: _actionButtons()),
        Expanded(child: _volume()),
      ],
    );
  }

  Widget _musicInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _musicCover(),
        const Gap(12),
        _musicTitles(),
      ],
    );
  }

  Widget _musicCover() {
    return Obx(
      () => Container(
        height: 48,
        width: 48,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _colorPalette.neutral600,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius1),
        ),
        child: _musicPlayerService.currentMusicMetaData?.albumArt != null
            ? Image.memory(
                _musicPlayerService.currentMusicMetaData!.albumArt!,
                fit: BoxFit.fill,
              )
            : const Icon(Icons.music_note_outlined),
      ),
    );
  }

  Widget _musicTitles() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text((_musicPlayerService.currentMusicMetaData?.trackName ?? "")
              .ellipsSize(maxLength: 40)),
          Text(
            _musicPlayerService.currentMusicMetaData?.trackArtistNames
                    ?.join(" - ")
                    .ellipsSize(maxLength: 40) ??
                "",
            style: TextStyle(color: _colorPalette.neutral400),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _toggleShuffle(),
        _previousBtn(),
        _playPauseBtn(),
        _nextBtn(),
        _repeatBtn(),
      ],
    );
  }

  Widget _toggleShuffle() {
    return Obx(
      () => IconButton(
        onPressed: () async => await _musicPlayerService.toggleShuffle(),
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
          _musicPlayerService.isShuffle ? _colorPalette.neutral600 : null,
        )),
        icon: SvgPicture.asset(AssetSvgs.random),
      ),
    );
  }

  Widget _previousBtn() {
    return IconButton(
      onPressed: () async => await _musicPlayerService.goPrevious(),
      icon: SvgPicture.asset(AssetSvgs.previous),
    );
  }

  Widget _playPauseBtn() {
    return Obx(
      () => IconButton(
        onPressed: () => _musicPlayerService.playOrPause(),
        icon: _musicPlayerService.isPlaying
            ? SvgPicture.asset(AssetSvgs.pause)
            : SvgPicture.asset(AssetSvgs.play),
      ),
    );
  }

  Widget _nextBtn() {
    return IconButton(
      onPressed: () => _musicPlayerService.goNext(),
      icon: SvgPicture.asset(AssetSvgs.next),
    );
  }

  Widget _repeatBtn() {
    return IconButton(
      onPressed: () => _musicPlayerService.cyclePlayListMode(),
      icon: Obx(
        () {
          late String path;
          path = switch (_musicPlayerService.playListMode) {
            PlaylistMode.none => AssetSvgs.noRepeat,
            PlaylistMode.single => AssetSvgs.repeatOne,
            PlaylistMode.loop => AssetSvgs.repeatAll
          };

          return SvgPicture.asset(path);
        },
      ),
    );
  }

  Widget _volume() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AssetSvgs.volumeHigh),
        SizedBox(
          width: 156,
          child: Obx(
            () => Slider(
              min: 0.0,
              max: 100.0,
              value: _musicPlayerService.volume,
              onChanged: (value) => _musicPlayerService.setVolume(value),
            ),
          ),
        ),
      ],
    );
  }

  Widget _musicProgressBar() {
    return Container(
      width: 0.55.sw,
      height: double.infinity,
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 20,
        child: Obx(
          () => Slider(
            min: 0.0,
            max: _musicPlayerService.currentMusicDuration?.inSeconds.toDouble() ?? 0.0,
            value: _musicPlayerService.currentMusicPosition?.inSeconds.toDouble() ?? 0.0,
            onChanged: (value) => _musicPlayerService.setPosition(value),
          ),
        ),
      ),
    );
  }
}
