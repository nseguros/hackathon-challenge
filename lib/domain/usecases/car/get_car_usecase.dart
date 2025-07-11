import 'package:nossa_seguros/domain/entities/car.dart';
import 'package:nossa_seguros/mocks/car_mocks.dart';

class GetCarByBrandUsecase {
  Future<List<CarEntity>> call(String brandId) async {
    // This method should return a list of cars based on the provided brand.
    // For now, we will return an mock list as a placeholder.
    // In a real application, this would likely involve fetching data from an API or database.
    return cars_mocks.where((car) => car.brandUuid == brandId).toList();
  }
}
