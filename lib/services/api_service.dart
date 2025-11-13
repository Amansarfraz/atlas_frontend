import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace this with your FastAPI backend IP & port
  static const String baseUrl = "http://127.0.0.1:8000";

  /// Fetch all users
  static Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to fetch users: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  /// Add a new user
  static Future<bool> addUser(Map<String, dynamic> user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Failed to add user: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error adding user: $e");
      return false;
    }
  }

  /// Update a user
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

  /// Delete a user
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
