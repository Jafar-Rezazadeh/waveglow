import 'package:hive/hive.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

Future<void> initTracksListHive(HiveInterface hive) async {
  await hive.openBox<TracksListDirectoryEntity>(TracksListConstants.tracksListDirectoryBoxName);
}
