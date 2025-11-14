import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your backend IP
  static const String baseUrl = "http://192.168.100.8:8000";

  static Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  static Future<bool> addUser(Map<String, dynamic> user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error adding user: $e");
      return false;
    }
  }

  static Future<bool> updateUser(
    String userId,
    Map<String, dynamic> user,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  static Future<bool> deleteUser(String userId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/users/$userId'));
      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }
}
