import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'add_user_screen.dart';
import 'update_user_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    var data = await ApiService.getUsers();
    setState(() {
      users = data.map((json) => User.fromJson(json)).toList();
    });
  }

  Future<void> deleteUser(String userId) async {
    bool success = await ApiService.deleteUser(userId);
    if (success) fetchUsers();
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
