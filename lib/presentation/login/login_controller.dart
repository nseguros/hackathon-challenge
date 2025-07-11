import 'package:flutter/material.dart';
import 'package:nossa_seguro_app/services/auth_service.dart';

/// Controller responsável por gerenciar o estado e a lógica de negócio da tela de login.
/// Inclui validação, controle de loading, erros e chamada de autenticação.
class LoginController extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isFormValid = false;
  bool isLoading = false;
  String? phoneError;
  String? passwordError;

  final BuildContext context;

  LoginController(this.context) {
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void disposeControllers() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void _validateForm() {
    isFormValid = phoneController.text.isNotEmpty && passwordController.text.isNotEmpty;
    // Limpa erros ao digitar
    if (phoneController.text.isNotEmpty) phoneError = null;
    if (passwordController.text.isNotEmpty) passwordError = null;
    notifyListeners();
  }

  Future<void> login() async {
    bool isValid = true;
    if (phoneController.text.isEmpty) {
      phoneError = 'O número de telemóvel é obrigatório';
      isValid = false;
    } else if (phoneController.text.length < 9) {
      phoneError = 'O número deve ter pelo menos 9 dígitos';
      isValid = false;
    }
    if (passwordController.text.isEmpty) {
      passwordError = 'A senha é obrigatória';
      isValid = false;
    } else if (passwordController.text.length < 4) {
      passwordError = 'A senha deve ter pelo menos 4 caracteres';
      isValid = false;
    }
    notifyListeners();
    if (!isValid) return;
    isLoading = true;
    notifyListeners();
    try {
      final success = await AuthService.login(
        context,
        phoneController.text,
        passwordController.text,
      );
      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Credenciais inválidas. Tente novamente.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao iniciar sessão: [${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
} 