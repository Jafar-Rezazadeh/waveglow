import 'package:get/get.dart';
import 'package:waveglow/core/errors/failures.dart';
import 'package:waveglow/features/home/home_exports.dart';
import 'package:waveglow/features/home/services/home_audio_bands_service_impl.dart';
import 'package:waveglow/services/home_audio_bands_service.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    // dataSources
    final platformDataSource = HomeVisualizerPlatformDataSourceImpl();

    // repositories
    final repository = VisualizerRepositoryImpl(
      platformDataSource: platformDataSource,
      failureFactory: FailureFactory(),
    );

    // useCases
    final getBandsStreamUC = GetHomeVisualizerPerceptualBandsStreamUC(repository: repository);

    // services
    final audioBandsService = Get.put<HomeAudioBandsService>(
      HomeAudioBandsServiceImpl(getBandsStreamUC: getBandsStreamUC),
    );

    // Controllers
    Get.put(HomeVisualizerStateController(audioBandsService: audioBandsService));
  }
}
