import 'package:flutter/material.dart';
import 'package:nossa_seguro_app/data/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static void initializeAuth(BuildContext context) {
    // Initialize the user model when the app starts
    Provider.of<UserModel>(context, listen: false).init();
  }

  static Future<bool> login(BuildContext context, String phoneNumber, String password) async {
    try {
      // Converta o telefone para o formato de e-mail, se necessário
      final phone = '$phoneNumber@email.com'; // Ajuste para seu domínio
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: phone,
        password: password,
      );
      if (response.user != null) {
        // Atualize o UserModel se necessário
        await Provider.of<UserModel>(context, listen: false).login(phoneNumber, password);
        return true;
      } else {
        return false;
      }
    } on AuthException catch (e) {
      // Trate o erro de autenticação
      debugPrint('Erro de autenticação: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Erro inesperado: $e');
      return false;
    }
  }

  static Future<void> logout(BuildContext context) async {
    await Provider.of<UserModel>(context, listen: false).logout();
  }

  static bool isLoggedIn(BuildContext context) {
    return Provider.of<UserModel>(context, listen: false).isLoggedIn;
  }
}