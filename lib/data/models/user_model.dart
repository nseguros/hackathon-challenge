import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _phoneNumber = '';

  bool get isLoggedIn => _isLoggedIn;
  String get phoneNumber => _phoneNumber;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _phoneNumber = prefs.getString('phoneNumber') ?? '';
    notifyListeners();
  }

  Future<bool> login(String phoneNumber, String password) async {
    // Mock validation - In a real app, this would call an API
    if (phoneNumber.length >= 9 && password.length >= 4) {
      _isLoggedIn = true;
      _phoneNumber = phoneNumber;
      
      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('phoneNumber', phoneNumber);
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _phoneNumber = '';
    
    // Clear login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('phoneNumber');
    
    notifyListeners();
  }
}