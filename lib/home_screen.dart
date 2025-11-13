import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'add_user_screen.dart';
import 'update_user_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];

  final String apiUrl =
      "http://<YOUR_BACKEND_IP>:8000/users"; // Replace with your backend URL

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        users = data.map((json) => User.fromJson(json)).toList();
      });
    }
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(Uri.parse("$apiUrl/$userId"));
    if (response.statusCode == 200) {
      fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          User user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text("${user.city}, ${user.country}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UpdateUserScreen(user: user),
                      ),
                    ).then((_) => fetchUsers());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteUser(user.userId),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddUserScreen()),
          ).then((_) => fetchUsers());
        },
      ),
    );
  }
}
