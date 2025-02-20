import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/signmodel.dart';
import '../repository/signin_controller.dart';
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
    final String? token = prefs?.getString(_authTokenKey);
    final String? userJson = prefs?.getString(_userDataKey);

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
  String? get token => prefs?.getString(_authTokenKey);

  Future<bool> login(String phone, String password, WidgetRef ref) async {
    logger.i(" Attempting login for phone: $phone $password");

    try {
      LoginResponse? loginResponse = await _apiService.login(phone, password);
      if (loginResponse != null) {
        await _saveUserData(loginResponse, ref);
        state = loginResponse;
        return true;
      }
    } 
    catch (e) {
      logger.e("Login failed: $e");
    }
    return false;
  }

  Future<void> _saveUserData(LoginResponse loginResponse,WidgetRef ref) async {
    if (prefs != null) {
      await prefs!.setString(_authTokenKey, loginResponse.token); ///token
      ref.read(sampleProvider.notifier).saveToken(loginResponse.token);///token
      await prefs!.setString(_userDataKey, jsonEncode(loginResponse.toJson()));///userData

      logger.i(" User login state saved: ${loginResponse.toJson()}");
    } else {
      logger.e("SharedPreferences not initialized.");
    }
  }

  Future<void> logout() async {
    await prefs!.clear();
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthController, LoginResponse?>(
  (ref) => AuthController(),
);
