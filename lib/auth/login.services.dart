import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';

class AuthService {
  static const String apiUrl = "http://localhost:5000";
  final CookieJar cookieJar = CookieJar();

  // Login method adjusted for Flask API
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$apiUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": username, "password": password}),
    );

    if (response.statusCode == 200) {
      // No cookies are set on Flask side, but we can still check for session
      return true;
    }
    return false;
  }

  // Logout method adjusted for Flask API
  Future<void> logout() async {
    await http.post(
      Uri.parse("$apiUrl/logout"),
      headers: {"Content-Type": "application/json"},
    );
    // No need for cookie management, Flask handles session management
  }

  // Check session method adjusted for Flask API
  Future<bool> checkSession() async {
    final response = await http.get(
      Uri.parse("$apiUrl/check_session"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['message'] == 'User is logged in';
    }
    return false;
  }

  // Get user profile method adjusted for Flask API
  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse("$apiUrl/profile"),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load profile");
    }
  }
}
