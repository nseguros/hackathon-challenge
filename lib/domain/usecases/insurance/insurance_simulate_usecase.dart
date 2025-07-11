import 'dart:math';

import '../../entities/seguro.dart';

class InsuranceSimulateUseCase {
  Future<double> execute({required SeguroEntity seguro}) async {
    return Random(695).nextDouble() * 1000;
  }
}
