import 'package:hive/hive.dart';
import 'package:waveglow/features/tracks_list/init_tracks_list_hive.dart';

Future<void> hiveInitialization() async {
  await initTracksListHive(Hive);
}
