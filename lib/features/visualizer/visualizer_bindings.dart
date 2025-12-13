import 'package:get/get.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/visualizer/visualizer_exports.dart';
import 'package:waveglow/core/services/visualizer_service.dart';

class VisualizerPageBindings extends Bindings {
  @override
  void dependencies() {
    // dataSources
    final platformDataSource = VisualizerPlatformDataSourceImpl();

    // repositories
    final repository = VisualizerRepositoryImpl(
      platformDataSource: platformDataSource,
      failureFactory: FailureFactory(),
    );

    // useCases
    final getBandsStreamUC = GetVisualizerFrequencyBandsStreamUC(repository: repository);

    // services
    final audioBandsService = Get.put<VisualizerService>(
      VisualizerServiceImpl(getBandsStreamUC: getBandsStreamUC),
    );

    // Controllers
    Get.put(VisualizerStateController(audioBandsService: audioBandsService));
  }
}
