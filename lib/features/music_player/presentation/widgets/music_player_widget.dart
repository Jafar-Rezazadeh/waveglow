import 'package:flutter/material.dart';
import 'package:flutter_handy_utils/extensions/string_ellips_size_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:waveglow/core/core_exports.dart';

class MusicPlayerWidget extends StatelessWidget {
  MusicPlayerWidget({super.key});

  late final _colorPalette = Get.theme.extension<AppColorPalette>()!;
  late final _musicPlayer = Get.find<MusicPlayerService>();

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
        child: _musicPlayer.currentMusicMetaData?.albumArt != null
            ? Image.memory(_musicPlayer.currentMusicMetaData!.albumArt!)
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
          Text((_musicPlayer.currentMusicMetaData?.trackName ?? "").ellipsSize(maxLength: 40)),
          Text(
            _musicPlayer.currentMusicMetaData?.trackArtistNames
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
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AssetSvgs.random),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AssetSvgs.previous),
        ),
        _playPauseBtn(),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AssetSvgs.next),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(AssetSvgs.repeatOne),
        ),
      ],
    );
  }

  Widget _playPauseBtn() {
    return Obx(
      () => IconButton(
        onPressed: () => _musicPlayer.playOrPause(),
        icon: _musicPlayer.isPlaying
            ? SvgPicture.asset(AssetSvgs.pause)
            : SvgPicture.asset(AssetSvgs.play),
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
          child: Slider(
            min: 0.0,
            max: 100.0,
            value: 50,
            onChanged: (value) {},
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
        child: Slider(
          min: 0.0,
          max: 100.0,
          value: 50,
          onChangeEnd: (value) {
            // TODO: set the music progress in this event
          },
          onChanged: (value) {},
        ),
      ),
    );
  }
}
