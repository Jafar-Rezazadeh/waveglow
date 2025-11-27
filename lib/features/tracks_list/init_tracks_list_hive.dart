import 'package:hive/hive.dart';
import 'package:waveglow/core/constants/enums.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

Future<void> initTracksListHive(HiveInterface hive) async {
  Hive.registerAdapter(TracksListDirectoryModelAdapter());
  await hive.openBox<TracksListDirectoryModel>(HiveBoxEnum.tracksList.value);
}
