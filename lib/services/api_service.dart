import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔥 Yahan apna FastAPI backend ka real IP likho
  // Example: http://192.168.100.8:8000
  static const String baseUrl = "http://192.168.100.8:8000";

  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load users");
    }
  }

  static Future<bool> addUser(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
