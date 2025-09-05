import 'package:get/get.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    // dataSources
    final platformDataSource = HomeVisualizerPlatformDataSourceImpl();

    // repositories
    final repository = VisualizerRepositoryImpl(
        platformDataSource: platformDataSource, failureFactory: FailureFactory());

    // useCases
    final getVisualizerPerceptualBandsStreamUC =
        GetHomeVisualizerPerceptualBandsStreamUC(repository: repository);

    // Controllers
    Get.put(
      HomeVisualizerStateController(
        getVisualizerPerceptualBandsStreamUC: getVisualizerPerceptualBandsStreamUC,
      ),
    );
  }
}
