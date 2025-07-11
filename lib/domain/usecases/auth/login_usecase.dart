import 'package:nossa_seguros/domain/entities/user.dart';

class LoginUsecase {
  Future<UserEntity?> execute(String phoneNumber, String password) async {
    print('Logging in with username: $phoneNumber and password: $password');
  }
}
