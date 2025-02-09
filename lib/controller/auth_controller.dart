import 'package:classwix_orbit/provider/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/signmodel.dart';
import '../repository/signin.dart';
import 'dart:convert';

var logger = Logger();
class AuthController extends StateNotifier<LoginResponse?> {
  final ApiService _apiService = ApiService();
  static const String _authTokenKey = "token";
  static const String _userDataKey = "user";

  SharedPreferences? prefs;

  AuthController() : super(null) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    _loadUser();
  }

  Future<void> _loadUser() async {
    prefs ??= await SharedPreferences.getInstance();
    final String? token = prefs!.getString(_authTokenKey);
    final String? userJson = prefs!.getString(_userDataKey);
    
    logger.i(" Initial Token: $token");

    if (token != null && userJson != null) {
      final Map<String, dynamic> userData = jsonDecode(userJson);
      userData['token'] = token;
      logger.i(" User data loaded: $userData");

      state = LoginResponse.fromJson(userData);
    } else {
      state = null;
    }
  }

  /// **Get Token Synchronously**
  String? get token =>  prefs?.getString(_authTokenKey);

  Future<bool> login(String phone, String password) async {
    logger.i(" Attempting login for phone: $phone");

    LoginResponse? loginResponse = await _apiService.login(phone, password);
    if (loginResponse != null) {
      await _saveUserData(loginResponse);
      state = loginResponse;
      return true;
    }
    return false;
  }

  Future<void> _saveUserData(LoginResponse loginResponse) async {
    await prefs!.setString(_authTokenKey, loginResponse.token);
    await prefs!.setString(_userDataKey, jsonEncode(loginResponse.toJson()));

    AuthService().storeToken(loginResponse.token.toString());

    logger.i(" User login state saved: ${loginResponse.toJson()}");
  }

  Future<void> logout() async {
    await prefs!.clear();
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthController, LoginResponse?>(
  (ref) => AuthController(),
);
