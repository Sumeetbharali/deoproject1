import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

var logger = Logger();

class AuthService extends StateNotifier<String?> {
  static const String _authTokenKey = 'authToken';
  SharedPreferences? _prefs;

  AuthService() : super(null) {
    _loadToken();
  }

    void _loadToken() {
    state = _prefs?.getString(_authTokenKey);
    logger.i("Token Loaded: $state");
  }

  Future<void> storeToken(String token) async {
    await _prefs!.setString(_authTokenKey, token);
    state = token;
    logger.d("Token Stored: $token");
    logger.d("Token Stored: $state");
  }

  // String? getToken() {   // oneline implementation
  //   return state; 
  // }

  Future<String?> getToken() async {
    logger.i('Getting token');
    return _prefs?.getString(_authTokenKey);
  }

  Future<void> deleteToken() async {
    await _prefs!.remove(_authTokenKey);
    state = null;
    logger.w("Token Removed");
  }
 
}

final authServiceProvider = StateNotifierProvider<AuthService, String?>((ref) {
  return AuthService();
});

