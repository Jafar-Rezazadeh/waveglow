import 'package:get/get.dart';
import 'package:waveglow/features/home/home_bindings.dart';
import 'package:waveglow/features/home/presentation/screens/home_screen.dart';

const homeRoute = "/home_route";

final getXRoutes = [
  GetPage(
    name: homeRoute,
    page: () => HomeScreen(),
    binding: HomeBindings(),
  ),
];
