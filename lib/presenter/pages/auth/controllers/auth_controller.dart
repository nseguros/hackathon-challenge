import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nossa_seguros/mocks/users_mock.dart';

import '../../../../core/error/errorLog.dart';
import '../../../../domain/entities/user.dart';

class AuthController extends ChangeNotifier {
  RxBool showPassword = true.obs;
  RxBool loading = false.obs;
  final usernameFieldController = TextEditingController().obs;
  final passwordFieldController = TextEditingController().obs;

  GlobalKey<FormState> formKey = GlobalKey();

  void setLoading(bool value) {
    loading.value = value;
  }

  Future<UserEntity?> loginAccount(BuildContext context) async {
    try {
      var user = usersMock.firstWhere((element) =>
          element.phoneNumber == usernameFieldController.value.text &&
          element.password == passwordFieldController.value.text);

      return user;
    } catch (error, tracer) {
      errorLog(error, tracer);

      return null;
    }
  }

  static Future<UserEntity?> createTempUser() async {
    try {} catch (error, stackTrace) {
      errorLog(error, stackTrace);
    }

    return null;
  }

  static Future<UserEntity?> checkUserAuthenticated() async {
    try {} catch (error, stackTrace) {
      errorLog(error, stackTrace);
    }
    return null;
  }
}
