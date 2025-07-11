
import 'package:flutter/material.dart';
import 'package:nossa_seguro_app/app_env.dart';
import 'package:nossa_seguro_app/core/theme.dart';
import 'package:nossa_seguro_app/data/models/user_model.dart';
import 'package:nossa_seguro_app/presentation/auto/auto_insurance_form_screen.dart';
import 'package:nossa_seguro_app/presentation/login/login_screen.dart';
import 'package:nossa_seguro_app/presentation/product/product_selection_screen.dart';
import 'package:nossa_seguro_app/presentation/simulation/simulation_result_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppEnv.supabaseUrl, // Exemplo: https://seu-projeto.supabase.co
    anonKey: AppEnv.supabaseApiKey, // Chave pública do Supabase
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        title: 'NOSSA Seguros',
        theme: appLightTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const ProductSelectionScreen(),
          '/auto_insurance': (context) => const AutoInsuranceFormScreen(),
          '/simulation_result': (context) => const SimulationResultScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();

    // Initialize user model
    final userModel = Provider.of<UserModel>(context, listen: false);
    userModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, _) {
        // Check if the user is logged in
        if (userModel.isLoggedIn) {
          return const ProductSelectionScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
