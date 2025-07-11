import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../domain/usecases/car/get_brands_usecase.dart';
import '../../domain/usecases/car/get_car_usecase.dart';
import '../../domain/usecases/escalao/get_escalao_usecase.dart';
import '../../presenter/pages/product_simulator/car_insurance/controller/car_insurance_simulator_controller.dart';

final class DependencyInjection {
  static DependencyInjection? _instance;

  DependencyInjection._();

  factory DependencyInjection() => _instance ??= DependencyInjection._();

  Future<void> setup() async {
    var locator = GetIt.instance;
    // AppDatabase database = AppDatabase();
    // await database.open("nossaseguros.db");

    // Get.put(database);
    Get.put(CarInsuranceSimulatorController());
    Get.put(GetEscalaoUseCase());
    Get.put(GetCarByBrandUsecase());
    Get.put(GetCarBrandsUseCase());
  }
}

abstract class DI {
  static T get<T extends Object>() => GetIt.I.get<T>();
}
