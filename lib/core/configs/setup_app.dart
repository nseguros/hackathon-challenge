import 'package:flutter/cupertino.dart';

import '../../utils/currency.dart';
import '../di/dependecy_injection.dart';
import '../theme/theme.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await DependencyInjection().setup();
  await AppTheme.loadThemeMode();
  await AppCurrencyFormat.init();
}
