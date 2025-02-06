import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/signmodel.dart';
import '../core/constants/api_endpoint.dart';

class ApiService {
  final String apiUrl = '$mainUrl/signin';

  // Login API request
  Future<LoginResponse?> login(String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
