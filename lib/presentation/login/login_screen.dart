import 'package:flutter/material.dart';
import 'package:nossa_seguro_app/presentation/login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:nossa_seguro_app/shared/custom/custom_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(context),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody({Key? key}) : super(key: key);

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    final controller = context.read<LoginController>();
    controller.disposeControllers();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<LoginController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const LogoHeader(title: 'Vamos começar'),
                        const SizedBox(height: 30),
                        CustomTextField(
                          label: 'Número de Telemóvel',
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          errorText: controller.phoneError,
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Senha',
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible,
                          errorText: controller.passwordError,
                          prefixIcon: const Icon(Icons.key_sharp),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 32),
                        controller.isLoading
                            ? CircularProgressIndicator(color: theme.colorScheme.primary)
                            : GradientButton(
                                text: 'Iniciar Sessão',
                                onPressed: controller.login,
                                isEnabled: controller.isFormValid,
                              ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}