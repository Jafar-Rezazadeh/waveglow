import 'package:get/get.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';

Future<void> visualizerInjection() async {
  // data-sources
  final platformDataSource = VisualizerPlatformDataSourceImpl();

  // repositories
  final repository = VisualizerRepositoryImpl(
    platformDataSource: platformDataSource,
    failureFactory: FailureFactory(),
  );

  // useCases
  final getVisualizerLiveBandsUC = GetVisualizerPerceptualBandsStreamUC(repository: repository);
  // controllers
  Get.put(
    VisualizerStateController(
      getVisualizerPerceptualBandsStreamUC: getVisualizerLiveBandsUC,
    ),
  );
}
