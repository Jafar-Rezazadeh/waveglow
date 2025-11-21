import 'package:get/get.dart';
import 'package:waveglow/features/home/home_bindings.dart';
import 'package:waveglow/features/main_app/presentation/screens/main_screen.dart';
import 'package:waveglow/features/music_player/music_player_service_bindings.dart';
import 'package:waveglow/features/tracks_list/tracks_list_exports.dart';

const mainScreenRoute = "/main_screen";
const homeRoute = "/home_route";

final getXRoutes = [
  GetPage(
    name: mainScreenRoute,
    page: () => const MainScreen(),
    bindings: [MusicPlayerServiceBindings(), HomeBindings(), TracksListBindings()],
  ),
];
