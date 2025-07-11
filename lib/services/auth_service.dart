import 'package:flutter/material.dart';
import 'package:nossa_seguro_app/data/models/user_model.dart';
import 'package:provider/provider.dart';

class AuthService {
  static void initializeAuth(BuildContext context) {
    // Initialize the user model when the app starts
    Provider.of<UserModel>(context, listen: false).init();
  }

  static Future<bool> login(BuildContext context, String phoneNumber, String password) async {
    return await Provider.of<UserModel>(context, listen: false).login(phoneNumber, password);
  }

  static Future<void> logout(BuildContext context) async {
    await Provider.of<UserModel>(context, listen: false).logout();
  }

  static bool isLoggedIn(BuildContext context) {
    return Provider.of<UserModel>(context, listen: false).isLoggedIn;
  }
}