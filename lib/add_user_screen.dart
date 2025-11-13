import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedCity;
  String? _selectedCountry;

  final List<String> cities = [
    "Karachi",
    "Lahore",
    "Islamabad",
    "Peshawar",
    "Quetta",
  ];
  final List<String> countries = ["Pakistan", "India", "USA", "UK", "UAE"];

  final String apiUrl =
      "http://<YOUR_BACKEND_IP>:8000/users"; // Replace with your backend URL

  Future<void> addUser() async {
    if (_formKey.currentState!.validate()) {
      User user = User(
        userId: _userIdController.text,
        name: _nameController.text,
        fatherName: _fatherNameController.text,
        city: _selectedCity!,
        country: _selectedCountry!,
        age: int.parse(_ageController.text),
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding user')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add User")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(labelText: "User ID"),
                validator: (value) => value!.isEmpty ? "Enter User ID" : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter Name" : null,
              ),
              TextFormField(
                controller: _fatherNameController,
                decoration: InputDecoration(labelText: "Father Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter Father Name" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                items: cities
                    .map(
                      (city) =>
                          DropdownMenuItem(value: city, child: Text(city)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCity = value),
                decoration: InputDecoration(labelText: "City"),
                validator: (value) => value == null ? "Select City" : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedCountry,
                items: countries
                    .map(
                      (country) => DropdownMenuItem(
                        value: country,
                        child: Text(country),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCountry = value),
                decoration: InputDecoration(labelText: "Country"),
                validator: (value) => value == null ? "Select Country" : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Enter Age" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: addUser, child: Text("Add User")),
            ],
          ),
        ),
      ),
    );
  }
}
