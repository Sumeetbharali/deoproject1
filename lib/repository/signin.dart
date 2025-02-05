import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../model/signmodel.dart';



class AuthRepository {
  final String apiUrl = '$mainUrl/signin';

  Future<LoginResponse?> login(String phone, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'phone': phone,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final loginResponse = LoginResponse.fromJson(data);

      // Save token and user details in Shared Preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginResponse.token);
      await prefs.setInt('userId', loginResponse.user.id);
      await prefs.setString('userName', loginResponse.user.name);
      await prefs.setString('userPhone', loginResponse.user.phone);
      await prefs.setString('userEmail', loginResponse.user.email);

      return loginResponse;
    } else {
      // Handle error
      return null;
    }
  }
}
