import 'package:nossa_seguros/domain/entities/escalao.dart';

import '../../../mocks/escalao_mock.dart';

class GetEscalaoUseCase {
  Future<List<EscalaoCapitalEntity>> call() async {
    return escalao_list_mock;
  }
}
