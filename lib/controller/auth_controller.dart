import 'package:shared_preferences/shared_preferences.dart';
import '../model/signmodel.dart';
import '../repository/signin.dart';


class AuthController {
  final ApiService _apiService = ApiService();

  // Login and save user data
  Future<bool> login(String phone, String password) async {
    LoginResponse? user = await _apiService.login(phone, password);

    if (user != null) {
      await _saveUserData(user);
      return true;
    }
    return false;

  }

  Future<void> _saveUserData(LoginResponse loginResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', loginResponse.token);
    await prefs.setInt('userId', loginResponse.user.id);
    await prefs.setString('userName', loginResponse.user.name);
    await prefs.setString('userPhone', loginResponse.user.phone);
    await prefs.setString('userEmail', loginResponse.user.email);
  }

  // Load user data from SharedPreferences
  Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return null;

    return {
      'token': prefs.getString('token'),
      'id': prefs.getInt('userId'),
      'name': prefs.getString('userName'),
      'phone': prefs.getString('userPhone'),
      'email': prefs.getString('userEmail'),
    };
  }

  // Logout and clear user data
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}