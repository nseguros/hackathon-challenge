import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nossa_app_hackton/src/presentation/pages/splash_page/splash_page.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';

void main() {
  runApp(const AppView());
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstsUtils.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'PT'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstsUtils.primaryColor,
          primary: AppConstsUtils.primaryColor,
          secondary: AppConstsUtils.secondaryColor
        ),
        fontFamily: AppConstsUtils.fontRegular,
        useMaterial3: true,
      ),
      home: const SplashPage()
    );
  }
}
