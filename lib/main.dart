import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nossa_seguros/presenter/onboarding.dart';
import 'package:nossa_seguros/presenter/pages/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

import 'core/configs/setup_app.dart';
import 'core/theme/theme.dart';

void main() async {
  await setupApp();

  runApp(App(
    isDarkMode: false,
  ));
}

class App extends StatelessWidget {
  bool isDarkMode;
  App({required this.isDarkMode});

  //
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthController(),
          )
        ],
        child: Obx(() => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme:
                AppTheme.isDarkMode.value ? AppTheme.darkMode : AppTheme.light,
            home: Onboarding())));
  }
}
