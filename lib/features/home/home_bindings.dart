import 'package:get/get.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    // dataSources
    final platformDataSource = VisualizerPlatformDataSourceImpl();

    // repositories
    final repository = VisualizerRepositoryImpl(
        platformDataSource: platformDataSource, failureFactory: FailureFactory());

    // useCases
    final getVisualizerPerceptualBandsStreamUC =
        GetVisualizerPerceptualBandsStreamUC(repository: repository);

    // Controllers
    Get.put(
      VisualizerStateController(
        getVisualizerPerceptualBandsStreamUC: getVisualizerPerceptualBandsStreamUC,
      ),
    );
  }
}
