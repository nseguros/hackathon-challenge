import 'package:nossa_seguros/domain/entities/car_brand.dart';
import 'package:nossa_seguros/mocks/car_mocks.dart';

class GetCarBrandsUseCase {
  Future<List<CarBrandEntity>> call() async {
    return await car_brands_mocks; //Simulados
  }
}
