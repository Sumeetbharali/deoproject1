import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiverpodProvider extends StateNotifier<String?> {
  static const String _authTokenKey = 'token';

  RiverpodProvider() : super(null) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_authTokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);
    state = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    state = null;
  }
}

final sampleProvider = StateNotifierProvider<RiverpodProvider, String?>((ref) {
  return RiverpodProvider();
});

//7002169749
